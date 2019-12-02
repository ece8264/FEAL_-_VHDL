library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity f_function is
port(R:in std_logic_vector(31 downto 0);
    KEY:in std_logic_vector(15 downto 0);
    F:out std_logic_vector(31 downto 0));
end f_function;	


architecture behavioral of f_function is

signal  a0,a1,a2,a3,x0,x1,x2,x3,o0,o1,o2,o3: std_logic_vector(7 downto 0);---internal signals for xor outputs and S blocks outputs--
signal  b0,b1 :std_logic_vector(7 downto 0);

component S0_block
    port(   X1 : in std_logic_vector(7 downto 0);
	  	X2 : in std_logic_vector(7 downto 0);
		S0 : out std_logic_vector(7 downto 0));
   end component;

component S1_block
    port(   X1 : in std_logic_vector(7 downto 0);
	  	X2 : in std_logic_vector(7 downto 0);
		S1 : out std_logic_vector(7 downto 0));
   end component;

begin

a0(7 downto 0)<=R(31 downto 24);
a1(7 downto 0)<=R(23 downto 16);
a2(7 downto 0)<=R(15 downto 8);
a3(7 downto 0)<=R(7 downto 0);
b0(7 downto 0)<=KEY(15 downto 8);
b1(7 downto 0)<=KEY(7 downto 0);

x0<=a1 xor b0;--F1
x1<=x0 xor a0;--F1'
x2<=a2 xor b1;--F2
x3<=x2 xor a3;--F2'

out1: S1_block port map (x1,x3,o1);
out0: S0_block port map(a0,o1,o0);
out2: S0_block port map(x3,o1,o2);
out3: S1_block port map(a3,o2,o3);
 F<=o0 &o1 &o2 &o3;


end behavioral;