library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.data_maps.all;
entity maps is
	port (
		game_over		: out std_logic;
		vic             : out std_logic;
		maps_on         : out std_logic;
		maps_rgb        : out std_logic_vector (11 downto 0);
		col             : in integer range 0 to 31;
		row             : in integer range 0 to 23;
		pixel_x,pixel_y : in std_logic_vector (9 downto 0);
		clk			  	: in std_logic;
		reset   	    : in std_logic;
		btnp1           : in std_logic_vector (5 downto 0);
		btnp2           : in std_logic_vector (5 downto 0);
		refr_tick       : in std_logic;
		p_tick          : in std_logic;
		I2C_SDAT : inout std_logic; -- I2C Data
		I2C_SCLK : out std_logic;   -- I2C Clock
		-- Audio CODEC
		AUD_ADCLRCK : inout std_logic;                      -- ADC LR Clock
		AUD_ADCDAT : in std_logic;                          -- ADC Data
		AUD_DACLRCK : inout std_logic;                      -- DAC LR Clock
		AUD_DACDAT : out std_logic;                         -- DAC Data
		AUD_BCLK : inout std_logic;                         -- Bit-Stream Clock
		AUD_XCK : out std_logic;                            -- Chip Clock
		count: in std_logic_vector(2 downto 0)
	);
end maps;

architecture behavior of maps is


signal address,b_address,b_address_a,b_address_b,b_address2,b_address_a2,b_address_b2,b_address_AI,b_address_AI1,b_address_AI2,b_address_AI_a,b_address_AI_b,b_address_AI1_a,b_address_AI1_b,b_address_AI2_a,b_address_AI2_b: std_logic_vector(8 downto 0);
signal ad_ca,ad_ra,ad_cb,ad_rb : std_logic_vector(8 downto 0);
signal tank_AI_rgb,fz_rgb,b_rgb,b_rgb2,brick_rgb,grass_rgb,stone_rgb,iron_rgb,tank_up_rgb,tank_down_rgb,tank_left_rgb,tank_right_rgb,tank1_rgb,tank2_rgb,water_rgb,b_AI_rgb,b_AI1_rgb,b_AI2_rgb,life_rgb,star_rgb: std_logic_vector(11 downto 0);
signal col_next,col_reg,col_next2,col_reg2,col_check,col_check2: integer range 0 to 23;
signal row_next,row_reg,row_next2,row_reg2,row_check,row_check2: integer range 0 to 22;
signal col_des,b_col_t1,col_des_t1,b_col_t2,col_des_t2: integer range 0 to 23;
signal row_des,b_row_t1,row_des_t1,b_row_t2,row_des_t2: integer range 0 to 22;
signal p_x,p_y: integer range 0 to 39;
signal direct,direct2 : std_logic_vector (1 downto 0);
signal move,move2,des: std_logic;
signal r_value,r_value2: integer range 0 to 4;
signal b_on,b_on2,grass_on,b_appear_t1,b_appear_t2,b_appear_AI,b_appear_AI1,b_appear_AI2,b_on_AI,b_on_AI1,b_on_AI2: std_logic;
signal b_dir_t1,b_dir_t2,b_dir_AI,b_dir_AI1,b_dir_AI2: std_logic;
signal buf_reg,buf_next,buf_reg2,buf_next2: integer range 0 to 19;
signal buf_timer,buf_timer2,b_buf_t1,b_buf_t2,b_buf_AI,b_buf_AI1,b_buf_AI2: integer range 0 to 9;
signal dir, dir1, dir2: std_logic_vector(1 downto 0);
signal AI_rgb: std_logic_vector(11 downto 0);
signal row_AI, row_AI1, row_AI2: integer range 0 to 23;
signal col_AI, col_AI1, col_AI2: integer range 0 to 31;
signal b_col_AI, b_col_AI1, b_col_AI2: integer range 0 to 31;
signal b_row_AI, b_row_AI1, b_row_AI2: integer range 0 to 23;
signal col_des_AI, col_des_AI1, col_des_AI2: integer range 0 to 31;
signal row_des_AI, row_des_AI1, row_des_AI2: integer range 0 to 23;
---------------------------------------------------------------------------------------
signal AI_chuc_t1,AI_dvi_t1,score_chuc_t1,score_dvi_t1: integer range 0 to 9;
signal AI_chuc_t2,AI_dvi_t2,score_chuc_t2,score_dvi_t2: integer range 0 to 9;
------------------------------------------------------------------------------
signal AI_on,AI1_on,AI2_on,victory: std_logic;
signal b_shoot,b_shoot1,b_shoot2: std_logic:='1';
signal counter: integer range 0 to 3:=3;
signal counter2: integer range 0 to 3:=3;
signal stank_on: std_logic:='1';
signal stank2_on: std_logic:='1';
signal life_t1_on,life_t2_on : std_logic;
signal eat_item_check,eat_item_check_t1,eat_item_check_t2,item_on: std_logic;
signal item_type : std_logic_vector(1 downto 0);
signal shooted_t1,shooted_t2: std_logic;
signal col_item_check: integer range 0 to 31;
signal row_item_check: integer range 0 to 23;
signal star_active_t1: std_logic := '0';
signal star_active_t2: std_logic := '0';
signal fz_active_t1: std_logic := '0';
signal fz_active_t2: std_logic := '0';
signal fz: std_logic := '0';
signal b_sound_t1,b_sound_t2 : std_logic;
signal shoot, shoot2: std_logic;
signal game_over_temp,ss_on: std_logic;
signal t1_c1,t1_c2,t1_c3,t1_c4,t2_c1,t2_c2,t2_c3,t2_c4: std_logic;
-- buffer move----------------------------------------
signal address_t1_a,address_t1_b,address_t2_a,address_t2_b: std_logic_vector(8 downto 0);
signal tank_up_rgb2,tank_down_rgb2,tank_left_rgb2,tank_right_rgb2 : std_logic_vector(11 downto 0);
signal row_t1,row_t2: integer range 0 to 22;
signal col_t1,col_t2: integer range 0 to 23;
signal p_x_t1,p_x_t1_temp,p_y_t1,p_y_t1_temp,p_x_t2,p_x_t2_temp,p_y_t2,p_y_t2_temp: integer range 0 to 39;
signal ena_AI: std_logic;
signal boss_rgb: std_logic_vector(11 downto 0);
signal maps_1: maps_type;

