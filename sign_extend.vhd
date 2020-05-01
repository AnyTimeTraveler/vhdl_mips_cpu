library ieee;
use ieee.std_logic_1164.std_ulogic;
use ieee.std_logic_1164.std_ulogic_vector;
use ieee.numeric_std.all;

entity sign_extend is
	generic(
		size : integer := 32
	);
	port(
		input  : in  std_ulogic_vector(15 downto 0);
		output : out std_ulogic_vector(size - 1 downto 0)
	);
end entity sign_extend;

architecture RTL of sign_extend is

begin
	output(15 downto 0) <= input;
	with input(15) select output(size - 1 downto 16) <=
		(others => '0') when '0',
		(others => '1') when '1',(others => '-') when others;
end architecture RTL;
