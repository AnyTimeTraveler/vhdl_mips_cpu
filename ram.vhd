library ieee;
use ieee.std_logic_1164.std_ulogic;
use ieee.std_logic_1164.std_ulogic_vector;
use ieee.numeric_std.all;

entity ram is
	generic(
		data_width : integer := 32;     --width of each data word
		size       : integer := 5
	);                                  --2**number of data words the memory can store
	port(
		clk                  : in  std_ulogic;
		data_in_write_enable : in  std_ulogic;
		address              : in  std_ulogic_vector(size - 1 downto 0);
		data_in              : in  std_ulogic_vector(data_width - 1 downto 0);
		data_out             : out std_ulogic_vector(data_width - 1 downto 0)
	);
end entity ram;

architecture RTL of ram is
	type memory is array (2**size - 1 downto 0) of std_ulogic_vector(data_width - 1 downto 0); --data type for memory
	signal ram              : memory := (
		0      => std_ulogic_vector(to_unsigned(4, data_width)),
		1      => std_ulogic_vector(to_unsigned(4, data_width)),
		others => (others => '0')
	);                                  --memory array
	signal internal_address : integer range 0 to 2**size - 1; --internal address register
begin
	process(clk)
	begin
		if (clk'EVENT and clk = '1') then
			if (data_in_write_enable = '1') then --write enable is asserted
				ram(to_integer(unsigned(address))) <= data_in; --write input data into memory
			end if;
			internal_address <= to_integer(unsigned(address));
		end if;
	end process;

	data_out <= ram(internal_address);  --output data at the stored address
end architecture RTL;
