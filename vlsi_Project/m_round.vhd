library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity m_round is
port(
    Rpre,Lpre:in std_logic_vector(31 downto 0);
    KEYS:in std_logic_vector(15 downto 0);
    R,L:out std_logic_vector(31 downto 0));
end m_round;	 

   
architecture behavioral of m_round is


component f_function is
port(R:in std_logic_vector(31 downto 0);
    KEY:in std_logic_vector(15 downto 0);
    F:out std_logic_vector(31 downto 0));
end component; 


signal rght, fout,r1,l1:std_logic_vector(31 downto 0);
signal k:std_logic_vector(15 downto 0);

begin
rght<=Rpre; 
k<=KEYS;
l1<=Lpre;
f: f_function port map(rght,k,fout);
r1<=fout xor l1;
L<=rght;
R<= r1;

end behavioral;