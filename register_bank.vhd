library ieee;
use ieee.std_logic_1164.std_ulogic;
use ieee.std_logic_1164.std_ulogic_vector;
use ieee.numeric_std.all;

entity register_bank is
	generic(
		data_width : integer := 32;     --width of each data word
		size       : integer := 5);     --2**number of data words the memory can store
	port(
		clk                  : in  std_ulogic;
		data_in_write_enable : in  std_ulogic;
		data_in_address      : in  std_ulogic_vector(size - 1 downto 0);
		data_in              : in  std_ulogic_vector(data_width - 1 downto 0);
		data_a_address       : in  std_ulogic_vector(size - 1 downto 0);
		data_a_out           : out std_ulogic_vector(data_width - 1 downto 0);
		data_b_address       : in  std_ulogic_vector(size - 1 downto 0);
		data_b_out           : out std_ulogic_vector(data_width - 1 downto 0)
	);
end entity register_bank;

architecture RTL of register_bank is
	type memory is array (2**size - 1 downto 0) of std_ulogic_vector(data_width - 1 downto 0); --data type for memory
	signal ram                : memory; --memory array
	signal internal_address_a : integer range 0 to 2**size - 1; --internal address register
	signal internal_address_b : integer range 0 to 2**size - 1; --internal address register
begin
	process(clk)
	begin
		if (clk'EVENT and clk = '1') then
			if (data_in_write_enable = '1') then --write enable is asserted
				ram(to_integer(unsigned(data_in_address))) <= data_in; --write input data into memory
			end if;
			internal_address_a <= to_integer(unsigned(data_a_address));
			internal_address_b <= to_integer(unsigned(data_b_address));
		end if;
	end process;

	data_a_out <= ram(internal_address_a); --output data at the stored address
	data_b_out <= ram(internal_address_b); --output data at the stored address
end architecture RTL;
