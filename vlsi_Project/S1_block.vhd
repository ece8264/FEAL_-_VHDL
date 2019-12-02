library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity S1_block is
	port(   X1 : in std_logic_vector(7 downto 0);
	  	X2 : in std_logic_vector(7 downto 0);
		S1 : out std_logic_vector(7 downto 0));
end S1_block;

architecture myarch of S1_block is

signal sum : std_logic_vector(7 downto 0);
signal md : std_logic_vector(7 downto 0);

	BEGIN
 
sum <= std_logic_vector(unsigned(X1) + unsigned(X2) + 1);---athroisma 
md <= std_logic_vector(unsigned(sum) mod 256);--module
S1 <= md(5 downto 0)&md(7 downto 6);--rot2 

end myarch;