library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity FSM_FEAL is
	port(   CLK,RST,N_KEY,N_DATA: in std_logic ;
	        COUNTER,N :in integer range 0 to 255;
	  	W_EN,R_EN,CIPHER_READY,BUSY,EN_INPUT,COUNTER_EN,MOD_EN,MUX6432_SELECT,EN_2,EN_3,EN_OUT,SEL_LOOP,CLEAR_COUNTER,KEY_RD: out  std_logic);
	
end FSM_FEAL;

architecture my_arch of FSM_FEAL is

TYPE state is (INIT,IDLE,K_INIT,KEY_GEN,C1,C2,C3,CI1,CI2,COUT);
SIGNAL pr_state,nx_state: state;

SIGNAL key_ready,new_data,new_key,busy_inner:std_logic;
SIGNAL cntr:integer range 0 to 255;
begin 

new_data<=N_DATA;
new_key<=N_KEY;
process(CLK,RST)
	begin
	if(rst='1') then 
	   pr_state <= INIT;
	elsif (clk'event AND clk='1') then
	   pr_state <= nx_state;
	end if;
	end process;

process(pr_state,new_data,new_key,COUNTER)
begin
case pr_state is
	when INIT => 
	key_ready<='0';
	nx_state<=IDLE;
        ----IDLE---
	when IDLE =>
	R_EN<='0';
	W_EN<='0';
	EN_INPUT<='1';
	COUNTER_EN<='0';
	MOD_EN<='0';
	MUX6432_SELECT<='0';
	EN_2<='0';
	EN_3<='0';
	EN_OUT<='0';
	SEL_LOOP<='0';
	BUSY<='0';
	CIPHER_READY<='0';
	CLEAR_COUNTER<='1';
	IF(new_key='1') THEN
	 nx_state<=K_INIT;
	ELSIF (new_data='1' AND key_ready='1') THEN
	 nx_state<=C1;
	ELSE 
	 nx_state<=IDLE;
	END IF;
	
    ---- K_INIT----- 
	when K_INIT =>
	W_EN<='1';
	EN_INPUT<='0';
	COUNTER_EN<='1';
	MOD_EN<='1';
	MUX6432_SELECT<='0';
	key_ready<='0';	
	CLEAR_COUNTER<='0';
	nx_state<=KEY_GEN;
    ----KEY_GEN---- 
	when KEY_GEN =>
	MUX6432_SELECT<='1';
	IF(COUNTER=N/2 +4) THEN 
	  key_ready<='1';
	  MOD_EN<='0';
	  W_EN<='0';
	  IF(new_data='1') THEN
	  CLEAR_COUNTER<='1';
	  nx_state<=C1;
 	  ELSE 
	  nx_state<= IDLE;
	  END IF;	
	END IF;
     ---- CIPHER 1---
	when C1 =>
	 R_EN<='1';
	 EN_INPUT<='0';
	 CLEAR_COUNTER<='0';
	 EN_2<='1';
	 EN_3<='1';
	 BUSY<='1';
	 nx_state<=CI1;
-------CIPHER INTERMEDIATE-----
	when CI1=>
	
	 --EN_3<='1';
	COUNTER_EN<='1';
	nx_state<=CI2; 
       ----CIPHER 2-----
	when CI2 =>
	 
	 nx_state<=C2;
	 
	when C2 =>
	 SEL_LOOP<='1';
	 --EN_2<='0';
	 --COUNTER_EN<='1';
	 
	 IF(COUNTER= N) THEN
	  
	  nx_state<=C3;		
	  ELSE nx_state<=C2;
	  END IF;
   ----CIPHER 3-----	
        when C3 =>
	EN_OUT<='1';	 
	
	 nx_state<=COUT;
	when COUT =>
	 CIPHER_READY<='1';
	 nx_state<=IDLE; 
	

	end case;
	
	end process;
KEY_RD <= key_ready;
end my_arch;