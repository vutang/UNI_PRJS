LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.data_maps.all;
entity item_fsm is
	port(	clk			: 			   	in 	std_logic;
			reset		: 				in 	std_logic;
			maps		: 				in 	maps_type;
			eat_item	:				in 	std_logic;
			row			: 			  	out integer range 0 to 23;
			col			: 			   	out integer range 0 to 31;
			item_ena	: 				out std_logic;
			item_type	:				out std_logic_vector(1 downto 0)
		);
end item_fsm;

architecture behavior of item_fsm is
	signal x					: integer range 23 to 1;
	signal y					: integer range 22 to 1;
	signal clk_1s, clk_x, clk_y	: std_logic := '1';
	signal s_item_count 		: integer range 0 to 5 := 0;
	signal item_on_wall			: std_logic := '0';
	signal s_item_type			: std_logic_vector(1 downto 0) := "00";
	signal number				: integer;
	type state is (ready, item_on, item_wait, item_off);
	signal	nst,cst	: state;		
	
	component random
		generic(
				max: integer:=23;
				min: integer:=1
				);
		port(
			clk: in std_logic;
			random_num: out integer range min to max
			);
	end component;
	
begin
	randomx: random
	generic map(23,1)
	port map	(clk=>clk_x,random_num=>x);
	
	randomy: random
	generic map(22,1)
	port map(clk=>clk_y,random_num=>y);
	
	random_item: random
	generic map(22,1)
	port map(clk => clk_1s,random_num => number);
	
	process(clk, reset)
	variable count1 : integer range 0 to 25000000 := 0;
	variable count2 : integer range 0 to 20		 := 0;
	variable count3 : integer range 0 to 20       := 0;
	begin
		if (clk'event and clk='1')then
			if reset = '1' then 	cst <= ready;
			else cst <= nst;
			end if;			
			count1 := count1 + 1;
			count2 := count2 + 1;
			count3 := count3 + 1;
			
			 if(count1 = 2500) then
				 clk_1s <= not clk_1s;
				 count1 := 0;				
			 end if;	
			if (count2 = 8) then 
				clk_x <= not clk_x; count2 := 0;
			end if;
			if (count3 = 7) then 
				clk_y <= not clk_y; count3 := 0;
			end if;
			if(number>=1 and number <4 ) 		then s_item_type <= "00";
			elsif(number>=4 and number <12 ) 	then s_item_type <= "01";
			elsif(number>=12 and number <16 ) 	then s_item_type <= "10";
			else s_item_type <= "11";
			end if;
		end if;
	end process;
	
	process(x, y)
	begin
		if(maps(y,x) >0 ) then item_on_wall <= '1';
		else item_on_wall <= '0';
		end if;
	end process;
	
	process(cst,clk)
	variable c1, c2, c3 : integer := 0;
	begin
		if rising_edge(clk) then 
			case cst is
				when ready 	=> 
								c1 := c1 +1;
								if(c1 = 100) then nst <= item_on; c1 :=0;
								else nst <= ready;
								end if;
								row  <= y; col <= x;
								item_type <= s_item_type;
				when item_wait =>
								if(item_on_wall = '1') then nst <= ready;
								elsif(item_on_wall = '0') then nst <= item_on;
								else nst <= item_wait;
								end if;
				when item_on =>
								item_ena <= '1';
								c2 := c2 + 1;
								if(c2 =500000000 and eat_item = '0') then 
										c2 := 0; nst<= item_off;								
								elsif(eat_item = '1') then 
										s_item_count <= s_item_count +1;
										nst <= item_off;
								else nst <= item_on;
								end if;									
				when item_off =>	
								item_ena <= '0';
								c3 := c3 + 1;
								if c3 = 200000000	then
									nst <= ready; c3 := 0;			
								else	
									nst <= item_off;
								end if;								
				end case;
		end if;
	end process;

end behavior;