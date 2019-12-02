library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX64_32 is
	port(   X0 : in std_logic_vector(31 downto 0);
	  	X1 : in std_logic_vector(31 downto 0);
		MUX64_32_OUT : out std_logic_vector(31 downto 0);
		SEL: in std_logic);
end MUX64_32;


architecture myarch of MUX64_32 is
begin 
with SEL select MUX64_32_OUT <= 
	X0 when '0',
	X1 when others;
	   
end myarch;
	