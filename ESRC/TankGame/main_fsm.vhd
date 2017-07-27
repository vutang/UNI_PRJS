LIBRARY IEEE;
USE 	IEEE.STD_LOGIC_1164.ALL;
USE 	IEEE.STD_LOGIC_ARITH.ALL;
USE 	IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Main_FSM IS
	PORT( 
		clk25, reset, vic, game_over, enter	: IN STD_LOGIC;	
		gameover_rgb, maps_rgb, victory_rgb, intro_rgb	: IN std_logic_vector(11 downto 0);
		rgb			    							: OUT STD_LOGIC_VECTOR( 11 DOWNTO 0 )
		);
END Main_FSM;

architecture b of Main_FSM is
	Type state is (maps, victory, intro, gameover, ready);
--current and next state
	signal cst, nst: state;
	signal cnt: std_logic_vector(2 downto 0);
begin

	process(clk25, reset)
	begin
		if rising_edge(clk25) then
			if  reset = '1' then 
				cst <= intro;
			else 			
				cst <= nst;
			end if;
		end if;
	end process;
		
	process(cst, vic ,enter, game_over, maps_rgb, victory_rgb, intro_rgb, gameover_rgb)
	variable cnt: integer:=0;
	begin
	nst <= cst;
		case cst is
			when intro =>
							cnt:=0;
							rgb <= intro_rgb;
							if(enter='1') then
								nst <= ready;
							else
								nst <= intro;
							end if;
			when ready =>
							rgb <= "000000000000";
							if(clk25'event and clk25='1') then
								cnt:=cnt+1;
							end if;
							if cnt = 25000000 then
								nst <= maps;
							else 
								nst <= ready;
							end if;							
			when maps =>
						cnt := 0;
						rgb <= maps_rgb;
						if(game_over = '1' and vic='0') then 
							nst <= gameover;
						elsif(game_over='0' and vic='1') then 
							nst <= victory;
						else
							nst <= maps;
						end if;	 
		   when gameover =>
						cnt := 0;
						rgb <= gameover_rgb;
		   when victory =>
						cnt := 0;
						rgb <= victory_rgb;	
		end case;	
	end process;
--	count <= cnt;
end b;