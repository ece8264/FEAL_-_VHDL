library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity FEAL_NX is 
port(
         N: in integer range 0 to 255 ;  --decimal 32;
     PLAINTEXT:in std_logic_vector(63 downto 0);
     RESET,CLK,N_KEY,N_DATA:in std_logic;
     KEY:in std_logic_vector(127 downto 0);
     CIPHERTEXT:out std_logic_vector(63 downto 0); 
     CIPHER_READY,KEY_READY:out std_logic);
end FEAL_NX;


architecture behavioral of FEAL_NX is

component S0_block is
	port(   X1 : in std_logic_vector(7 downto 0);
	  	X2 : in std_logic_vector(7 downto 0);
		S0 : out std_logic_vector(7 downto 0));
end component;

component S1_block is
	port(   X1 : in std_logic_vector(7 downto 0);
	  	X2 : in std_logic_vector(7 downto 0);
		S1 : out std_logic_vector(7 downto 0));
end component;

component f_function is
port(R:in std_logic_vector(31 downto 0);
    KEY:in std_logic_vector(15 downto 0);
    F:out std_logic_vector(31 downto 0));
end component;

component  first_round is
   port(
        PLAIN:in std_logic_vector(63 downto 0);
        KEYS:in std_logic_vector(63 downto 0);
         L0,R0:out std_logic_vector(31 downto 0));
 end component;


component m_round is
port(
    Rpre,Lpre:in std_logic_vector(31 downto 0);
    KEYS:in std_logic_vector(15 downto 0);
    R,L:out std_logic_vector(31 downto 0));
end  component;

component last_round is
port(Lpre,Rpre : in std_logic_vector(31 downto 0);
     KEYS:in std_logic_vector(63 downto 0);
     CIPHER:out std_logic_vector(63 downto 0));
end component;


component muxStel is
port (A,B:in std_logic_vector(31 downto 0);
      S:in std_logic;
      O:out std_logic_vector(31 downto 0));
         
end component;

component  reg32Stel is
port(data_in :in std_logic_vector(31 downto 0);
     clk,reset,w_en:in std_logic;
     data_out:out std_logic_vector(31 downto 0));
end  component;

component CIPHER IS
	port(clk,reset,EN_INPUT,EN_2,EN_3,EN_OUT,SEL_LOOP:in std_logic;
      PLAINTEXT: in std_logic_vector(63 downto 0);
      KEYSpre:in std_logic_vector(63 downto 0);
      KEYSm:in std_logic_vector(15 downto 0);
      KEYSpost:in std_logic_vector(63 downto 0);
      CIPHERTEXT:out std_logic_vector(63 downto 0));

end component;

component  regStel is 
  port(clk,reset,w_en:in std_logic;
  data_in:in std_logic_vector( 63 downto 0);
  data_out:out std_logic_vector(63 downto 0));
end component;

---FK
component Fk_block is

port(   	A : in std_logic_vector(31 downto 0);
	  	B : in std_logic_vector(31 downto 0);
		FK : out std_logic_vector(31 downto 0));
end component;

---REG32
component reg32 is
	port(   CLK,RST,EN: in std_logic;
		DATA_IN: in std_logic_vector(31 downto 0);
		DATA_OUT: out std_logic_vector(31 downto 0));
	
end component;
---REG128
component reg128 is
	port(   CLK,RST,EN: in std_logic;
		DATA_IN: in std_logic_vector(127 downto 0);
		DATA_OUT: out std_logic_vector(127 downto 0));
	
end component;
---MUX96
component MUX96_32 is
	port(   X0 : in std_logic_vector(31 downto 0);
	  	X1 : in std_logic_vector(31 downto 0);
		X2 : in std_logic_vector(31 downto 0);
		MUX96_32_OUT : out std_logic_vector(31 downto 0);
		SEL: in std_logic_vector(1 downto 0));
end component;
---MUX64
component MUX64_32 is
	port(   X0 : in std_logic_vector(31 downto 0);
	  	X1 : in std_logic_vector(31 downto 0);
		MUX64_32_OUT : out std_logic_vector(31 downto 0);
		SEL: in std_logic);
end component;
--XBOX
component XBOX is
	port(   Qr : in std_logic_vector(31 downto 0);
	  	B : in std_logic_vector(31 downto 0);
		D : in std_logic_vector(31 downto 0);
		XOR_OUT : out std_logic_vector(31 downto 0);
		XOR_OUT2: out std_logic_vector(31 downto 0));
