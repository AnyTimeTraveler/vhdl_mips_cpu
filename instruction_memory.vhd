library ieee;
use ieee.std_logic_1164.std_ulogic;
use ieee.std_logic_1164.std_ulogic_vector;
use ieee.numeric_std.all;

entity instruction_memory is
	generic(
		size : integer := 32
	);
	port(
		address     : in  std_ulogic_vector(size - 1 downto 0);
		instruction : out std_ulogic_vector(size - 1 downto 0)
	);
end entity instruction_memory;

architecture RTL of instruction_memory is
	signal inst01 : std_ulogic_vector(31 downto 0);
	signal inst02 : std_ulogic_vector(31 downto 0);
	signal inst03 : std_ulogic_vector(31 downto 0);
begin
	inst01(31 downto 26) <= "100011";   -- load word
	inst01(25 downto 21) <= "00000";    -- rs=0
	inst01(20 downto 16) <= "00000";    -- rt=0
	inst01(15 downto 0)  <= "0000000000000000"; --imme16=0

	inst02(31 downto 26) <= "000000";   -- R-type
	inst02(25 downto 21) <= "00000";    -- rs=0
	inst02(20 downto 16) <= "00000";    -- rt=0
	inst02(15 downto 11) <= "00001";    -- rd=0
	inst02(10 downto 6)  <= "00000";    -- shamt=0
	inst02(5 downto 0)   <= "100000";   --funct=add

	inst03(31 downto 26) <= "101011";   -- store word
	inst03(25 downto 21) <= "00001";    -- rs=0
	inst03(20 downto 16) <= "00010";    -- rt=0
	inst03(15 downto 0)  <= "0000000000000100"; --imme16=0

	with to_integer(unsigned(address)) select instruction <=
		inst01(size - 1 downto 0) when 0,
		inst02(size - 1 downto 0) when 4,
		inst03(size - 1 downto 0) when 8,(others => '0') when others;

end architecture RTL;
