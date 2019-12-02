library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fk_block is
	port(   A : in std_logic_vector(31 downto 0);
	  	B : in std_logic_vector(31 downto 0);
		FK : out std_logic_vector(31 downto 0));
end Fk_block;

architecture myarch of Fk_block is

signal a0,a1,a2,a3,a4,b0,b1,b2,b3,fk0,fk1,fk2,fk3,a1Xa0,a2Xa3,fk2Xb0,fk1Xb1,fk1Xb2,fk2Xb3 : std_logic_vector(7 downto 0);

component S1_block is

port(   	X1 : in std_logic_vector(7 downto 0);
	  	X2 : in std_logic_vector(7 downto 0);
		S1 : out std_logic_vector(7 downto 0));
end component;

component S0_block is

port(   	X1 : in std_logic_vector(7 downto 0);
	  	X2 : in std_logic_vector(7 downto 0);
		S0 : out std_logic_vector(7 downto 0));
end component;

	BEGIN

a0 <= A(31 downto 24);
a1 <= A(23 downto 16);
a2 <= A(15 downto 8);
a3 <= A(7 downto 0);

b0 <= B(31 downto 24);
b1 <= B(23 downto 16);
b2 <= B(15 downto 8);
b3 <= B(7 downto 0);

a1Xa0 <= a1 XOR a0;
a2Xa3 <= a2 XOR a3;
fk2Xb0 <= a2Xa3  XOR b0;
fk1out	:  S1_block PORT MAP(a1Xa0,fk2Xb0,fk1);
fk1Xb1 <= fk1 XOR b1;
fk2out	: S0_block PORT MAP(a2Xa3,fk1Xb1,fk2);
fk1Xb2 <= fk1 XOR b2;
fk0out	: S0_block PORT MAP(a0,fk1Xb2,fk0);
fk2Xb3 <= fk2 XOR b3;
fk3out	: S1_block PORT MAP(a3,fk2Xb3,fk3);

FK <= fk0&fk1&fk2&fk3;
end myarch;