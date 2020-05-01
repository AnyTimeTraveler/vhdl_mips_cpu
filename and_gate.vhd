library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity and_gate is
	port(
		a : in  std_ulogic;
		b : in  std_ulogic;
		c : out std_ulogic
	);
end entity and_gate;

architecture RTL of and_gate is

begin
	c <= a and b;
end architecture RTL;
