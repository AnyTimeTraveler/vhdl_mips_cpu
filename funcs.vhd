library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity funcs is
	generic(
		size : integer := 32
	);
	port(
		pc                     : in  std_ulogic_vector(size - 1 downto 0);
		offset                 : in  std_ulogic_vector(size - 1 downto 0);
		pc_plus_four           : out std_ulogic_vector(size - 1 downto 0);
		pc_plus_four_plus_jump : out std_ulogic_vector(size - 1 downto 0)
	);
end entity funcs;

architecture RTL of funcs is
	signal pc_num                         : signed(size - 1 downto 0);
	signal offset_num                     : signed(size - 1 downto 0);
	signal pc_num_plus_four               : signed(size - 1 downto 0);
	signal pc_num_plus_four_plus_jump     : signed(size * 2 - 1 downto 0);
	signal pc_num_plus_four_plus_jump_vec : std_ulogic_vector(size * 2 - 1 downto 0);
begin
	pc_num                     <= signed(pc);
	offset_num                 <= signed(offset);
	pc_num_plus_four           <= pc_num + 4;
	pc_num_plus_four_plus_jump <= pc_num_plus_four + offset_num * 4;

	pc_plus_four                   <= std_ulogic_vector(pc_num_plus_four);
	pc_num_plus_four_plus_jump_vec <= std_ulogic_vector(pc_num_plus_four_plus_jump);
	pc_plus_four_plus_jump         <= pc_num_plus_four_plus_jump_vec(size - 1 downto 0);
end architecture RTL;
