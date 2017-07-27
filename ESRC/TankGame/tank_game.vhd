library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tank_game is
	port (
		clock_50          : in std_logic;
		PS2_DAT           : in std_logic;
		PS2_CLK           : in std_logic;
		key               : in std_logic_vector (1 downto 0);
		sw                : in std_logic_vector (8 downto 0);
		vga_hs,vga_vs     : out std_logic;
		LEDG              : out std_logic_vector(5 downto 0);
		LEDR              : out std_logic_vector(5 downto 0);
		vga_r,vga_g,vga_b : out std_logic_vector (3 downto 0);
		I2C_SDAT 		  : inout std_logic; -- I2C Data
		I2C_SCLK 		  : out std_logic;   -- I2C Clock
		-- Audio CODEC
		AUD_ADCLRCK 	  : inout std_logic;                      -- ADC LR Clock
		AUD_ADCDAT 		  : in std_logic;                          -- ADC Data
		AUD_DACLRCK 	  : inout std_logic;                      -- DAC LR Clock
		AUD_DACDAT 		  : out std_logic;                         -- DAC Data
		AUD_BCLK 		  : inout std_logic;                         -- Bit-Stream Clock
		AUD_XCK           : out std_logic                           -- Chip Clock
	);
end tank_game;

architecture behavior of tank_game is
	signal btn                : std_logic_vector (1 downto 0);	
	signal video_on           : std_logic;
	signal refr_tick, p_tick  : std_logic;
	signal pixel_x, pixel_y   : std_logic_vector (9 downto 0);
	signal vga_rgb            : std_logic_vector (11 downto 0);
	signal col                : integer range 0 to 31;
	signal row                : integer range 0 to 23;
--	signal maps_on   		 	  : std_logic;
	signal maps_rgb, rgb, intro_rgb, victory_rgb, gameover_rgb,start_rgb 		 : std_logic_vector (11 downto 0);
	signal btnp1, btnp2       : std_logic_vector (5 downto 0);
	signal vic, game_over, m_on, g_on, intro_on1, intro_on2, enter, escape     : std_logic;
	signal count: std_logic_vector(2 downto 0);

begin
	keyboard: entity work.ps2kb 
		port map (
			ps2c => PS2_CLK,
			ps2d => ps2_dat,
			clk => clock_50,
			btnp1 => btnp1,
			btnp2 => btnp2,
			b_enter => enter,
			b_esc => escape
		);
	vga_sync: entity work.vga_sync
		port map (
			clock_50,'0',vga_hs,vga_vs,video_on,p_tick,refr_tick,pixel_x,pixel_y,col,row
		);
	maps_com: entity work.maps
		port map (
			game_over,vic,open,maps_rgb,col,row,pixel_x,pixel_y,clock_50,escape,btnp1,btnp2,refr_tick,p_tick,
			I2C_SDAT, I2C_SCLK, AUD_ADCLRCK,  AUD_ADCDAT, AUD_DACLRCK, AUD_DACDAT, AUD_BCLK, AUD_XCK, count
		);
	main_fsm: entity work.main_fsm
		port map (
			clk25 => clock_50,
			reset => escape,
			vic   => vic,
			game_over => game_over,
			enter => enter,
			--intro_on1 => intro_on1,
			--intro_on2 => intro_on2,
			intro_rgb => intro_rgb,
			gameover_rgb => gameover_rgb,
			maps_rgb  => maps_rgb,
			victory_rgb => victory_rgb,
			rgb      =>  rgb
			);
	start: entity work.start_screen
		port map (
			clock_50,video_on,pixel_x,pixel_y,col,row,start_rgb
			);
	intro: entity work.intro_screen
		port map (
			clock_50,'0',video_on,pixel_x,pixel_y,col,row,intro_rgb
			);
	victory: entity work.victory_screen
		port map (
			in_rgb => maps_rgb,
			maps_on => open,
			maps_rgb => victory_rgb,
			col => col,
			row => row,
			pixel_x => pixel_x,
			pixel_y => pixel_y,
			clk => clock_50,
			reset => '0',
			btnp1 => btnp1,
			btnp2 => btnp2,
			winer => vic
			);
	gameover: entity work.gameover_screen
		port map (
			in_rgb => maps_rgb,
			maps_on => open,
			maps_rgb => gameover_rgb,
			col => col,
			row => row,
			pixel_x => pixel_x,
			pixel_y => pixel_y,
			clk => clock_50,
			reset => '0',
			btnp1 => btnp1,
			btnp2 => btnp2
			);
	counter: entity work.counter
		port map (
			clk => clock_50,
			enter => enter,
			count => count
			);
	
			
	vga_rgb <= rgb;	
	ledr    <= btnp1;
	ledg    <= btnp2;
	process (clock_50)
	begin
	if (clock_50'event and clock_50 = '1') then
		if (video_on = '1') then
			vga_r<= vga_rgb(11 downto 8) ;
			vga_g<= vga_rgb(7 downto 4) ;
			vga_b<= vga_rgb(3 downto 0) ;
		else 
			vga_r<= "0000" ;
			vga_g<= "0000" ;
			vga_b<= "0000" ;
		end if;
	end if;
	end process;
end behavior;