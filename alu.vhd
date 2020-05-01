library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	generic(
		size : integer := 32
	);
	port(
		control   : in  std_ulogic_vector(3 downto 0);
		operand_a : in  std_ulogic_vector(size - 1 downto 0);
		operand_b : in  std_ulogic_vector(size - 1 downto 0);
		result    : out std_ulogic_vector(size - 1 downto 0);
		zero      : out std_ulogic
	);
end entity alu;

architecture RTL of alu is
begin
	process(control, operand_a, operand_b)
	begin
		case control is
			when "0000" =>
				result <= operand_a and operand_b;
			when "0001" =>
				result <= operand_a or operand_b;
			when "0010" =>
				result <= std_ulogic_vector(unsigned(operand_a) + unsigned(operand_b));
			when "0110" =>
				result <= std_ulogic_vector(unsigned(operand_a) - unsigned(operand_b));
			when "1100" =>
				result <= operand_a nor operand_b;
			when "0111" =>
				if operand_a < operand_b then -- set-on-less-than
					zero   <= '1';
					result <= (others => '0');
				else
					zero   <= '0';
					result <= (others => '0');
				end if;
			when others =>
				result <= (others => '0');
				zero   <= '0';
		end case;
	end process;
end architecture RTL;
