library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips_cpu is
	generic(
		size : integer := 32
	);
	port(
		clk : in std_ulogic;
		rst : in std_ulogic
	);
end entity mips_cpu;

architecture RTL of mips_cpu is
	component register_bank
		generic(
			data_width : integer;
			size       : integer
		);
		port(
			clk                  : in  std_ulogic;
			data_in_write_enable : in  std_ulogic;
			data_in_address      : in  std_ulogic_vector(size - 1 downto 0);
			data_in              : in  std_ulogic_vector(data_width - 1 downto 0);
			data_a_address       : in  std_ulogic_vector(size - 1 downto 0);
			data_a_out           : out std_ulogic_vector(data_width - 1 downto 0);
			data_b_address       : in  std_ulogic_vector(size - 1 downto 0);
			data_b_out           : out std_ulogic_vector(data_width - 1 downto 0)
		);
	end component register_bank;

	component alu
		generic(
			size : integer
		);
		port(
			control   : in  std_ulogic_vector(3 downto 0);
			operand_a : in  std_ulogic_vector(size - 1 downto 0);
			operand_b : in  std_ulogic_vector(size - 1 downto 0);
			result    : out std_ulogic_vector(size - 1 downto 0);
			zero      : out std_ulogic
		);

	end component alu;

	component alu_control
		port(
			alu_op   : in  std_ulogic_vector(1 downto 0);
			func     : in  std_ulogic_vector(5 downto 0);
			alu_ctrl : out std_ulogic_vector(3 downto 0)
		);
	end component alu_control;

	component control
		port(
			op         : in  std_ulogic_vector(5 downto 0);
			reg_dst    : out std_ulogic;
			branch     : out std_ulogic;
			mem_to_reg : out std_ulogic;
			alu_op     : out std_ulogic_vector(1 downto 0);
			mem_write  : out std_ulogic;
			alu_src    : out std_ulogic;
			reg_write  : out std_ulogic
		);
	end component control;

	component instruction_decoder
		port(
			instruction : in  std_ulogic_vector(31 downto 0);
			op          : out std_ulogic_vector(5 downto 0);
			rs          : out std_ulogic_vector(4 downto 0);
			rt          : out std_ulogic_vector(4 downto 0);
			rd          : out std_ulogic_vector(4 downto 0);
			shamt       : out std_ulogic_vector(4 downto 0);
			funct       : out std_ulogic_vector(5 downto 0);
			imme16      : out std_ulogic_vector(15 downto 0)
		);
	end component instruction_decoder;

	component program_counter
		generic(size : integer);
		port(
			clk      : in  std_ulogic;
			rst      : in  std_ulogic;
			data_in  : in  std_ulogic_vector(size - 1 downto 0);
			data_out : out std_ulogic_vector(size - 1 downto 0)
		);
	end component program_counter;

	component ram
		generic(
			data_width : integer;
			size       : integer
		);
		port(
			clk                  : in  std_ulogic;
			data_in_write_enable : in  std_ulogic;
			address              : in  std_ulogic_vector(size - 1 downto 0);
			data_in              : in  std_ulogic_vector(data_width - 1 downto 0);
			data_out             : out std_ulogic_vector(data_width - 1 downto 0)
		);
	end component ram;

	component sign_extend
		generic(size : integer);
		port(
			input  : in  std_ulogic_vector(15 downto 0);
			output : out std_ulogic_vector(size - 1 downto 0)
		);
	end component sign_extend;

	component mux
		generic(
			size : integer
		);
		port(
			switch    : in  std_ulogic;
			data_in_0 : in  std_ulogic_vector(size - 1 downto 0);
			data_in_1 : in  std_ulogic_vector(size - 1 downto 0);
			data_out  : out std_ulogic_vector(size - 1 downto 0)
		);
	end component mux;

	component instruction_memory
		generic(size : integer);
		port(
			address     : in  std_ulogic_vector(size - 1 downto 0);
			instruction : out std_ulogic_vector(size - 1 downto 0)
		);
	end component instruction_memory;

	component funcs
		generic(size : integer);
		port(
			pc                     : in  std_ulogic_vector(size - 1 downto 0);
			offset                 : in  std_ulogic_vector(size - 1 downto 0);
			pc_plus_four           : out std_ulogic_vector(size - 1 downto 0);
			pc_plus_four_plus_jump : out std_ulogic_vector(size - 1 downto 0)
		);
	end component funcs;

	signal instruction               : std_ulogic_vector(size - 1 downto 0);
	signal op                        : std_ulogic_vector(5 downto 0);
	signal rs                        : std_ulogic_vector(4 downto 0);
	signal rt                        : std_ulogic_vector(4 downto 0);
	signal rd                        : std_ulogic_vector(4 downto 0);
	signal shamt                     : std_ulogic_vector(4 downto 0); -- @suppress "signal shamt is never read"
	signal funct                     : std_ulogic_vector(5 downto 0);
	signal imme16                    : std_ulogic_vector(15 downto 0);
	signal reg_dst                   : std_ulogic;
	signal branch                    : std_ulogic;
	signal mem_to_reg                : std_ulogic;
	signal alu_op                    : std_ulogic_vector(1 downto 0);
	signal mem_write                 : std_ulogic;
	signal alu_src                   : std_ulogic;
	signal reg_write                 : std_ulogic;
	signal alu_ctrl                  : std_ulogic_vector(3 downto 0);
	signal alu_operand_a             : std_ulogic_vector(size - 1 downto 0);
	signal alu_operand_b             : std_ulogic_vector(size - 1 downto 0);
	signal alu_result                : std_ulogic_vector(size - 1 downto 0);
	signal zero                      : std_ulogic;
	signal sign_extended_instruction : std_ulogic_vector(size - 1 downto 0);
	signal reg_write_data            : std_ulogic_vector(size - 1 downto 0);
	signal reg_b_out                 : std_ulogic_vector(size - 1 downto 0);
	signal reg_write_address         : std_ulogic_vector(4 downto 0);
	signal ram_out                   : std_ulogic_vector(size - 1 downto 0);
	signal pc_in                     : std_ulogic_vector(size - 1 downto 0);
	signal pc_out                    : std_ulogic_vector(size - 1 downto 0);
	signal branch_and_zero           : std_ulogic;
	signal pc_plus_four              : std_ulogic_vector(size - 1 downto 0);
	signal pc_plus_jump              : std_ulogic_vector(size - 1 downto 0);

