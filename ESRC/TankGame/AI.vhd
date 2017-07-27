library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.data_maps.all;

entity AI is
	port(
		fz: in std_logic;
		maps_AI: in maps_type;
		refr_tick : in std_logic;
		col: in integer range 0 to 31;
		row: in integer range 0 to 23;
		clk: in std_logic;
		clk_db: in std_logic;
		reset,ena_AI: in std_logic;
		pixel_x,pixel_y: in std_logic_vector(9 downto 0);
		dir, dir1, dir2: in std_logic_vector(1 downto 0);
		b_col_t1,b_col_t2: in integer range 0 to 31;
		b_row_t1,b_row_t2: in integer range 0 to 23;
		AI_rgb: out std_logic_vector(11 downto 0);
		row_tank,row_tank2: in integer range 0 to 23;
		col_tank,col_tank2: in integer range 0 to 31;
		AI_on,AI1_on,AI2_on: out std_logic;
		score_chuc,score_dvi : out integer range 0 to 9;
		score_chuc2,score_dvi2 : out integer range 0 to 9;
		row_AI,row_AI1,row_AI2: out integer range 0 to 23;
		col_AI,col_AI1,col_AI2: out integer range 0 to 31;
		victory: out std_logic;
		shooted_t1,shooted_t2 : out std_logic;
		freeze_rgb : out std_logic_vector (11 downto 0);
		AI_up_rgb : out std_logic_vector (11 downto 0)
		);
end AI;

architecture behavior of AI is
	signal address: std_logic_vector(8 downto 0);
	signal buzz_rgb,fz_rgb,tank_up_rgb,tank_down_rgb,tank_left_rgb,tank_right_rgb,tank_AI_rgb,tank1_AI_rgb,tank2_AI_rgb: std_logic_vector(11 downto 0);
	signal bum_col_t1,bum_col_t2,col_AI_next,col_AI_reg,col_AI_next1,col_AI_reg1,col_AI_next2,col_AI_reg2: integer range 0 to 31;
	signal bum_row_t1,bum_row_t2,row_AI_next,row_AI_reg,row_AI_next1,row_AI_reg1,row_AI_next2,row_AI_reg2: integer range 0 to 23;
	signal ena,clk1s: std_logic;
	signal score_chuc_reg,score_chuc_next,score_dvi_next,score_dvi_reg: integer range 0 to 9;
	signal score_chuc_reg2,score_chuc_next2,score_dvi_next2,score_dvi_reg2: integer range 0 to 9;
	signal counter_AI : integer  :=0;
	signal counter_AI1: integer  :=0;
	signal counter_AI2: integer  :=0;
	signal sAI_on     : std_logic:='1';
	signal sAI1_on    : std_logic:='1';
	signal sAI2_on    : std_logic:='1';
	signal fz_rgb_on: std_logic;
	signal shooted_t1_buf,shooted_t2_buf : std_logic;
	