constant maps_01: maps_type:= 
	(
		(4,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,4),
		(0,0,3,3,3,3,3,0,0,0,0,0,0,0,0,4,4,0,0,0,1,1,2),
		(0,0,3,3,3,3,3,0,0,4,4,4,4,4,0,4,4,0,0,0,1,1,2),
		(3,0,0,0,0,2,2,0,0,2,2,2,2,2,0,4,4,0,3,0,1,1,2),
		(3,0,1,1,0,2,2,0,0,2,2,2,2,2,0,4,4,0,3,0,0,0,0),
		(3,0,0,0,0,2,2,0,0,2,0,3,0,2,0,4,4,0,3,0,0,0,0),
		(3,3,3,0,0,0,0,0,0,3,3,3,3,3,0,4,4,0,3,3,3,3,3),
		(0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0),
		(0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0),
		(1,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,2,2),
		(1,1,1,1,1,1,0,0,0,3,3,1,3,3,0,2,0,0,0,0,0,0,0),
		(1,1,1,1,0,0,0,0,0,3,3,1,3,3,0,2,0,4,4,4,4,4,4),
		(0,0,2,2,2,2,0,0,0,0,0,1,0,0,0,2,0,0,0,0,2,0,0),
		(0,0,2,0,0,0,0,0,0,0,0,1,0,0,0,2,0,0,0,0,2,0,0),
		(0,0,2,0,0,0,0,0,0,3,3,3,3,3,0,2,0,3,3,3,2,2,2),
		(0,0,2,0,0,4,0,0,0,3,3,3,3,3,0,2,0,0,4,0,0,0,0),
		(0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0),
		(3,3,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0),
		(0,0,3,3,0,4,0,0,0,3,4,4,4,3,0,0,0,0,4,0,0,0,0),
		(0,0,3,3,0,0,0,0,0,3,3,3,3,3,0,0,0,0,0,0,0,0,0),
		(0,0,3,3,0,0,0,0,0,3,3,3,3,3,0,0,0,0,0,0,0,0,0),
		(0,0,3,3,0,0,0,0,0,3,3,3,3,3,0,0,0,0,0,0,0,0,0)
	);
