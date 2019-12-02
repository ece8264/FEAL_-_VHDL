library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity regStel is 
  port(clk,reset,w_en:in std_logic;
  data_in:in std_logic_vector( 63 downto 0);
  data_out:out std_logic_vector(63 downto 0));
end regStel;


architecture behavioral of regStel is 
begin

------PROCESS------
reg: process(reset,clk)
 variable data:std_logic_vector(63 downto 0);
   begin
data:=data_in;
  if(reset='1') then
     data:=(others=>'0');
  elsif (clk'event and clk='1') then
     if(w_en='1')then
        data_out<=data;
     else 
         null;   
  end if;  
   end if;
end process reg;

end behavioral; 		    	