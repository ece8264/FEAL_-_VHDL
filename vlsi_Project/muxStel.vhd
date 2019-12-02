library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity muxStel is
port (A,B:in std_logic_vector(31 downto 0);
      S:in std_logic;
      O:out std_logic_vector(31 downto 0));
         
end muxStel;


architecture behavioral of muxStel is


begin
with S select O<=
A when '0',
B when others;


end behavioral; 
