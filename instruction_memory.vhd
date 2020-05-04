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
	signal lw_ram0_into_reg0          : std_ulogic_vector(31 downto 0);
	signal add_reg0_to_reg0_into_reg1 : std_ulogic_vector(31 downto 0);
	signal sw_reg0_into_ram0          : std_ulogic_vector(31 downto 0);
	signal noop                       : std_ulogic_vector(31 downto 0);
begin

	-- load ram(0) into reg(0)
	lw_ram0_into_reg0(31 downto 26) <= "100011"; -- load word
	lw_ram0_into_reg0(25 downto 21) <= "00000"; -- rs=0
	lw_ram0_into_reg0(20 downto 16) <= "00000"; -- rt=0
	lw_ram0_into_reg0(15 downto 0)  <= "0000000000000000"; --imme16=0

	-- load add reg(0) to reg(0) and store in reg(1)
	add_reg0_to_reg0_into_reg1(31 downto 26) <= "000000"; -- R-type
	add_reg0_to_reg0_into_reg1(25 downto 21) <= "00000"; -- rs=0
	add_reg0_to_reg0_into_reg1(20 downto 16) <= "00000"; -- rt=0
	add_reg0_to_reg0_into_reg1(15 downto 11) <= "00001"; -- rd=0
	add_reg0_to_reg0_into_reg1(10 downto 6)  <= "00000"; -- shamt=0
	add_reg0_to_reg0_into_reg1(5 downto 0)   <= "100000"; --funct=add

	-- load ram(0) into reg(0)
	sw_reg0_into_ram0(31 downto 26) <= "101011"; -- store word
	sw_reg0_into_ram0(25 downto 21) <= "00000"; -- rs=0
	sw_reg0_into_ram0(20 downto 16) <= "00000"; -- rt=0
	sw_reg0_into_ram0(15 downto 0)  <= "0000000000000100"; --imme16=0

	-- r(0) and r(0) -> r(0)
	noop(31 downto 26) <= "000000";     -- R-type
	noop(25 downto 21) <= "00000";      -- rs=0
	noop(20 downto 16) <= "00000";      -- rt=0
	noop(15 downto 11) <= "00000";      -- rd=0
	noop(10 downto 6)  <= "00000";      -- shamt=0
	noop(5 downto 0)   <= "100100";     --funct=and

	with to_integer(unsigned(address)) select instruction <=
		--		lw_ram0_into_reg0(size - 1 downto 0) when 0,
		--		add_reg0_to_reg0_into_reg1(size - 1 downto 0) when 1,
		--		sw_reg0_into_ram0(size - 1 downto 0) when 2,
		noop(size - 1 downto 0) when others;

end architecture RTL;
