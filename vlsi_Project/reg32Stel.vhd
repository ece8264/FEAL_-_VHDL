library ieee;
use ieee.std_logic_1164.all;



entity reg32Stel is
port(data_in :in std_logic_vector(31 downto 0);
     clk,reset,w_en:in std_logic;
     data_out:out std_logic_vector(31 downto 0));
end reg32Stel;


architecture behavioral of reg32Stel is 
begin

------PROCESS------
reg: process(reset,clk)
 variable data:std_logic_vector(31 downto 0);
   begin
data:=data_in;
  if(reset='1') then
     data:=(others=>'0');
  elsif (clk'event and clk='1') then
     if(w_en='1') then
     data_out<=data; 
  end if;  
   end if;
end process reg;

end behavioral; 		    	

