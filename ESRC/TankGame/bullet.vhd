library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use work.data_maps.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity bullet is

port (
	maps	   		            : in maps_type;
	reset                       : in std_logic;
	direct	                    : in std_logic_vector(1 downto 0);
	b_shoot                     : in std_logic;
	col_tank                    : in integer range 1 to 23;
	row_tank                    : in integer range 1 to 22;
	refr_tick                   : in std_logic;
	clk					 	    : in std_logic;	
	col_des,b_col               : out integer range 1 to 23;
	row_des,b_row               : out integer range 1 to 22;
	score_chuc,score_dvi        : out integer range 0 to 9;
	b_buf				 		: out integer range 0 to 9;
	b_dir				 		: out std_logic;
	b_on				 		: out std_logic;
	shooted						: in std_logic;
	star_active					: in std_logic;
	b_sound						: out std_logic
	
);
end bullet;

architecture behavior of bullet is
signal b_buf_next,b_buf_reg: integer range 0 to 9;
signal score_chuc_reg,score_chuc_next,score_dvi_next,score_dvi_reg: integer range 0 to 9;
signal b_timer_reg,b_timer_next: integer range 0 to 5;
signal 	r_value	: integer range 0 to 4;
signal b_row_des,b_row_reg,b_row_next,b_row_check: integer range 0 to 22;
signal b_col_des,b_col_reg,b_col_next,b_col_check: integer range 0 to 23;
signal b_reg_up,b_reg_down,b_reg_left,b_reg_right: std_logic;
signal b_next_up,b_next_down,b_next_left,b_next_right: std_logic;
signal b_clk,b_on_in,b_on_temp,bullet: std_logic;
begin
	process (clk)
	begin
		if (clk'event and clk = '1') then
			b_col_reg <= b_col_next;
			b_row_reg <= b_row_next;
			b_buf_reg <= b_buf_next;
			b_reg_up <= b_next_up;
			b_reg_down <= b_next_down;
			b_reg_left <= b_next_left;
			b_reg_right <= b_next_right;
			b_timer_reg <= b_timer_next;
			score_chuc_reg <= score_chuc_next;
			score_dvi_reg <= score_dvi_next;
		end if;
	end process;
	process (refr_tick)
	begin
		if (refr_tick'event and refr_tick = '1') then
			b_clk <= not b_clk;
		end if;
	end process;
	process (b_clk)
	variable c: std_logic := '0';
	begin
		if (b_clk'event and b_clk = '1') then	
			if(reset = '1') then
				b_buf_next <= 0;
				score_chuc_next <= 0;
				score_dvi_next <= 0;
				b_row_next <= row_tank;
				b_col_next <= col_tank;				
			else
				if (b_reg_up = '0' and b_reg_down = '0' and b_reg_left = '0' and b_reg_right = '0') then
					b_row_next <= row_tank;
					b_col_next <= col_tank;
				end if;
				if (b_shoot = '1' ) then
					if (b_timer_reg = 5) then
						b_timer_next <= 0;
						if (b_reg_up = '0' and b_reg_down = '0' and b_reg_left = '0' and b_reg_right = '0') then
							b_on_temp <= '1';
							c := '1';
							if    direct = "00" then b_next_up <= '1';
							elsif direct = "01" then b_next_down <= '1';
							elsif direct = "10" then b_next_left <= '1';
							elsif direct = "11" then b_next_right <= '1';
							end if;
						end if;
					else
						b_timer_next <= b_timer_reg + 1;
					end if;
				end if;
				if (c = '1') then
					b_sound <= '1';
					c := '0';
				else
					b_sound <= '0';
				end if;
				if (b_reg_up = '1') then
					b_row_check <= b_row_reg - 1;
					b_col_check <= b_col_reg;
					if (b_row_reg > 1 and r_value <=2 and shooted = '0') then
						if (b_buf_reg = 5) then 					
							b_row_next <= b_row_reg - 1;
						end if;
						if (b_buf_reg = 5) then
							b_buf_next <= 0;
						else
							b_buf_next <= b_buf_reg + 1;
						end if;
					else
						b_next_up <= '0';
						if (r_value = 3 or (r_value = 4 and star_active = '1')) then 
							b_row_des <= b_row_reg - 1;
							b_col_des <= b_col_reg; 
							if (score_dvi_reg = 9) then
								score_dvi_next <= 0;
								score_chuc_next <= score_chuc_reg + 1;
							else
								score_dvi_next <= score_dvi_reg + 1;
							end if;
						end if;
					end if;
				elsif (b_reg_down = '1') then
					b_row_check <= b_row_reg + 1;
					b_col_check <= b_col_reg;
					if (b_row_reg < 22 and r_value <=2 and shooted = '0') then
						if (b_buf_reg = 0) then 					
							b_row_next <= b_row_reg + 1;
						end if;
						if (b_buf_reg = 0) then
							b_buf_next <= 5;
						else	
							b_buf_next <= b_buf_reg - 1;
						end if;
					else
						b_next_down <= '0';
						if (r_value = 3 or (r_value = 4 and star_active = '1')) then 
							b_row_des <= b_row_reg + 1;
							b_col_des <= b_col_reg;
							if (score_dvi_reg = 9) then
								score_dvi_next <= 0;
								score_chuc_next <= score_chuc_reg + 1;
							else
								score_dvi_next <= score_dvi_reg + 1;
							end if;
						end if;
					end if;
				elsif (b_reg_left = '1') then
					b_row_check <= b_row_reg;
					b_col_check <= b_col_reg - 1;
					if (b_col_reg > 1 and r_value <=2 and shooted = '0') then
						if (b_buf_reg = 5) then 					
							b_col_next <= b_col_reg - 1;
						end if;
						if (b_buf_reg = 5) then
							b_buf_next <= 0;
						else
							b_buf_next <= b_buf_reg + 1;
						end if;
					else
						b_next_left <= '0';
						if (r_value = 3 or (r_value = 4 and star_active = '1')) then 
							b_row_des <= b_row_reg;
							b_col_des <= b_col_reg - 1;
							if (score_dvi_reg = 9) then
								score_dvi_next <= 0;
								score_chuc_next <= score_chuc_reg + 1;
							else
								score_dvi_next <= score_dvi_reg + 1;
							end if;
						end if;
					end if;
				elsif (b_reg_right = '1') then
					b_row_check <= b_row_reg;
					b_col_check <= b_col_reg + 1;
					if (b_col_reg < 23 and r_value <=2 and shooted = '0') then
						if (b_buf_reg = 0) then 					
							b_col_next <= b_col_reg + 1;
						end if;
						if (b_buf_reg = 0) then
							b_buf_next <= 5;
						else
							b_buf_next <= b_buf_reg - 1;
						end if;
					else
						b_next_right <= '0';
						if (r_value = 3 or (r_value = 4 and star_active = '1')) then 
							b_row_des <= b_row_reg;
							b_col_des <= b_col_reg + 1;
							if (score_dvi_reg = 9) then
								score_dvi_next <= 0;
								score_chuc_next <= score_chuc_reg + 1;
							else
								score_dvi_next <= score_dvi_reg + 1;
							end if;
						end if;
					end if;					
				end if;
--				if(col_AI=b_col and row_AI=b_row) then
--					col_des<=col_AI;
--					row_des<=row_AI;
--				end if;
			end if;
		end if;
	end process;
	r_value <=	maps(b_row_check,b_col_check);
	b_on <= '1' when (b_reg_up = '1' or b_reg_down = '1' or b_reg_left = '1' or b_reg_right = '1' ) else '0';
	b_dir <= '1' when (b_reg_up = '1' or b_reg_down = '1') else '0';
	b_buf <= b_buf_reg;
	b_col <= b_col_reg;
	b_row <= b_row_reg;
	col_des <= b_col_des;
	row_des <= b_row_des;
	score_chuc <= score_chuc_reg;
	score_dvi <= score_dvi_reg;

end behavior;