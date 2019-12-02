library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBOX is
	port(   Qr : in std_logic_vector(31 downto 0);
	  	B : in std_logic_vector(31 downto 0);
		D : in std_logic_vector(31 downto 0);
		XOR_OUT : out std_logic_vector(31 downto 0);
		XOR_OUT2: out std_logic_vector(31 downto 0));
end XBOX;


architecture myarch of XBOX is
signal xbox1: std_logic_vector(31 downto 0);

begin 

xbox1 <= B XOR Qr;
XOR_OUT <= xbox1 XOR D;
XOR_OUT2 <= B;

end myarch ;
