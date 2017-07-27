library  ieee; 
use ieee.std_logic_1164. all ; 
use ieee.std_logic_unsigned. all ; 
use ieee.std_logic_arith.all;

entity clk_ena is 
		port( 	
				clock_50				: in  std_logic; 
				ena				: out std_logic); 
end clk_ena ; 

architecture b of clk_ena is
signal	en: std_logic;
begin

process(clock_50)
variable		cnt:integer:=0;
	begin
		if rising_edge(clock_50) then 	cnt := cnt + 1;
			if cnt = 19 then 	cnt:=0;
									en <= '1';
			else en <= '0';
			end if;
		end if;
		ena <= en;
end process;
end b;	