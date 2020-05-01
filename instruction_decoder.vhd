library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_decoder is
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
end entity instruction_decoder;

architecture RTL of instruction_decoder is

begin
	op     <= instruction(31 downto 26);
	rs     <= instruction(25 downto 21);
	rt     <= instruction(20 downto 16);
	rd     <= instruction(15 downto 11);
	shamt  <= instruction(10 downto 6);
	funct  <= instruction(5 downto 0);
	imme16 <= instruction(15 downto 0);
end architecture RTL;
