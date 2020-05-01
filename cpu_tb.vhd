library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_tb is
end entity cpu_tb;

architecture RTL of cpu_tb is
	component mips_cpu
		generic(size : integer);
		port(
			clk : in std_ulogic;
			rst : in std_ulogic
		);
	end component mips_cpu;
	signal clk : std_ulogic := '0';
	signal rst : std_ulogic;
begin
	cpu : mips_cpu
		generic map(
			size => 32
		)
		port map(
			clk => clk,
			rst => rst
		);
	clock_gen : process is
	begin
		rst <= '0';
		wait for 100 ps;
		clk <= '1';
		wait for 100 ps;
		clk <= '0';
	end process clock_gen;

end architecture RTL;
