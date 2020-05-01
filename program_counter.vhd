library ieee;
use ieee.std_logic_1164.std_ulogic;
use ieee.std_logic_1164.std_ulogic_vector;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
	generic(
		size : integer := 32
	);
	port(
		clk      : in  std_ulogic;
		rst      : in  std_ulogic;
		data_in  : in  std_ulogic_vector(size - 1 downto 0);
		data_out : out std_ulogic_vector(size - 1 downto 0)
	);
end entity program_counter;

architecture RTL of program_counter is
	signal current_value : std_ulogic_vector(size - 1 downto 0);
begin
	process(clk, rst) is
	begin
		if rst = '1' then
			current_value <= (others => '0');
		elsif clk'EVENT and clk = '1' then
			current_value <= data_in;
		end if;
	end process;

	data_out <= current_value;
end architecture RTL;
