library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity first_round is
   port(
        PLAIN:in std_logic_vector(63 downto 0);
        KEYS:in std_logic_vector(63 downto 0);
         L0,R0:out std_logic_vector(31 downto 0));
 end first_round;


architecture behavioral of first_round is
signal lv,rv,lpre,rpre,r : std_logic_vector(31 downto 0);
signal k,p,pxk:std_logic_vector(63 downto 0);

begin




k<=KEYS;
p<=PLAIN;
pxk<=k(63 downto 0) xor p(63 downto 0);
lpre(31 downto 0)<=pxk(63 downto 32);
rpre(31 downto 0)<=pxk(31 downto 0);

r<=rpre xor lpre;


 
     lv<=(others=>'0');
     rv<=(others=>'0');
  
     L0<=lpre;
     R0<=r;	

end behavioral;