begin
	tank_ud_rom: entity work.ai_ud_rom port map (address,"110010000" - address,clk,tank_up_rgb,tank_down_rgb);
	tank_lf_rom: entity work.ai_lf_rom port map (address,"110010000" - address,clk,tank_left_rgb,tank_right_rgb);
	freeze: entity work.fz_rom 					port map (address,clk,fz_rgb);
	clk_e: 			entity work.clk_ena 	port map (clock_50=>refr_tick,ena=>ena);
	clk1_s: 		entity work.clk1s_gen 	port map (clk25=>clk,clk1s=>clk1s);
	buzz_rom : entity work.buzz_rom port map (address,clk,buzz_rgb);
	process (clk)
	begin
		if (clk'event and clk = '1') then
			row_AI_reg <= row_AI_next;
			col_AI_reg <= col_AI_next;
			row_AI_reg1 <= row_AI_next1;
			col_AI_reg1 <= col_AI_next1;
			row_AI_reg2 <= row_AI_next2;
			col_AI_reg2 <= col_AI_next2;
			score_chuc_reg <= score_chuc_next;
			score_dvi_reg <= score_dvi_next;
			score_chuc_reg2 <= score_chuc_next2;
			score_dvi_reg2 <= score_dvi_next2;
		end if;
	end process;	
	process (clk_db,ena)
	begin
		if (clk_db'event and clk_db = '1') then
			if (reset = '1') then 
				col_AI_next <= 1;
				row_AI_next <= 1;
				col_AI_next1 <= 11;
				row_AI_next1 <= 1;
				col_AI_next2 <= 23;
				row_AI_next2 <= 1;
				score_chuc_next <= 0;
				score_dvi_next <= 0;
				score_chuc_next2 <= 0;
				score_dvi_next2 <= 0;
				counter_AI <=0;
				counter_AI1<=0;
				counter_AI2<=0;
				sAI_on     <='1';
				sAI1_on    <='1';
				sAI2_on    <='1';
			else
-- tinh diem va tro lai vi tri ban dau
				if(b_col_t1=col_AI_next and b_row_t1=row_AI_next) then
					if(counter_AI = 6) then
						sAI_on <= '0';
					else 
						counter_AI <= counter_AI + 1;
						col_AI_next <= 1;
						row_AI_next <= 1;
					end if;
					if(score_dvi_reg = 9) then
						score_dvi_next <= 0;
						score_chuc_next <= score_chuc_reg + 1;
					else
						score_dvi_next <= score_dvi_reg + 1;
					end if;
				end if;
					
				if(b_col_t2 = col_AI_next and b_row_t2 = row_AI_next) then
					if(counter_AI = 6) then
						sAI_on <= '0';
					else 
					counter_AI  <= counter_AI + 1;
					col_AI_next <= 1;
					row_AI_next <= 1;
					end if;
					if(score_dvi_reg2 = 9) then
						score_dvi_next2 <= 0;
						score_chuc_next2 <= score_chuc_reg2 + 1;
					else
						score_dvi_next2 <= score_dvi_reg2 + 1;
					end if;
				end if;
					
				if(b_col_t1 = col_AI_next1 and b_row_t1 = row_AI_next1) then
					if(counter_AI1 = 7) then
						sAI1_on <= '0';
					else
						col_AI_next1 <= 11;
						row_AI_next1 <= 1;
						counter_AI1  <= counter_AI1 + 1;
					end if;
					if(score_dvi_reg = 9) then
						score_dvi_next  <= 0;
						score_chuc_next <= score_chuc_reg + 1;
					else
						score_dvi_next <= score_dvi_reg + 1;
					end if;
				end if;
					
				if(b_col_t2 = col_AI_next1 and b_row_t2 = row_AI_next1) then
					if(counter_AI1 = 7) then
						sAI1_on <= '0';
					else
						col_AI_next1 <= 11;
						row_AI_next1 <= 1;
						counter_AI1 <= counter_AI1 + 1;
					end if;
					if(score_dvi_reg2 = 9) then
						score_dvi_next2 <= 0;
						score_chuc_next2 <= score_chuc_reg2 + 1;
					else
						score_dvi_next2 <= score_dvi_reg2 + 1;
					end if;
				end if;
					
				if(b_col_t1 = col_AI_next2 and b_row_t1 = row_AI_next2) then
					if(counter_AI2 = 7) then
						sAI2_on <= '0';
					else
						col_AI_next2 <= 23;
						row_AI_next2 <= 1;
						counter_AI2  <= counter_AI2 + 1;
					end if;
					if(score_dvi_reg = 9) then
						score_dvi_next <= 0;
						score_chuc_next <= score_chuc_reg + 1;
					else
						score_dvi_next <= score_dvi_reg + 1;
					end if;
				end if;
				
				if(b_col_t2 = col_AI_next2 and b_row_t2 = row_AI_next2) then
					if(counter_AI2 = 7) then
						sAI2_on <= '0';
					else
						col_AI_next2 <= 23;
						row_AI_next2 <= 1;
						counter_AI2  <= counter_AI2 + 1;
					end if;
					if(score_dvi_reg2 = 9) then
						score_dvi_next2 <= 0;
						score_chuc_next2 <= score_chuc_reg2 + 1;
					else
						score_dvi_next2 <= score_dvi_reg2 + 1;
					end if;
				end if;
-- Move AI 	
				
				if(ena='1' and fz = '0' and ena_AI='0') then
				if(sAI_on='0') then col_AI_next  <= 0; row_AI_next  <= 0; 
				else
					case dir is					
						when "00" => 
										if(row_AI_reg > 1 and maps_AI(row_AI_reg-1,col_AI_reg) <= 1) then
											if((row_AI_reg=row_AI_reg1+1 and col_AI_reg=col_AI_reg1) or
												(row_AI_reg=row_AI_reg2+1 and col_AI_reg=col_AI_reg2) or
												(row_AI_reg=row_tank+1 and col_AI_reg=col_tank) or
												(row_AI_reg=row_tank2+1 and col_AI_reg=col_tank2)) then
												row_AI_next <= row_AI_reg;
												col_AI_next <= col_AI_reg;
											else
												row_AI_next <= row_AI_reg - 1;
												col_AI_next <= col_AI_reg;
											end if;
										end if;																						
						when "01" =>
										if(row_AI_reg < 22 and maps_AI(row_AI_reg+1,col_AI_reg) <=1 ) then
											if((row_AI_reg=row_AI_reg1-1 and col_AI_reg=col_AI_reg1) or
												(row_AI_reg=row_AI_reg2-1 and col_AI_reg=col_AI_reg2) or
												(row_AI_reg=row_tank-1 and col_AI_reg=col_tank) or
												(row_AI_reg=row_tank2-1 and col_AI_reg=col_tank2))  then
												row_AI_next <= row_AI_reg;
												col_AI_next <= col_AI_reg;
											else
												row_AI_next <= row_AI_reg + 1;
												col_AI_next <= col_AI_reg;
											end if;
										end if;																									
						when "10" =>
										if(col_AI_reg > 1 and maps_AI(row_AI_reg,col_AI_reg-1) <= 1) then
											if((row_AI_reg=row_AI_reg1 and col_AI_reg=col_AI_reg1+1) or
												(row_AI_reg=row_AI_reg2 and col_AI_reg=col_AI_reg2+1) or
												(row_AI_reg=row_tank and col_AI_reg=col_tank+1) or
												(row_AI_reg=row_tank2 and col_AI_reg=col_tank2+1)) then
												row_AI_next <= row_AI_reg;
												col_AI_next <= col_AI_reg;
											else
												row_AI_next <= row_AI_reg;
												col_AI_next <= col_AI_reg - 1;
											end if;
										end if;																						
						when "11" =>
										if(col_AI_reg < 23 and maps_AI(row_AI_reg,col_AI_reg+1) <= 1) then
											if((row_AI_reg=row_AI_reg1 and col_AI_reg=col_AI_reg1+1) or
												(row_AI_reg=row_AI_reg2 and col_AI_reg=col_AI_reg2+1) or
												(row_AI_reg=row_tank and col_AI_reg=col_tank+1) or
												(row_AI_reg=row_tank2 and col_AI_reg=col_tank2+1)) then
												row_AI_next <= row_AI_reg;
												col_AI_next <= col_AI_reg;
											else
												row_AI_next <= row_AI_reg;
												col_AI_next <= col_AI_reg + 1;
											end if;
										end if;																																										
					end case;
					end if;
					if( sAI1_on='0') then col_AI_next1 <= 0; row_AI_next1 <= 0;
					else
					case dir1 is
						when "00" =>
										if(row_AI_reg1 > 1 and  maps_AI(row_AI_reg1-1,col_AI_reg1) <= 1 ) then
											if((row_AI_reg1=row_AI_reg+1 and col_AI_reg1=col_AI_reg) or
												(row_AI_reg1=row_AI_reg2+1 and col_AI_reg1=col_AI_reg2) or
												(row_AI_reg1=row_tank+1 and col_AI_reg1=col_tank) or
												(row_AI_reg1=row_tank2+1 and col_AI_reg1=col_tank2)) then
												row_AI_next1 <= row_AI_reg1;
												col_AI_next1 <= col_AI_reg1;
											else
												row_AI_next1 <= row_AI_reg1 - 1;
												col_AI_next1 <= col_AI_reg1;
											end if;
										end if;
						when "01" =>
										if(row_AI_reg1 < 22 and maps_AI(row_AI_reg1+1,col_AI_reg1) <= 1) then
											if((row_AI_reg1=row_AI_reg-1 and col_AI_reg1=col_AI_reg) or
												(row_AI_reg1=row_AI_reg2-1 and col_AI_reg1=col_AI_reg2) or 
												(row_AI_reg1=row_tank-1 and col_AI_reg1=col_tank) or
												(row_AI_reg1=row_tank2-1 and col_AI_reg1=col_tank2))  then
												row_AI_next1 <= row_AI_reg1;
												col_AI_next1 <= col_AI_reg1;
											else
												row_AI_next1 <= row_AI_reg1 + 1;
												col_AI_next1 <= col_AI_reg1;
											end if;
										end if;
						when "10" => 
										if(col_AI_reg1 > 1 and maps_AI(row_AI_reg1,col_AI_reg1-1) <= 1) then
											if((row_AI_reg1=row_AI_reg and col_AI_reg1=col_AI_reg+1) or
												(row_AI_reg1=row_AI_reg2 and col_AI_reg1=col_AI_reg2+1) or
												(row_AI_reg1=row_tank and col_AI_reg1=col_tank+1) or
												(row_AI_reg1=row_tank2 and col_AI_reg1=col_tank2+1)) then
												row_AI_next1 <= row_AI_reg1;
												col_AI_next1 <= col_AI_reg1;
											else
												row_AI_next1 <= row_AI_reg1;
												col_AI_next1 <= col_AI_reg1 - 1;
											end if;
										end if;
						when "11" =>
										if(col_AI_reg1 < 23 and maps_AI(row_AI_reg1,col_AI_reg1+1) <= 1) then
											if((row_AI_reg1=row_AI_reg and col_AI_reg1=col_AI_reg+1) or
												(row_AI_reg1=row_AI_reg2 and col_AI_reg1=col_AI_reg2+1) or
												(row_AI_reg1=row_tank and col_AI_reg1=col_tank+1) or
												(row_AI_reg1=row_tank2 and col_AI_reg1=col_tank2+1)) then
												row_AI_next1 <= row_AI_reg1;
												col_AI_next1 <= col_AI_reg1;
											else
												row_AI_next1 <= row_AI_reg1;
												col_AI_next1 <= col_AI_reg1 + 1;
											end if;												
										end if;
					end case;
					end if;
					if( sAI2_on='0') then col_AI_next2 <= 0; row_AI_next2 <= 0;
					else
					case dir2 is
						when "00" =>
										if(row_AI_reg2 > 1 and maps_AI(row_AI_reg2-1,col_AI_reg2) <= 1) then
											if((row_AI_reg2=row_AI_reg1+1 and col_AI_reg2=col_AI_reg1) or
												(row_AI_reg2=row_AI_reg+1 and col_AI_reg2=col_AI_reg1) or
												(row_AI_reg2=row_tank+1 and col_AI_reg2=col_tank) or
												(row_AI_reg2=row_tank2+1 and col_AI_reg2=col_tank2)) then
												row_AI_next2 <= row_AI_reg2;
												col_AI_next2 <= col_AI_reg2;
											else
												row_AI_next2 <= row_AI_reg2 - 1;
												col_AI_next2 <= col_AI_reg2;
											end if;
										end if;
						when "01" =>
										if(row_AI_reg2 < 22 and maps_AI(row_AI_reg2+1,col_AI_reg2) <= 1) then
											if((row_AI_reg2=row_AI_reg1-1 and col_AI_reg2=col_AI_reg1) or
												(row_AI_reg2=row_AI_reg-1 and col_AI_reg2=col_AI_reg) or
												(row_AI_reg2=row_tank-1 and col_AI_reg2=col_tank) or
												(row_AI_reg2=row_tank2-1 and col_AI_reg2=col_tank2))  then
												row_AI_next2 <= row_AI_reg2;
												col_AI_next2 <= col_AI_reg2;
											else
												row_AI_next2 <= row_AI_reg2 + 1;
												col_AI_next2 <= col_AI_reg2;
											end if;
										end if;
						when "10" =>
										if(col_AI_reg2 > 1 and maps_AI(row_AI_reg2,col_AI_reg2-1) <= 1) then
											if((row_AI_reg2=row_AI_reg1 and col_AI_reg2=col_AI_reg1+1) or
												(row_AI_reg2=row_AI_reg and col_AI_reg2=col_AI_reg+1) or
												(row_AI_reg2=row_tank and col_AI_reg2=col_tank+1) or
												(row_AI_reg2=row_tank2 and col_AI_reg2=col_tank2+1)) then
												row_AI_next2 <= row_AI_reg2;
												col_AI_next2 <= col_AI_reg2;
											else
												row_AI_next2 <= row_AI_reg2;
												col_AI_next2 <= col_AI_reg2 - 1;
											end if;
										end if;
						when "11" => 
										if(col_AI_reg2 < 23 and maps_AI(row_AI_reg2,col_AI_reg2+1) <= 1) then
											if((row_AI_reg2=row_AI_reg1 and col_AI_reg2=col_AI_reg1+1) or
												(row_AI_reg2=row_AI_reg and col_AI_reg2=col_AI_reg+1) or
												(row_AI_reg2=row_tank and col_AI_reg2=col_tank+1) or
												(row_AI_reg2=row_tank2 and col_AI_reg2=col_tank2+1)) then
												row_AI_next2 <= row_AI_reg2;
												col_AI_next2 <= col_AI_reg2;
											else
												row_AI_next2 <= row_AI_reg2;
												col_AI_next2 <= col_AI_reg2 + 1;
											end if;
										end if;	
					end case;
					end if;
				end if;

				
--				if(sAI_on='0')  then col_AI_next  <= 0; row_AI_next  <= 0;
--				end if;
--				if(sAI1_on='0') then col_AI_next1 <= 0; row_AI_next1 <= 0;
--				end if;
--				if(sAI2_on='0') then col_AI_next2 <= 0; row_AI_next2 <= 0;
--				end if;
--				
			end if;
		end if;
	end process;
	-- process (refr_tick)
	-- begin
		-- if(refr_tick'event and refr_tick = '1') then
			-- refr_tick2 <= not refr_tick2;
		-- end if;
	-- end process;
	-- process (refr_tick2)
	-- begin
		-- if(refr_tick2'event and refr_tick2 = '1') then
			-- refr_tick4 <= not refr_tick4;
		-- end if;
	-- end process;
	process (clk)
	variable c,c2: integer range 0 to 2000000;
	begin
		if (clk'event and clk = '1') then
			if (c>=1) then
				if (c <1999999) then
					c:= c+1;shooted_t1_buf <= '1';
				else
					shooted_t1_buf <= '0'; c:=0;
				end if;
			end if;
			if (c2>=1) then
				if (c2 <1999999) then
					c2:= c2+1;shooted_t2_buf <= '1';
				else
					shooted_t2_buf <= '0'; c2:=0;
				end if;
			end if;
			if((b_col_t1=col_AI_next and b_row_t1=row_AI_next and sAI_on/= '0') or
				(b_col_t1=col_AI_next1 and b_row_t1=row_AI_next1 and sAI1_on/= '0') or 
				(b_col_t1=col_AI_next2 and b_row_t1=row_AI_next2 and sAI2_on/= '0')) then
				c:= 1;
			end if;	
			if (
				(b_col_t2 = col_AI_next and b_row_t2 = row_AI_next and sAI_on/= '0') or
				(b_col_t2 = col_AI_next1 and b_row_t2 = row_AI_next1 and sAI1_on/= '0') or
				(b_col_t2 = col_AI_next2 and b_row_t2 = row_AI_next2 and sAI2_on/= '0')) then
				c2:=1;
			end if;
		end if;
	end process;
	-- process (shooted_t1_buf)
	-- begin
		-- if (shooted_t1_buf'event and shooted_t1_buf = '1') then
			-- bum_col_t1 <= b_col_t1;
			-- bum_row_t1 <= b_row_t1;
		-- end if;
	-- end process;
	-- process (shooted_t2_buf)
	-- begin
		-- if (shooted_t2_buf'event and shooted_t2_buf = '1') then
			-- bum_col_t2 <= b_col_t2;
			-- bum_row_t2 <= b_row_t2;
		-- end if;
	-- end process;
	
	process(dir,dir1,dir2)
	begin
		case dir is
			when "00" => tank_AI_rgb<=tank_up_rgb;
			when "01" => tank_AI_rgb<=tank_down_rgb;
			when "10" => tank_AI_rgb<=tank_left_rgb;
			when "11" => tank_AI_rgb<=tank_right_rgb;
		end case;		
		case dir1 is
			when "00" => tank1_AI_rgb<=tank_up_rgb;
			when "01" => tank1_AI_rgb<=tank_down_rgb;
			when "10" => tank1_AI_rgb<=tank_left_rgb;
			when "11" => tank1_AI_rgb<=tank_right_rgb;
		end case;
		case dir2 is
			when "00" => tank2_AI_rgb<=tank_up_rgb;
			when "01" => tank2_AI_rgb<=tank_down_rgb;
			when "10" => tank2_AI_rgb<=tank_left_rgb;
			when "11" => tank2_AI_rgb<=tank_right_rgb;
		end case;
	end process;
	AI_up_rgb <= tank_up_rgb;
	shooted_t1 <= shooted_t1_buf;
	shooted_t2 <= shooted_t2_buf;
	AI_on <= sAI_on;
	AI1_on <= sAI1_on;
	AI2_on <= sAI2_on;
	row_AI <= row_AI_next;
	col_AI <= col_AI_next;
	row_AI1 <= row_AI_next1;
	col_AI1 <= col_AI_next1;
	row_AI2 <= row_AI_next2;
	col_AI2 <= col_AI_next2;
	score_chuc <= score_chuc_reg;
	score_dvi <= score_dvi_reg;
	score_chuc2 <= score_chuc_reg2;
	score_dvi2 <= score_dvi_reg2;
	victory <= '1' when (sAI_on='0' and sAI1_on='0' and sAI2_on='0') else
			   '0';
	fz_rgb_on <= '1' when fz_rgb /= "000000000000" else '0';
	freeze_rgb <= fz_rgb;
	address <= conv_std_logic_vector((conv_integer(pixel_y) - row*20)*20 + (conv_integer(pixel_x) - col*20),9);	
	AI_rgb <= fz_rgb when ((row = row_AI_next  and col = col_AI_next) or
							(row = row_AI_next1 and col = col_AI_next1) or
							(row = row_AI_next2 and col = col_AI_next2)) and fz = '1' and fz_rgb_on = '1' else
			buzz_rgb when ((row = b_row_t1 and col = b_col_t1 and shooted_t1_buf = '1') or (row = b_row_t2 and col = b_col_t2 and shooted_t2_buf = '1')) else
			tank_AI_rgb  when (row = row_AI_next  and col = col_AI_next ) and sAI_on  = '1' else
			tank1_AI_rgb when (row = row_AI_next1 and col = col_AI_next1) and sAI1_on = '1' else
			tank2_AI_rgb when (row = row_AI_next2 and col = col_AI_next2) and sAI2_on = '1' else
			"000000000000" when (b_col_t1=col_AI_next and b_row_t1=row_AI_next) or (b_col_t2=col_AI_next and b_row_t2=row_AI_next) or (b_col_t1=col_AI_next1 and b_row_t1=row_AI_next1) or (b_col_t2=col_AI_next1 and b_row_t2=row_AI_next1) or (b_col_t1=col_AI_next2 and b_row_t1=row_AI_next2) or (b_col_t2=col_AI_next2 and b_row_t2=row_AI_next2) else
			"000000000000" when sAI_on='0' and sAI1_on='0' and sAI2_on='0' else
			"000000000000";
end behavior;	
				