end component;
---RAM
 component RAM is
	port(
	    N: in integer range 0 to 511;   
	    CLK : in std_logic;
		RST: in std_logic;
	  	W_EN : in std_logic;
		R_EN : in std_logic;
		KEY_INPUT32: in std_logic_vector(31 downto 0);
		COUNTER: in integer range 0 to 255;
		KEYS_EXT1: out std_logic_vector(63 downto 0);
		KEYS_EXT2: out std_logic_vector(63 downto 0);
		KEY: out std_logic_vector(15 downto 0));
		
end component;

component Key_Schedule is
	port(  
	    	N: in integer range 0 to 255; 
	    	CLK,RST,MUX6432_SELECT,EN_INPUT,W_EN,R_EN: in std_logic ;
		KEY_IN: in std_logic_vector(127 downto 0);
	  	COUNTER: in integer range 0 to 255;
		COUNTER012: in integer range 0 to 2;
        	KEY_OUT0: out std_logic_vector(15 downto 0);
		KEY_OUT64_1: out std_logic_vector(63 downto 0);
		KEY_OUT64_2: out std_logic_vector(63 downto 0));
	
end component;


component FSM_FEAL is
	port(   CLK,RST,N_KEY,N_DATA: in std_logic ;
	        COUNTER,N :in integer range 0 to 255;
	  	W_EN,R_EN,CIPHER_READY,BUSY,EN_INPUT,COUNTER_EN,MOD_EN,MUX6432_SELECT,EN_2,EN_3,EN_OUT,SEL_LOOP,CLEAR_COUNTER,KEY_RD: out  std_logic);
	
end component;
---COUNTERS SIGNALS---
signal COUNTER: integer range 0 to 255;
signal COUNTER012: integer range 0 to 2;
signal CLEAR_COUNTER,COUNTER_EN: std_logic;
---FSM SIGNALS---
signal W_EN,R_EN,BUSY,EN_INPUT,MOD_EN,MUX6432_SELECT,EN_2,EN_3,EN_OUT,SEL_LOOP,KEY_RD: std_logic;
---ADDRESSES---
signal r_address:integer range 0 to 255;
signal w_address:integer range 0 to 255;

---shmata key_schedule ---
signal key_out_0_aux:  std_logic_vector(15 downto 0);
signal key_out64_1_aux,key_out64_2_aux,ciphertext_aux:  std_logic_vector(63 downto 0);



begin 

------COUNTER012-----
counter012process :process(clk,reset)
variable c:integer range 0 to 2 ;

   begin
   if(reset='1') then
   	c := 0;
   elsif(clk'event and clk='1') then
      	if(CLEAR_COUNTER='1')then
		c := 0;
	elsif(COUNTER_EN='1') then
		if(c=2) then
		c:=0;
		else 
		c := c+1;
		end if;
        end if;
   end if;
COUNTER012 <= c;
      
end process;
-----counter----N/2+3 , N-1
counterprocess:process(clk,reset)
variable c:integer range 0 to 255 ;

   begin
   if(reset='1') then
   	c := 0;
   elsif(clk'event and clk='1') then
      	if(CLEAR_COUNTER='1')then
		c := 0;
	elsif(COUNTER_EN='1') then
		c := c+1;
        end if;
   end if;
COUNTER <= c;
      
end process;


keys_feal: Key_Schedule port map(N,CLK,RESET,MUX6432_SELECT,EN_INPUT,W_EN,R_EN,KEY,COUNTER,COUNTER012,key_out_0_aux,key_out64_1_aux,key_out64_2_aux);

cipher_feal: cipher port map(clk,reset,EN_INPUT,EN_2,EN_3,EN_OUT,SEL_LOOP,PLAINTEXT,key_out64_1_aux,key_out_0_aux,key_out64_2_aux,ciphertext_aux);

fsm_1: FSM_FEAL port map(CLK,RESET,N_KEY,N_DATA,COUNTER,N,W_EN,R_EN,CIPHER_READY,BUSY,EN_INPUT,COUNTER_EN,MOD_EN,MUX6432_SELECT,EN_2,EN_3,EN_OUT,SEL_LOOP,CLEAR_COUNTER,KEY_RD);

 CIPHERTEXT <= ciphertext_aux;
 KEY_READY <= KEY_RD;
 
end behavioral;
    
