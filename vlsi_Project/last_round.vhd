library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity last_round is
port(Lpre,Rpre : in std_logic_vector(31 downto 0);
     KEYS:in std_logic_vector(63 downto 0);
     CIPHER:out std_logic_vector(63 downto 0));
end last_round;


architecture behavioral of last_round is

signal r,l,zero :std_logic_vector(31 downto 0);
signal precipher,conc,help,key:std_logic_vector(63 downto 0);


begin
zero<= (others=> '0');
r<=Rpre;
l<=Lpre;
key<=KEYS;
conc<=r&l;
help<= zero & r;
precipher<=conc xor help;

CIPHER<= precipher xor key;
end behavioral;