constant maps_02: maps_type:=
	(	
		(4,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,4),
		(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		(0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0),
		(0,0,0,0,0,0,0,0,1,1,1,1,1,0,3,3,0,0,0,0,0,0,0),
		(0,0,3,3,0,0,0,0,0,0,0,0,0,0,3,3,0,0,1,1,0,0,0),
		(0,0,3,3,0,0,0,1,0,0,4,4,4,0,3,3,0,0,1,1,0,0,0),
		(3,0,3,3,0,0,0,1,0,0,4,1,4,0,3,3,0,0,1,1,0,0,1),
		(3,0,3,3,0,0,0,1,0,0,4,4,4,0,3,3,0,0,1,1,0,0,1),
		(3,0,0,0,0,3,0,1,0,0,0,0,0,0,3,3,0,0,1,1,0,2,1),
		(3,3,0,0,3,3,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1),
		(3,3,0,0,0,3,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,2,1),
		(3,1,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,2,1),
		(3,1,0,0,0,0,4,0,2,2,0,0,3,0,2,2,0,4,4,0,0,0,1),
		(1,1,4,4,0,0,4,0,2,0,0,0,0,0,0,0,0,4,4,0,0,0,0),
		(1,1,4,4,0,0,4,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		(1,0,0,0,0,0,4,0,0,0,0,1,3,1,0,0,0,0,0,0,0,0,0),
		(1,0,0,0,0,0,0,0,0,0,0,1,3,1,0,3,3,3,3,3,0,0,0),
		(0,0,2,0,0,3,3,3,0,0,0,1,4,1,0,3,3,3,3,3,0,0,0),
		(0,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		(0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0),
		(0,1,1,3,3,3,0,0,0,0,3,3,3,0,0,0,0,3,3,0,1,1,0),
		(0,0,3,3,0,0,0,0,0,0,3,0,3,0,0,0,0,0,0,0,1,1,0)		
	);


constant maps_03: maps_type:=
	(	
		(4,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,4),
		(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		(0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,4,0,2,2),
		(0,1,1,1,0,0,0,0,0,0,0,0,0,0,2,2,0,0,4,0,0,0,0),
		(0,4,4,4,0,0,3,0,0,0,0,0,0,0,2,0,0,0,4,0,0,0,0),
		(0,0,0,2,0,0,3,0,0,0,3,3,3,0,2,0,0,0,0,0,0,0,0),
		(0,0,0,2,0,0,3,0,0,0,3,4,3,0,0,0,3,3,3,3,3,2,0),
		(0,0,0,0,0,0,3,3,1,1,3,4,3,0,0,0,0,0,0,1,1,4,0),
		(0,0,1,4,0,0,0,0,1,1,4,4,4,0,0,0,0,0,0,0,1,4,0),
		(2,0,1,4,0,0,0,0,1,1,0,0,2,0,0,0,0,0,0,0,1,4,0),
		(2,0,4,4,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,4,0),
		(2,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,4,0,0,0,0,1,0),
		(2,0,0,0,0,0,0,3,0,0,3,3,3,0,3,0,4,0,0,0,0,1,0),
		(0,0,0,0,0,0,0,3,0,0,0,0,0,0,3,0,4,0,0,0,0,0,0),
		(0,0,0,0,0,0,0,3,0,0,0,0,0,0,3,0,4,0,0,0,0,0,0),
		(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0),
		(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0),
		(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0),
		(0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0),
		(0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0),
		(0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0),
		(0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0)
	);

	
--text signal
signal char_out, char_on : std_logic;

begin
	boss:       entity work.boss_rom			 port map (address,clk,boss_rgb);
	brick:      entity work.brick_rom       port map (address,clk,brick_rgb);
	grass:      entity work.grass_rom       port map (address,clk,grass_rgb);
	stone:      entity work.stone_rom       port map (address,clk,stone_rgb);
	iron:       entity work.iron_rom        port map (address,clk,iron_rgb);
	tank_ud_rom: entity work.tank_ud_rom port map (address_t1_a,"110010000" - address_t1_a,clk,tank_up_rgb,tank_down_rgb);
	tank_lr_rom: entity work.tank_lr_rom port map (address_t1_b,"110010000" - address_t1_b,clk,tank_left_rgb,tank_right_rgb);
	tank_ud_rom2: entity work.tank_ud_rom port map (address_t2_a,"110010000" - address_t2_a,clk,tank_up_rgb2,tank_down_rgb2);
	tank_lr_rom2: entity work.tank_lr_rom port map (address_t2_b,"110010000" - address_t2_b,clk,tank_left_rgb2,tank_right_rgb2);
	water:      entity work.water_rom       port map (address,clk,water_rgb);
	life: entity work.life_rom			 port map (address,clk,life_rgb);
	star:  entity work.star_rom				 port map (address,clk,star_rgb);
	bullet_rgb: entity work.b_center_rom    port map (b_address,clk,b_rgb);
	bullet_rgb2:entity work.b_center_rom    port map (b_address2,clk,b_rgb2);
	bullet_AI_rgb: entity work.b_center_rom     port map (b_address_AI,clk,b_AI_rgb);
	bullet_AI1_rgb: entity work.b_center_rom    port map (b_address_AI1,clk,b_AI1_rgb);
	bullet_AI2_rgb: entity work.b_center_rom    port map (b_address_AI2,clk,b_AI2_rgb);
	char_value: entity work.char_value		port map (char_out, char_on, pixel_x, pixel_y, score_chuc_t1, score_dvi_t1, 0, score_chuc_t2, score_dvi_t2,0,
	ai_dvi_t1, ai_chuc_t1, ai_dvi_t2, ai_chuc_t2, p_tick, reset);
	bullet_t1: 	entity work.bullet 			port map (maps_1,reset,direct,shoot,col_reg,row_reg,refr_tick,clk,col_des_t1,b_col_t1,row_des_t1,b_row_t1,score_chuc_t1,score_dvi_t1,b_buf_t1,b_dir_t1,b_appear_t1,shooted_t1,star_active_t1,b_sound_t1);
	bullet_t2: 	entity work.bullet 			port map (maps_1,reset,direct2,shoot2,col_reg2,row_reg2,refr_tick,clk,col_des_t2,b_col_t2,row_des_t2,b_row_t2,score_chuc_t2,score_dvi_t2,b_buf_t2,b_dir_t2,b_appear_t2,shooted_t2,star_active_t2,b_sound_t2);
--	freeze: entity work.fz_rom 					port map (address,clk,fz_rgb);

	
	AI: entity work.AI
		 port map(	fz => fz,
					maps_AI => maps_1,
					refr_tick => refr_tick,
					col => col,
					row => row,
					b_col_t1 => b_col_t1, b_row_t1 => b_row_t1,
					b_col_t2 => b_col_t2, b_row_t2 => b_row_t2,
					clk => clk,
					clk_db => refr_tick,
					reset => reset,
					ena_AI => ena_AI,
					pixel_x => pixel_x, pixel_y => pixel_y,
					dir => dir, dir1 => dir1, dir2 => dir2,
					AI_rgb => AI_rgb,
					row_tank => row_reg, row_tank2 => row_reg2,
					col_tank => col_reg, col_tank2 => col_reg2,
					AI_on => AI_on, AI1_on => AI1_on, AI2_on => AI2_on,
					score_chuc => AI_chuc_t1, score_dvi => AI_dvi_t1,
					score_chuc2 => AI_chuc_t2, score_dvi2 => AI_dvi_t2,
					row_AI => row_AI, row_AI1 => row_AI1, row_AI2 => row_AI2,
					col_AI => col_AI, col_AI1 => col_AI1, col_AI2 => col_AI2,
					victory => victory,
					shooted_t1 => shooted_t1,
					shooted_t2 => shooted_t2,
					freeze_rgb => fz_rgb,
					AI_up_rgb => tank_AI_rgb
					);
	bullet_AI: entity work.bullet
					port map(
								maps => maps_1,
								reset => reset,
								direct => dir,
								b_shoot => '1',
								col_tank => col_AI,
								row_tank => row_AI,
								refr_tick => refr_tick,
								clk => clk,
								col_des => col_des_AI,
								row_des => row_des_AI,
								b_col => b_col_AI,
								b_row => b_row_AI,
								b_buf => b_buf_AI,
								b_dir => b_dir_AI,
								b_on => b_appear_AI,
								shooted => '0',
								star_active => '0',
								b_sound => open
								);
	bullet_AI1: entity work.bullet
					port map(
								maps => maps_1,
								reset => reset,
								direct => dir1,
								b_shoot => '1',
								col_tank => col_AI1,
								row_tank => row_AI1,
								refr_tick => refr_tick,
								clk => clk,
								col_des => col_des_AI1,
								row_des => row_des_AI1,
								b_col => b_col_AI1,
								b_row => b_row_AI1,
								b_buf => b_buf_AI1,
								b_dir => b_dir_AI1,
								b_on => b_appear_AI1,
								shooted => '0',
								star_active => '0',
								b_sound => open
								);
	bullet_AI2: entity work.bullet
					port map(
								maps => maps_1,
								reset => reset,
								direct => dir2,
								b_shoot => '1',
								col_tank => col_AI2,
								row_tank => row_AI2,
								refr_tick => refr_tick,
								clk => clk,
								col_des => col_des_AI2,
								row_des => row_des_AI2,
								b_col => b_col_AI2,
								b_row => b_row_AI2,
								b_buf => b_buf_AI2,
								b_dir => b_dir_AI2,
								b_on => b_appear_AI2,
								shooted => '0',
								star_active => '0',
								b_sound => open
								);
	test_random: entity work.test_random
					 port map(
								clock_50 => clk,
								count => count,
								dir => dir, dir1 => dir1, dir2 => dir2
								);
	item: entity work.item_fsm
			port map(
						clk 		 => clk,
						reset 	 => reset,
						maps 		 => maps_1,
						eat_item  => eat_item_check,
						row       => row_item_check,
						col 		 => col_item_check,
						item_ena  => item_on,
						item_type => item_type
						);
	-- Audio component
	audio: entity work.audio_driver
			port map(
						clk50 => clk,
						i2c_sdat => i2c_sdat,
						i2c_sclk => i2c_sclk,
						AUD_ADCLRCK => aud_adclrck,
						AUD_ADCDAT => AUD_ADCDAT,
						AUD_DACLRCK => AUD_DACLRCK,
						AUD_DACDAT => AUD_DACDAT,
						AUD_BCLK => AUD_BCLK,
						AUD_XCK => AUD_XCK,
						key2 => eat_item_check,
						key1 => b_sound_t1 or b_sound_t2,
						key3 => shooted_t1 or shooted_t2
					);
	process (clk)
	begin
		if (clk'event and clk = '1') then
			row_reg <= row_next;
			col_reg <= col_next;
			buf_reg <= buf_next;
			row_reg2 <= row_next2;
			col_reg2 <= col_next2;
			buf_reg2 <= buf_next2;		
			case btnp1(3 downto 0) is
				when "0001" => direct <= "00";move <= '1';
				when "0010" => direct <= "01";move <= '1';
				when "0100" => direct <= "10";move <= '1';
				when "1000" => direct <= "11";move <= '1';
				when others => move <= '0';
			end case;
			case btnp2(3 downto 0) is
				when "0001" => direct2 <= "00";move2 <= '1';
				when "0010" => direct2 <= "01";move2 <= '1';
				when "0100" => direct2 <= "10";move2 <= '1';
				when "1000" => direct2 <= "11";move2 <= '1';
				when others => move2 <= '0';
			end case;
		end if;
	end process;
	process (refr_tick,direct,row_reg,col_reg,direct2,row_reg2,col_reg2,reset,btnp1(5 downto 4),move)
	variable x: integer :=0;
	variable s_on: std_logic;
	begin
		if (refr_tick'event and refr_tick = '1') then
			x:=x+1;
			if(x<600) then
				s_on:='0';
			else
				s_on:='1';
			end if;
			if(reset = '1') then
					col_next <=	9;
					row_next <= 22;
					col_next2 <= 16;
					row_next2 <= 22;
					des <= '0';
					x:=0;
					b_shoot<='0';
					b_shoot1<='0';
					b_shoot2<='0';
					counter<=3;
					counter2<=3;
					stank_on<='1';
					stank2_on<='1';

					--buf_next <= 0;
			else
				des <= not des;
			-- DI CHUYEN TANK 1
				if (move = '1' and buf_reg = 0) then
					buf_next <= 1;
				end if;
				case direct is
					when "00" => row_check <= row_reg - 1; col_check <= col_reg;
					when "01" => row_check <= row_reg + 1; col_check <= col_reg;
					when "10" => row_check <= row_reg; col_check <= col_reg - 1;
					when "11" => row_check <= row_reg; col_check <= col_reg + 1;
					when others => null;
				end case;
				if (buf_reg /= 0 ) then						
					if  (direct = 0 and row_reg > 1 and r_value <=1) then
						if (buf_reg = 19) then
							if  t1_c1 = '1' then								
								row_next <= row_reg;
							else
								row_next <= row_reg - 1;
							end if;
							buf_next <= 0;
						else 
							buf_next <= buf_reg + 1;
						end if;	
					end if;
					if  (direct = 1 and row_reg < 22 and r_value <=1) then 
						if (buf_reg = 19) then
							if t1_c2 = '1' then
								row_next <= row_reg;
							else
								row_next <= row_reg + 1;
							end if;
							buf_next <= 0;
						else 
							buf_next <= buf_reg + 1;
						end if;
					end if;
					if  (direct = 2 and col_reg > 1 and r_value <=1) then 
						if (buf_reg = 19) then
							if t1_c3 = '1' then
								col_next <= col_reg;
							else
								col_next <= col_reg - 1;
							end if;
							buf_next <= 0;
						else 
							buf_next <= buf_reg + 1;
						end if;
					end if;
					if  (direct = 3 and col_reg < 23 and r_value <=1) then 
						if (buf_reg = 19) then
							if t1_c4 = '1' then
								col_next <= col_reg;
							else
								col_next <= col_reg + 1;
							end if;
							buf_next <= 0;
						else 
							buf_next <= buf_reg + 1;
						end if;
					end if;
				end if;
			-- DI CHUYEN TANK 2
				if (move2 = '1' and buf_reg2 = 0) then
					buf_next2 <= 1;
				end if;
				case direct2 is
					when "00" => row_check2 <= row_reg2 - 1; col_check2 <= col_reg2;
					when "01" => row_check2 <= row_reg2 + 1; col_check2 <= col_reg2;
					when "10" => row_check2 <= row_reg2; col_check2 <= col_reg2 - 1;
					when "11" => row_check2 <= row_reg2; col_check2 <= col_reg2 + 1;
					when others => null;
				end case;
				if (buf_reg2 /= 0 ) then 					
					if  (direct2 = 0 and row_reg2 > 1 and r_value2 <=1)then	
						if (buf_reg2 = 19) then
							if (t2_c1 = '1') then								
								row_next2 <= row_reg2;
							else
								row_next2 <= row_reg2 - 1;
							end if;
							buf_next2 <= 0;
						else 
							buf_next2 <= buf_reg2 + 1;
						end if;
					end if;
					if  (direct2 = 1 and row_reg2 < 22 and r_value2 <=1) then 
						if (buf_reg2 = 19) then
							if (t2_c2 = '1') then
								row_next2 <= row_reg2;
							else
								row_next2 <= row_reg2 + 1;
							end if;
							buf_next2 <= 0;
						else 
							buf_next2 <= buf_reg2 + 1;
						end if;	
					end if;
					if  (direct2 = 2 and col_reg2 > 1 and r_value2 <=1) then 
						if (buf_reg2 = 19) then	
							if  t2_c3 = '1' then
								col_next2 <= col_reg2 ;
							else
								col_next2 <= col_reg2 - 1;
							end if;
							buf_next2 <= 0;
						else 
							buf_next2 <= buf_reg2 + 1;
						end if;
					end if;
					if  (direct2 = 3 and col_reg2 < 23 and r_value2 <=1) then
						if (buf_reg2 = 19) then	
							if  t2_c4 = '1' then
								col_next2 <= col_reg2;
							else
								col_next2 <= col_reg2 + 1;
							end if;
							buf_next2 <= 0;
						else 
							buf_next2 <= buf_reg2 + 1;
						end if;	
					end if;
				end if;
				if (des = '1') then
					row_des <= row_des_t1;
					col_des <= col_des_t1;
				else
					row_des <= row_des_t2;
					col_des <= col_des_t2;
				end if;
				if(AI_on='0')  then b_shoot  <= '0'; end if;
				if(AI1_on='0') then b_shoot1 <= '0'; end if;
				if(AI2_on='0') then b_shoot2 <= '0'; end if;
				if(stank_on='0') then shoot <= '0';
				else shoot <= btnp1(5); end if;
				if(stank2_on='0') then shoot2 <= '0';
				else shoot2 <= btnp2(5); end if;
				
				if(s_on='0') then
					case count is
						when "101" | "111" | "010" => maps_1 <= maps_01; 
						when "100" | "001" 		 => maps_1 <= maps_02;  
						when others 			 => maps_1 <= maps_03;
					end case;
				end if;
				ena_AI <= not s_on;
				
				
-- dan tank 1,2 pha gach
				maps_1(row_des,col_des) 		<= 0;	
				maps_1(row_des_AI,col_des_AI)   <= 0;
				maps_1(row_des_AI1,col_des_AI1) <= 0;
				maps_1(row_des_AI2,col_des_AI2) <= 0;
-- an vat pham life
				if (eat_item_check_t1 = '1') then
					if (item_type = 0 and counter < 3) then
						counter <= counter + 1;	
					end if;
					if (item_type = 1) then 
						star_active_t1 <= '1';
					end if;
					if (item_type = 2) then
						fz_active_t1 <= '1';
					end if;
					-- if (item_type = 3) then 
						-- star_active_t1 <= '1';
					-- end if;
-- tank AI ban tank ta				
				else
					if( (b_col_AI = col_next and b_row_AI=row_next)   or
						(b_col_AI1= col_next and b_row_AI1=row_next) or
						(b_col_AI2= col_next and b_row_AI2=row_next)) then
						if(counter = 0) then
							stank_on <= '0';
						else 
							counter <= counter - 1;
							col_next <= 9;
							row_next <= 22;
							star_active_t1 <= '0';
						end if;
					end if;
					if (item_type /= 2) then
						fz_active_t1 <= '0';
					end if;
				end if;	
				if (eat_item_check_t2 = '1') then
					if (item_type = 0 and counter2 < 3) then
						counter2 <= counter2 + 1;	
					end if;
					if (item_type = 1) then 
						star_active_t2 <= '1';
					end if;
					if (item_type = 2) then
						fz_active_t2 <= '1';
					end if;
-- tank AI ban tank ta				
				else
					if( (b_col_AI  = col_next2 and b_row_AI  = row_next2) or
						(b_col_AI1 = col_next2 and b_row_AI1 = row_next2) or
						(b_col_AI2 = col_next2 and b_row_AI2 = row_next2)) then
						if(counter2 = 0) then
							stank2_on <= '0';
						else 
							counter2 <= counter2-1;
							col_next2 <= 16;
							row_next2 <= 22;
							star_active_t2 <= '0';
						end if;
					end if;
					if (item_type /= 2) then
						fz_active_t2 <= '0';
					end if;
				end if;
				if(stank_on ='0') then col_next  <= 0; row_next  <= 0;
				end if;
				if(stank2_on='0') then col_next2 <= 0; row_next2 <= 0;
				end if;
				
			end if;
		end if;
	end process;
	t1_c1 <= '1' when ((row_reg=row_reg2+1 and col_reg=col_reg2) or
			(row_reg=row_AI+1 and col_reg=col_AI) or
			(row_reg=row_AI1+1 and col_reg=col_AI1) or 
			(row_reg=row_AI2+1 and col_reg=col_AI2)) else '0';
	t1_c2 <='1' when ((row_reg=row_reg2-1 and col_reg=col_reg2) or
			(row_reg=row_AI-1 and col_reg=col_AI) or
			(row_reg=row_AI1-1 and col_reg=col_AI1) or
			(row_reg=row_AI2-1 and col_reg=col_AI2)) else '0';
	t1_c3 <='1' when ((row_reg=row_reg2 and col_reg=col_reg2+1) or
			(row_reg=row_AI and col_reg=col_AI+1) or
			(row_reg=row_AI1 and col_reg=col_AI1+1) or
			(row_reg=row_AI2 and col_reg=col_AI2+1)) else '0';
	t1_c4 <='1' when ((row_reg=row_reg2 and col_reg=col_reg2-1) or
			(row_reg=row_AI and col_reg=col_AI-1) or
			(row_reg=row_AI1 and col_reg=col_AI1-1) or
			(row_reg=row_AI2 and col_reg=col_AI2-1)) else '0';
	
	t2_c1 <='1' when ((row_reg2=row_reg+1 and col_reg2=col_reg) or
			(row_reg2=row_AI+1 and col_reg2=col_AI) or
			(row_reg2=row_AI1+1 and col_reg2=col_AI1) or
			(row_reg2=row_AI2+1 and col_reg2=col_AI2)) else '0';
	t2_c2 <='1' when ((row_reg2=row_reg-1 and col_reg2=col_reg) or
			(row_reg2=row_AI-1 and col_reg2=col_AI) or
			(row_reg2=row_AI1-1 and col_reg2=col_AI1) or
			(row_reg2=row_AI2-1 and col_reg2=col_AI2)) else '0';
	t2_c3 <='1' when ((row_reg2=row_reg and col_reg2=col_reg+1) or
			(row_reg2=row_AI and col_reg2=col_AI+1) or
			(row_reg2=row_AI1 and col_reg2=col_AI1+1) or
			(row_reg2=row_AI2 and col_reg2=col_AI2+1)) else '0';
	t2_c4 <='1' when ((row_reg2=row_reg and col_reg2=col_reg-1) or
			(row_reg2=row_AI and col_reg2=col_AI-1) or
			(row_reg2=row_AI1 and col_reg2=col_AI1-1) or
			(row_reg2=row_AI2 and col_reg2=col_AI2-1)) else '0';

	eat_item_check_t1 <= '1' when (row_next = row_item_check and col_next = col_item_check)else
			 				'0';
	eat_item_check_t2 <= '1' when (row_next2 = row_item_check and col_next2 = col_item_check) else
						'0';
	eat_item_check<= '1' when (eat_item_check_t1 = '1' or eat_item_check_t2 = '1') else
						'0';
	-- process (eat_item_check)
	-- begin
		-- if (eat_item_check'event and eat_item_check = '1') then
	fz <= fz_active_t1 or fz_active_t2;		
	r_value  <= maps_1(row_check ,col_check );
	r_value2 <= maps_1(row_check2,col_check2);
-------------------------------------------------------
	tank1_rgb <= tank_up_rgb    when  direct  = "00" else 
				 tank_down_rgb  when  direct  = "01" else
				 tank_left_rgb  when  direct  = "10" else
				 tank_right_rgb when  direct  = "11";
	tank2_rgb <= tank_up_rgb2    when  direct2 = "00" else
				 tank_down_rgb2  when  direct2 = "01" else
				 tank_left_rgb2  when  direct2 = "10" else
				 tank_right_rgb2 when  direct2 = "11";
	vic <= victory;	
	game_over_temp <= '1' when (stank_on = '0'  and stank2_on = '0') or (b_col_AI=12 and b_row_AI=22 ) or (b_col_AI1=12 and b_row_AI1=22) or (b_col_AI2=12 and b_row_AI2=22) else
				 '0';
	game_over <= game_over_temp;
	p_x <= conv_integer(pixel_x) - col*20;
	p_y <= conv_integer(pixel_y) - row*20;
	address <= conv_std_logic_vector(p_y*20 + p_x,9);
-- buffer move------------------------------------------------------
	p_y_t1_temp <= conv_integer(pixel_y) + buf_reg  - row*20 when direct = "00" else
					conv_integer(pixel_y) + 19 - buf_reg - row*20;
	p_y_t1 <= p_y_t1_temp when p_y_t1_temp <20 else p_y_t1_temp - 19;
	row_t1 <= (conv_integer(pixel_y)+ buf_reg)/20 when (direct = "00") else
				(conv_integer(pixel_y)- buf_reg)/20 when (direct = "01")else 
				row; 
	address_t1_a <=conv_std_logic_vector(p_y_t1 *20 + p_x,9);
	p_x_t1_temp <= conv_integer(pixel_x) + buf_reg - col*20 when direct = "10" else
					conv_integer(pixel_x) + 19 - buf_reg - col*20;
	p_x_t1 <= p_x_t1_temp when p_x_t1_temp <20 else p_x_t1_temp - 19;
	col_t1 <= (conv_integer(pixel_x)+ buf_reg)/20 when (direct = "10") else
				(conv_integer(pixel_x)- buf_reg)/20 when (direct = "11")else 
				col; 
	address_t1_b <=conv_std_logic_vector(p_y *20 + p_x_t1,9);
	
	
	p_y_t2_temp <= conv_integer(pixel_y) + buf_reg2  - row*20 when direct2 = "00" else
					conv_integer(pixel_y) + 19 - buf_reg2 - row*20;
	p_y_t2 <= p_y_t2_temp when p_y_t2_temp <20 else p_y_t2_temp - 19;
	row_t2 <= (conv_integer(pixel_y)+ buf_reg2)/20 when (direct2 = "00") else
				(conv_integer(pixel_y)- buf_reg2)/20 when (direct2 = "01")else 
				row; 
	address_t2_a <=conv_std_logic_vector(p_y_t2 *20 + p_x,9);
	p_x_t2_temp <= conv_integer(pixel_x) + buf_reg2 - col*20 when direct2 = "10" else
					conv_integer(pixel_x) + 19 - buf_reg2 - col*20;
	p_x_t2 <= p_x_t2_temp when p_x_t2_temp <20 else p_x_t2_temp - 19;
	col_t2 <= (conv_integer(pixel_x)+ buf_reg2)/20 when (direct2 = "10") else
				(conv_integer(pixel_x)- buf_reg2)/20 when (direct2 = "11")else 
				col; 
	address_t2_b <=conv_std_logic_vector(p_y *20 + p_x_t2,9);
-----------------------------------------------------------------------	
	
	ad_ca <= (conv_std_logic_vector((p_y - 6)*20 + p_x,9));
	ad_ra <= conv_std_logic_vector((p_y + 6)*20 + p_x,9);
	ad_cb <= (conv_std_logic_vector((p_y)*20 + (p_x - 6),9));
	ad_rb <= conv_std_logic_vector((p_y)*20 + (p_x + 6),9);
-- DAN TANK 1	
	b_address_a <= ad_ca when (b_buf_t1 < 2) else
				 address when ( b_buf_t1 < 4 and b_buf_t1 >=2 ) else
				 ad_ra;
	b_address_b <= ad_cb when (b_buf_t1 < 2) else
				 address when ( b_buf_t1 < 4 and b_buf_t1 >=2 ) else
				 ad_rb;
	b_address <= b_address_a when (b_dir_t1 = '1') else b_address_b;
	b_on <= '1' when b_rgb > "000000000000" else '0';
-- DAN TANK 2
	b_address_a2 <= ad_ca when (b_buf_t2 < 2) else
				 address when ( b_buf_t2 < 4 and b_buf_t2 >=2 ) else
				 ad_ra;
	b_address_b2 <= ad_cb when (b_buf_t2 < 2) else
				 address when ( b_buf_t2 < 4 and b_buf_t2 >=2 ) else
				 ad_rb;
	b_address2 <= b_address_a2 when (b_dir_t2 = '1') else b_address_b2;
	b_on2 <= '1' when b_rgb2 > "000000000000" else '0';
-- bullet TANK AI
	b_address_AI_a <= ad_ca when (b_buf_AI < 2) else
				 address when ( b_buf_AI < 4 and b_buf_AI >=2 ) else
				 ad_ra;
	b_address_AI_b <= ad_cb when (b_buf_AI < 2) else
				 address when ( b_buf_AI < 4 and b_buf_AI >=2 ) else
				 ad_rb;
	b_address_AI <= b_address_AI_a when (b_dir_AI = '1') else b_address_AI_b;
	b_on_AI <= '1' when b_AI_rgb > "000000000000" else '0';
-- bullet TANK AI1
	b_address_AI1_a <= ad_ca when (b_buf_AI1 < 2) else
				 address when ( b_buf_AI1 < 4 and b_buf_AI1 >=2 ) else
				 ad_ra;
	b_address_AI1_b <= ad_cb when (b_buf_AI1 < 2) else
				 address when ( b_buf_AI1 < 4 and b_buf_AI1 >=2 ) else
				 ad_rb;
	b_address_AI1 <= b_address_AI1_a when (b_dir_AI1 = '1') else b_address_AI1_b;
	b_on_AI1 <= '1' when b_AI1_rgb > "000000000000" else '0';
-- bullet TANK AI2
	b_address_AI2_a <= ad_ca when (b_buf_AI2 < 2) else
				 address when ( b_buf_AI2 < 4 and b_buf_AI2 >=2 ) else
				 ad_ra;
	b_address_AI2_b <= ad_cb when (b_buf_AI2 < 2) else
				 address when ( b_buf_AI2 < 4 and b_buf_AI2 >=2 ) else
				 ad_rb;
	b_address_AI2 <= b_address_AI2_a when (b_dir_AI2 = '1') else b_address_AI2_b;
	b_on_AI2 <= '1' when b_AI2_rgb > "000000000000" else '0';
	
	maps_on  <= '1' when maps_1(row,col) > 0;	
	grass_on <= '1' when grass_rgb > "000000000000" else '0';
	
	life_t1_on <= '1' when (row = 4 and col>= 26 and col <= 28 and counter = 3) else
					'1' when (row = 4 and col>= 26 and col <= 27 and counter = 2) else
					'1' when (row = 4 and col=26 and counter = 1) else
					'0';
	life_t2_on <= '1' when (row = 14 and col>= 26 and col <= 28 and counter2 = 3) else
					'1' when (row = 14 and col>= 26 and col <= 27 and counter2 = 2) else
					'1' when (row = 14 and col=26 and counter2 = 1) else
					'0';
				
-- hien thi so mang cua nguoi choi
	maps_rgb <= 
				iron_rgb 	   when (row = 0 or row = 23 or col = 0 or col =31 or col = 24) else
				boss_rgb 			when (row = 22 and col = 12) else
				"111100000000" when (char_on = '1' and char_out = '1') else
				life_rgb when life_t1_on = '1' or life_t2_on = '1' else
				star_rgb when ((row = 5 and col = 26 and star_active_t1 = '1') or (row = 15 and col = 26 and star_active_t2 = '1')) else
				fz_rgb when ((row = 5 and col = 27 and fz_active_t1 = '1') or (row = 15 and col = 27 and fz_active_t2 = '1')) else
				tank_AI_rgb when ((row = 6 and col = 26) or (row = 16 and col = 26)) else
				"000000000000" when (row>0 and row <23 and col>24 and col<31) else
				
				grass_rgb when (grass_on = '1' and maps_1(row,col) = 1) else	
				brick_rgb when maps_1(row,col) = 3 else
				stone_rgb when maps_1(row,col) = 4 else
				
				tank1_rgb when (row_t1 = row_reg and col_t1 = col_reg) else
				tank2_rgb when (row_t2 = row_reg2 and col_t2 = col_reg2) else
				"000000000000" when ((row = row_reg and col = col_reg) or (row = row_reg2 and col = col_reg2)) else
				
				b_rgb  when (b_on  = '1' and row = b_row_t1 and col = b_col_t1 and b_appear_t1 = '1') else
				b_rgb2 when (b_on2 = '1' and row = b_row_t2 and col = b_col_t2 and b_appear_t2 = '1') else
				b_AI_rgb when  (b_on_AI = '1'  and row = b_row_AI  and col = b_col_AI  and b_appear_AI  = '1') and AI_on='1'  else
				b_AI1_rgb when (b_on_AI1 = '1' and row = b_row_AI1 and col = b_col_AI1 and b_appear_AI1 = '1') and AI1_on='1' else
				b_AI2_rgb when (b_on_AI2 = '1' and row = b_row_AI2 and col = b_col_AI2 and b_appear_AI2 = '1') and AI2_on='1' else				
				water_rgb when maps_1(row,col) = 2 else
				"000000000000" when (b_col_AI=col_next and b_row_AI=row_next) or (b_col_AI1=col_next and b_row_AI1=row_next) or (b_col_AI2=col_next and b_row_AI2=row_next) or (b_col_AI=col_next2 and b_row_AI=row_next2) or (b_col_AI1=col_next2 and b_row_AI1=row_next2) or (b_col_AI2=col_next2 and b_row_AI2=row_next2) else
--				"000000000000" when((row=row_des_AI and col=col_des_AI) or (row=row_des_AI1 and col=col_des_AI1) or (row=row_des_AI2 and col=col_des_AI2))else
				life_rgb when (item_on = '1' and (row = row_item_check and col = col_item_check) and item_type = 0) else
				star_rgb   when (item_on = '1' and (row = row_item_check and col = col_item_check) and item_type = 1) else
				fz_rgb   when (item_on = '1' and (row = row_item_check and col = col_item_check) and item_type = 2) else
				AI_rgb;
end behavior;	
	
	
	