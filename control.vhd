library ieee;
use ieee.std_logic_1164.std_ulogic;
use ieee.std_logic_1164.std_ulogic_vector;
use ieee.numeric_std.all;

entity control is
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
end entity control;

architecture RTL of control is

begin

	process(op) is
	begin
		case op is
			when "000000" =>            -- R-type
				reg_dst    <= '1';
				alu_src    <= '0';
				mem_to_reg <= '0';
				reg_write  <= '1';
				mem_write  <= '0';
				branch     <= '0';
				alu_op     <= "10";
			when "100011" =>            -- load word 
				reg_dst    <= '0';
				alu_src    <= '1';
				mem_to_reg <= '1';
				reg_write  <= '1';
				mem_write  <= '0';
				branch     <= '0';
				alu_op     <= "00";
			when "101011" =>            -- store word
				reg_dst    <= '0';      -- X
				alu_src    <= '1';
				mem_to_reg <= '0';      -- X
				reg_write  <= '0';
				mem_write  <= '1';
				branch     <= '0';
				alu_op     <= "00";
			when "000100" =>            -- beq
				reg_dst    <= '0';      -- X
				alu_src    <= '0';
				mem_to_reg <= '0';      -- X
				reg_write  <= '0';
				mem_write  <= '0';
				branch     <= '1';
				alu_op     <= "01";
			when others => null;
		end case;

	end process;

end architecture RTL;