begin
	branch_and_zero <= branch and zero;

	funcs_module : component funcs
		generic map(
			size => size
		)
		port map(
			pc                     => pc_out,
			offset                 => sign_extended_instruction,
			pc_plus_four           => pc_plus_four,
			pc_plus_four_plus_jump => pc_plus_jump
		);

	pc_source_mux : component mux
		generic map(
			size => size
		)
		port map(
			switch    => branch_and_zero,
			data_in_0 => pc_plus_four,
			data_in_1 => pc_plus_jump,
			data_out  => pc_in
		);

	pc : program_counter
		generic map(
			size => size
		)
		port map(
			clk      => clk,
			rst      => rst,
			data_in  => pc_in,
			data_out => pc_out
		);

	ins_mem : component instruction_memory
		generic map(size => size
		           )
		port map(
			address     => pc_out,
			instruction => instruction
		);

	main_decoder : instruction_decoder
		port map(
			instruction => instruction(31 downto 0),
			op          => op,
			rs          => rs,
			rt          => rt,
			rd          => rd,
			shamt       => shamt,
			funct       => funct,
			imme16      => imme16
		);

	main_ctrl : control
		port map(
			op         => op,
			reg_dst    => reg_dst,
			branch     => branch,
			mem_to_reg => mem_to_reg,
			alu_op     => alu_op,
			mem_write  => mem_write,
			alu_src    => alu_src,
			reg_write  => reg_write
		);

	reg_write_register_mux : component mux
		generic map(
			size => 5
		)
		port map(
			switch    => reg_dst,
			data_in_0 => rt,
			data_in_1 => rd,
			data_out  => reg_write_address
		);

	registers : component register_bank
		generic map(
			data_width => size,
			size       => 5
		)
		port map(
			clk                  => clk,
			data_in_write_enable => reg_write,
			data_in_address      => reg_write_address,
			data_in              => reg_write_data,
			data_a_address       => rs,
			data_a_out           => alu_operand_a,
			data_b_address       => rt,
			data_b_out           => reg_b_out
		);

	alu_operand_b_mux : component mux
		generic map(
			size => size
		)
		port map(
			switch    => alu_src,
			data_in_0 => reg_b_out,
			data_in_1 => sign_extended_instruction,
			data_out  => alu_operand_b
		);

	main_alu_control : alu_control
		port map(
			alu_op   => alu_op,
			func     => funct,
			alu_ctrl => alu_ctrl
		);

	main_alu : alu
		generic map(
			size => size
		)
		port map(
			control   => alu_ctrl,
			operand_a => alu_operand_a,
			operand_b => alu_operand_b,
			result    => alu_result,
			zero      => zero
		);

	mem_to_reg_mux : mux
		generic map(
			size => size
		)
		port map(
			switch    => mem_to_reg,
			data_in_0 => alu_result,
			data_in_1 => ram_out,
			data_out  => reg_write_data
		);
	alu_operand_sign_extend : sign_extend
		generic map(
			size => size
		)
		port map(
			input  => imme16,
			output => sign_extended_instruction
		);

	main_ram : component ram
		generic map(
			data_width => size,
			size       => 5
		)
		port map(
			clk                  => clk,
			data_in_write_enable => mem_write,
			address              => alu_result(4 downto 0),
			data_in              => reg_b_out,
			data_out             => ram_out
		);

end architecture RTL;
