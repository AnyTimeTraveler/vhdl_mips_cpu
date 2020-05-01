library ieee;
use ieee.std_logic_1164.std_ulogic;
use ieee.std_logic_1164.std_ulogic_vector;
use ieee.numeric_std.all;

entity mux is
	generic(
		size : integer := 0
	);
	port(
		switch    : in  std_ulogic;
		data_in_0 : in  std_ulogic_vector(size - 1 downto 0);
		data_in_1 : in  std_ulogic_vector(size - 1 downto 0);
		data_out  : out std_ulogic_vector(size - 1 downto 0)
	);
end entity mux;

architecture RTL of mux is
begin
	with switch select data_out <=
		data_in_1 when '1',
		data_in_0 when '0',
          data_in_0 when others;
end architecture RTL;
