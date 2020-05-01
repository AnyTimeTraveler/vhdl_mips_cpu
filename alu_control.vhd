library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control is
	port(
		alu_op   : in  std_ulogic_vector(1 downto 0);
		func     : in  std_ulogic_vector(5 downto 0);
		alu_ctrl : out std_ulogic_vector(3 downto 0)
	);

end entity alu_control;

architecture RTL of alu_control is

begin
	process(alu_op, func) is
	begin
		case alu_op is
			when "00" => alu_ctrl <= "0010"; -- add
			when "01" => alu_ctrl <= "0110"; -- sub
			when "10" =>
				case func is
					when "100000" => alu_ctrl <= "0010"; -- add
					when "100010" => alu_ctrl <= "0110"; -- sub
					when "100100" => alu_ctrl <= "0000"; -- and
					when "100101" => alu_ctrl <= "0001"; -- or
					when "101010" => alu_ctrl <= "0111"; -- less-than
					when others   => null;
				end case;

			when others => null;
		end case;

	end process;

end architecture RTL;
