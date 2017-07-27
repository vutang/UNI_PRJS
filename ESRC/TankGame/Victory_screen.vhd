library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity victory_screen is
	port (
		in_rgb                	: in std_logic_vector(11 downto 0);
		maps_on         	    : out std_logic;
		maps_rgb        	    : out std_logic_vector (11 downto 0);
		col             	    : in integer range 0 to 31;
		row             	    : in integer range 0 to 23;
		pixel_x,pixel_y 	    : in std_logic_vector (9 downto 0);
		clk			  		    : in std_logic;
		reset   	    		: in std_logic;
		btnp1                   : in std_logic_vector (5 downto 0);
		btnp2                   : in std_logic_vector (5 downto 0);
		winer                   : in std_logic
	);
end victory_screen;

architecture behavior of victory_screen is

signal address: std_logic_vector(8 downto 0);
signal iron_rgb: std_logic_vector(11 downto 0);
signal character_adr 		: std_logic_vector(7 downto 0);
signal font_row, font_col	: std_logic_vector(2 downto 0);
signal char_out, char_on,maps_on_buf	: std_logic;
signal s_winer				: std_logic_vector(7 downto 0);
--type maps_type is array (1 to 22,1 to 23) of integer range 0 to 5;
--signal maps_1: maps_type;
-- constant maps_1 : maps_type := 
	-- (
		-- (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
		-- (0,0,2,2,2,2,2,0,0,0,0,0,0,0,0,2,2,0,0,0,2,2,2),
		-- (0,0,2,2,2,2,2,0,0,2,2,2,2,2,0,2,2,0,0,0,2,2,2),
		-- (3,0,0,0,0,2,2,0,0,2,2,2,2,2,0,2,2,0,3,0,0,2,2),
		-- (3,0,1,1,0,2,2,0,0,5,5,5,5,5,5,5,5,5,5,5,0,0,0),
		-- (3,0,0,0,0,2,2,0,5,5,0,0,0,0,0,0,0,0,0,5,5,0,0),
		-- (3,3,3,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,5,3,3),
		-- (0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,5,0,0),
		-- (0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0,5,5,0,0),
		-- (2,2,0,0,0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,5,0,2,2),
		-- (2,2,2,2,2,2,0,0,0,3,3,3,3,3,0,2,0,0,0,0,0,0,0),
		-- (2,2,2,2,0,0,0,0,0,3,3,3,3,3,0,2,0,2,2,2,2,2,2),
		-- (0,0,2,2,2,2,0,0,0,0,0,3,0,0,0,2,0,0,0,0,2,0,0),
		-- (0,0,2,0,0,0,0,0,0,0,0,3,0,0,0,2,0,0,0,0,2,0,0),
		-- (0,0,2,0,0,0,0,0,0,3,3,3,3,3,0,2,0,2,2,2,2,2,2),
		-- (0,0,2,0,0,2,0,0,0,3,3,3,3,3,0,2,0,0,2,0,0,0,0),
		-- (0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0),
		-- (3,3,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0),
		-- (0,0,2,2,0,2,0,0,2,2,2,2,2,2,0,0,0,0,2,0,0,0,0),
		-- (0,0,2,2,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0),
		-- (0,0,2,2,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0),
		-- (0,0,2,2,0,0,0,4,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0)
                                                    
	-- );
begin
	-- brick: entity work.brick_rom
	-- port map (
		-- address,clk,brick_rgb
	-- );
	-- grass: entity work.grass_rom
	-- port map (
		-- address,clk,grass_rgb
	-- );
	-- stone: entity work.stone_rom
	-- port map (
		-- address,clk,stone_rgb
	-- );
	iron: entity work.iron_rom
	port map (
		address,clk,iron_rgb
	);
	-- tank_up: entity work.tank_up_rom
	-- port map (
		-- address,clk,tank_up_rgb
	-- );
	-- water: entity work.water_rom
	-- port map (
		-- address,clk,water_rgb
	-- );
	char: entity work.char_rom
	port map (
		character_adr, font_row, font_col, char_out
	);
	
	-- character_adr <= 	"01000111" when  	(pixel_x >= "0011100000" and pixel_x < "0011110000") 
											-- and (pixel_y(9 downto 5) >= "00101") else-- G
						-- "01000001" when  	(pixel_x >= "0011110000" and pixel_x < "0100000000") 
											-- and (pixel_y(9 downto 5) >= "00101") else-- A
						-- "01001101" when  	(pixel_x >= "0100000000" and pixel_x < "0100010000") 
											-- and (pixel_y(9 downto 5) >= "00101") else-- M
						-- "01000101" when  	(pixel_x >= "0100010000" and pixel_x < "0100100000") 
											-- and (pixel_y(9 downto 5) >= "00101") else-- E
						-- "00000000" when  	(pixel_x >= "0100100000" and pixel_x < "0100110000") 
											-- and (pixel_y(9 downto 5) >= "00101") else--
						-- "01001111" when  	(pixel_x >= "0100110000" and pixel_x < "0101000000") 
											-- and (pixel_y(9 downto 5) >= "00101") else-- O
						-- "01010110" when  	(pixel_x >= "0101000000" and pixel_x < "0101010000") 
											-- and (pixel_y(9 downto 5) >= "00101") else-- V
						-- "01000101" when  	(pixel_x >= "0101010000" and pixel_x < "0101100000") 
											-- and (pixel_y(9 downto 5) >= "00101") else-- E
						-- "01010010" when  	(pixel_x >= "0101100000" and pixel_x < "0101110000") 
											-- and (pixel_y(9 downto 5) >= "00101") else-- R
						-- "00100001" when  	(pixel_x >= "0101110000" and pixel_x < "0110000000") 
											-- and (pixel_y(9 downto 5) >= "00101") else-- !
						-- "00100001" when  	(pixel_x >= "0110000000" and pixel_x < "0110010000") 
											-- and (pixel_y(9 downto 5) >= "00101") else-- !
						-- "00000000";
	process(winer)
	begin
		if(winer = '0') then s_winer <= "00110001";
		else                 s_winer <= "00110010";
		end if;
	end process;
	
	character_adr <= 	
						--"00000000" when  	(pixel_x(9 downto 4) = "001110") 
											--and (pixel_y(9 downto 4) = "001001") else-- 
						"01010110" when  	(pixel_x(9 downto 4) = "001111") 
										and (pixel_y(9 downto 4) = "001001") else-- V
						"01001001" when  	(pixel_x(9 downto 4) = "010000") 
										and (pixel_y(9 downto 4) = "001001") else-- I
						"01000011" when  	(pixel_x(9 downto 4) = "010001") 
										and (pixel_y(9 downto 4) = "001001") else-- C
						"01010100" when  	(pixel_x(9 downto 4) = "010010") 
										and (pixel_y(9 downto 4) = "001001") else-- T
						"01001111" when  	(pixel_x(9 downto 4) = "010011") 
										and (pixel_y(9 downto 4) = "001001") else-- O
						"01010010" when  	(pixel_x(9 downto 4) = "010100") 
										and (pixel_y(9 downto 4) = "001001") else-- R
						"01011001" when  	(pixel_x(9 downto 4) = "010101") 
											and (pixel_y(9 downto 4) = "001001") else-- Y
						"00100001" when  	(pixel_x(9 downto 4) = "010110") 
											and (pixel_y(9 downto 4) = "001001") else-- !
						"00100001" when  	(pixel_x(9 downto 4) = "010111") 
											and (pixel_y(9 downto 4) = "001001") else-- !
						--"00100001" when  	(pixel_x(9 downto 4) = "011000") 
											--and (pixel_y(9 downto 4) = "001001") else-- 
						
						
						--"00000000" when  	(pixel_x(9 downto 4) = "001110") 
											--and (pixel_y(9 downto 4) = "001001") else-- 
						"01010000" when  	(pixel_x(9 downto 4) = "001111") 
											and (pixel_y(9 downto 4) = "001010") else-- P
						"01001100" when  	(pixel_x(9 downto 4) = "010000") 
											and (pixel_y(9 downto 4) = "001010") else-- L
						"01000001" when  	(pixel_x(9 downto 4) = "010001") 
											and (pixel_y(9 downto 4) = "001010") else-- A
						"01011001" when  	(pixel_x(9 downto 4) = "010010") 
											and (pixel_y(9 downto 4) = "001010") else-- Y
						"01000101" when  	(pixel_x(9 downto 4) = "010011") 
											and (pixel_y(9 downto 4) = "001010") else-- E
						"01010010" when  	(pixel_x(9 downto 4) = "010100") 
											and (pixel_y(9 downto 4) = "001010") else-- R
						s_winer	   when  	(pixel_x(9 downto 4) = "010101") 
											and (pixel_y(9 downto 4) = "001010") else-- ?
						"00100001" when  	(pixel_x(9 downto 4) = "010110") 
											and (pixel_y(9 downto 4) = "001010") else-- !
						"00100001" when  	(pixel_x(9 downto 4) = "010111") 
											and (pixel_y(9 downto 4) = "001010") else-- !
						--"00100001" when  	(pixel_x(9 downto 4) = "011000") 
											--and (pixel_y(9 downto 4) = "001001") else-- 
						
						"00000000";
	char_on <= 		'1' when (pixel_x(9 downto 4) >= "001110" and "011000" >= pixel_x(9 downto 4)) 
								and (pixel_y(9 downto 4)= "001001" or pixel_y (9 downto 4) = "001010") else 
					'0';
					
	font_col <= pixel_x(3 downto 1);
	font_row <= pixel_y(3 downto 1);
	address <= std_logic_vector(to_unsigned((to_integer(unsigned(pixel_y)) - row*20)*20 + (to_integer(unsigned(pixel_x)) - col*20),9));
	maps_on_buf <= '1' when (
							(row = 0 or row = 23 or col = 0 or col =31 or col = 24) or
							((col >=9 and col <= 21) and (row = 10 or row = 5 )) or
							((row < 10 and row > 5 ) and (col =9 or col = 21)) or
							(char_on = '1' and char_out='1')
							) else '0';
	maps_on <= maps_on_buf;
	maps_rgb <= iron_rgb when maps_on_buf = '1' else
				"000000000000" when (row < 10 and row > 5) and (col < 21 and col > 9) else
				-- water_rgb when maps_1(row,col) = 1 else
			   -- brick_rgb when maps_1(row,col) = 2 else
			   -- stone_rgb when maps_1(row,col) = 3 else
			   --grass_rgb when maps_1(row,col) = 5 else
			   --tank_up_rgb when maps_1(row,col) = 4 else
				in_rgb;
end behavior;	
	
	
	
	
	
	
	
	