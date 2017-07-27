library  ieee; 
use ieee.std_logic_1164. all ; 
use ieee.std_logic_unsigned. all ; 
use ieee.std_logic_arith.all;

entity clk5hz is 
		port( 	clock_50				: in  std_logic; 
				clk5hz				: out std_logic); 
end clk5hz ; 

architecture b of clk5hz is
signal	clk_5hz: std_logic;
begin

process(clock_50)
variable		cnt:integer:=0;
	begin
		if rising_edge(clock_50) then 	cnt := cnt + 1;
			if cnt = 20000333 then 	cnt:=0;
									clk_5HZ <=not clk_5HZ;
			end if;
		end if;
		clk5hz <= clk_5HZ;
end process;
end b;	