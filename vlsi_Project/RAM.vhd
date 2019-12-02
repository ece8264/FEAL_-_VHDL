library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
	port(  
	    	N: in integer range 0 to 511;
	    	CLK : in std_logic;
		RST: in std_logic;
	  	W_EN : in std_logic;
		R_EN : in std_logic;
		KEY_INPUT32: in std_logic_vector(31 downto 0);
		ADDRESS: in integer range 0 to 255;
		KEYS_EXT1: out std_logic_vector(63 downto 0);
		KEYS_EXT2: out std_logic_vector(63 downto 0);
		KEY: out std_logic_vector(15 downto 0));
		
end RAM;


architecture myarch of RAM is
type RAM16X511 is array (0 to 255) of std_logic_vector(15 downto 0);

signal memory: RAM16X511;

begin

process(CLK,RST)


	begin
	if(RST='1') then 
	memory <= (others => (others => '0'));

	elsif (CLK'EVENT AND CLK = '1') then
		if(R_EN = '1') then 
		KEY <= memory(ADDRESS);
		KEYS_EXT1 <= memory(N)&memory(N+1)&memory(N+2)&memory(N+3);
		KEYS_EXT2 <= memory(N+4)&memory(N+5)&memory(N+6)&memory(N+7);
		end if;
		if(W_EN = '1') then

		memory(2*ADDRESS) <= KEY_INPUT32(31 downto 16);
		memory(2*ADDRESS + 1) <= KEY_INPUT32(15 downto 0);
		end if;
	end if;
end process;

end myarch;
		
	

 