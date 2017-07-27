library  ieee; 
use ieee.std_logic_1164. all ; 
use ieee.std_logic_unsigned. all ; 
use ieee.std_logic_arith.all;

entity clk1s_gen is 
		port( 	clk25				: in  std_logic; 
				clk1s				: out std_logic); 
end clk1s_gen ; 

architecture b of clk1s_gen is
signal	clk1HZ: std_logic;
begin

process(clk25)
variable		cnt:integer:=0;
	begin
		if rising_edge(clk25) then 	cnt := cnt +1;
			if cnt = 25000000 then 	cnt:=0;
									clk1HZ<=not clk1HZ;
			end if;
		end if;
		clk1s <= clk1HZ;
end process;
end b;	