library  ieee; 
use ieee.std_logic_1164. all ; 
use ieee.std_logic_unsigned. all ; 
use ieee.std_logic_arith.all;
ENTITY start_screen IS
	PORT(
		clk					: in  std_logic;
		video_on: IN STD_LOGIC;
		p_x,p_y: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		col             			: 	in 	integer range 0 to 31;
		row             			: 	in 	integer range 0 to 23;
		start_screen_rgb: OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
		);
END start_screen;

architecture behavior of start_screen is 
type map_type is array (0 to 23, 0 to 31) of integer range 0 to 3;
	constant intro_map	: map_type :=
			
		(	(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
			(1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
			(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),
			(1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1),
			(1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
			(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)	);
			
	signal 		address						:	std_logic_vector(8 downto 0);
	signal 		font_row, font_col			: 	std_logic_vector(2 downto 0);
	signal 		font_row1, font_col1			: 	std_logic_vector(2 downto 0);
	signal 		font_row2, font_col2			: 	std_logic_vector(2 downto 0);
	signal 		font_row3, font_col3			: 	std_logic_vector(2 downto 0);
	signal 		char_out, char1_on, char2_on, char3_on, char4_on			: 	std_logic;
	signal 		brick_rgb, grass_rgb				: std_logic_vector(11 downto 0);
	signal		character_adr, character_adr1, character_adr2, character_adr3, character_adr4: std_logic_vector(7 downto 0);
begin
brick_rom_unit: entity work.brick_rom
		port map
		(address, clk, brick_rgb);
		
	grass_rom_unit: entity work.grass_rom
		port map
		(address, clk, grass_rgb);
		
	char_ROM_unit: entity work.char_rom
		port map
		(character_adr, font_row, font_col, char_out);	
		
	address <= conv_std_logic_vector((conv_integer(p_y) - row*20)*20 + (conv_integer(p_x) - col*20),9);	
	character_adr1 <= 	"01000101" when p_x(9 downto 5)= "00101" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= 44 and p_y(6 downto 0)<=76 ) else--E
						"01010011" when p_x(9 downto 5)= "00110" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= 44 and p_y(6 downto 0)<=76 ) else--S
						"01010010" when p_x(9 downto 5)= "00111" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= 44 and p_y(6 downto 0)<=76 ) else--R
						"01000011" when p_x(9 downto 5)= "01000" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= 44 and p_y(6 downto 0)<=76 ) else--C
						"00000000" when p_x(9 downto 5)= "01001" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= 44 and p_y(6 downto 0)<=76 ) else-- 
						"01001100" when p_x(9 downto 5)= "01010" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= 44 and p_y(6 downto 0)<=76 ) else--L
						"01000001" when p_x(9 downto 5)= "01011" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= 44 and p_y(6 downto 0)<=76 ) else--A
						"01000010" when p_x(9 downto 5)= "01100" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= 44 and p_y(6 downto 0)<=76 ) else--B
						"00000000" when p_x(9 downto 5)= "01101" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= 44 and p_y(6 downto 0)<=76 ) else--
						"00000000";
	font_col1 <= p_x(4 downto 2);
	font_row1 <= "000"	when (p_y(6 downto 0) >= 44 and p_y(6 downto 0)< 48) else
				"001"   when (p_y(6 downto 0) >= 48 and p_y(6 downto 0)< 52) else
				"010"	when (p_y(6 downto 0) >= 52 and p_y(6 downto 0)< 56) else
				"011"	when (p_y(6 downto 0) >= 56 and p_y(6 downto 0)< 60) else
				"100"	when (p_y(6 downto 0) >= 60 and p_y(6 downto 0)< 64) else
				"101"	when (p_y(6 downto 0) >= 64 and p_y(6 downto 0)< 68) else
				"110"	when (p_y(6 downto 0) >= 68 and p_y(6 downto 0)< 72) else
				"111"	when (p_y(6 downto 0) >= 72 and p_y(6 downto 0)< 76) else
				"---";	
	char1_on <= '1' when (p_x(9 downto 5)>= 5 and p_x(9 downto 5)<= 13) and(p_y(9 downto 7)= "000" 
					and (p_y(6 downto 0)>= 44 and p_y(6 downto 0)<=76 )) else 
				'0';
				
	character_adr2 <= 	
						"01000101" when (p_x(9 downto 4) = "001111")
								and (p_y(9 downto 4) = "001010")  else--E
						"01010011" when (p_x(9 downto 4) = "010000") 
								and (p_y(9 downto 4) = "001010")  else--S
						"01010010" when (p_x(9 downto 4) = "010001")
								and (p_y(9 downto 4) = "001010")  else--R
						"01000011" when (p_x(9 downto 4) = "010010") 
								and (p_y(9 downto 4) = "001010")  else--C
						"01001100" when (p_x(9 downto 4) = "010011") 
								and (p_y(9 downto 4) = "001010")  else--L
						"01000001" when (p_x(9 downto 4) = "010100") 
								and (p_y(9 downto 4) = "001010")  else--a
						"01000010" when (p_x(9 downto 4) = "010101")
								and (p_y(9 downto 4) = "001010")  else--b
						"00000000" when (p_x(9 downto 4) = "010110") 
								and (p_y(9 downto 4) = "001010")  else---
						"00000000" when (p_x(9 downto 4) = "010111")
								and (p_y(9 downto 4) = "001010")  else--H
						"00000000" when (p_x(9 downto 4) = "011000") 
								and (p_y(9 downto 4) = "001010")  else--U
						"00000000" when (p_x(9 downto 4) = "011001")
								and (p_y(9 downto 4) = "001010")  else--S
						"00000000" when (p_x(9 downto 4) = "011010") 
								and (p_y(9 downto 4) = "001010")  else--T
								
								
						"00000000" when (p_x(9 downto 4) = "01111")
								and (p_y(9 downto 4) = "001011")  else--T
						"00000000" when (p_x(9 downto 4) = "010000") 
								and (p_y(9 downto 4) = "001011")  else--a
						"00000000" when (p_x(9 downto 4) = "010001")
								and (p_y(9 downto 4) = "001011")  else--n
						"00000000" when (p_x(9 downto 4) = "010010") 
								and (p_y(9 downto 4) = "001011")  else--k
						"00000000" when (p_x(9 downto 4) = "010011") 
								and (p_y(9 downto 4) = "001011")  else-- 
						"00000000" when (p_x(9 downto 4) = "010100") 
								and (p_y(9 downto 4) = "001011")  else--G
						"00000000" when (p_x(9 downto 4) = "010101")
								and (p_y(9 downto 4) = "001011")  else--a
						"00000000" when (p_x(9 downto 4) = "010110") 
								and (p_y(9 downto 4) = "001011")  else--m
						"00000000" when (p_x(9 downto 4) = "010111")
								and (p_y(9 downto 4) = "001011")  else--e
						"00000000" when (p_x(9 downto 4) = "011000") 
								and (p_y(9 downto 4) = "001011")  else-- 
						"00000000" when (p_x(9 downto 4) = "011001")
								and (p_y(9 downto 4) = "001011")  else--o
						"00000000" when (p_x(9 downto 4) = "011010") 
								and (p_y(9 downto 4) = "001011")  else--n
						"00000000" when (p_x(9 downto 4) = "011011") 
								and (p_y(9 downto 4) = "001011")  else-- 
						"00000000" when (p_x(9 downto 4) = "011100")
								and (p_y(9 downto 4) = "001011")  else--F
						"00000000" when (p_x(9 downto 4) = "011101") 
								and (p_y(9 downto 4) = "001011")  else--P
						"00000000" when (p_x(9 downto 4) = "011110")
								and (p_y(9 downto 4) = "001011")  else--G
						"00000000" when (p_x(9 downto 4) = "011111")
								and (p_y(9 downto 4) = "001011")  else--A						
						"00000000";
	font_col2 <= p_x(3 downto 1);
	font_row2 <= p_y(3 downto 1);
	char2_on <= '1' when (p_x(9 downto 4)>= 15 and p_x(9 downto 4)<= 31) 
						and(p_y(9 downto 4) = "001010" or p_y(9 downto 0) = "001011") else 
				'0';
	process(char1_on, char2_on, char3_on)
		begin
		if(char1_on = '1') then
			font_row <= font_row1; font_col <= font_col1;
			character_adr <= character_adr1;
		elsif(char2_on = '1') then
			font_row <= font_row2; font_col <= font_col2;
			character_adr <= character_adr2;
		end if;
	end process;
	
	start_screen_rgb <= 	brick_rgb when intro_map(row, col) = 1 or (video_on = '1' and char1_on = '1' and char_out = '1')else 
							--grass_rgb when intro_map(row, col) = 2 and s1(0) = '1' else
							---grass_rgb when intro_map(row, col) = 3 and s1(1) = '1' else
							"111100000000" when (video_on = '1' and char2_on = '1' and char_out = '1')else
							"000000000000";

end  behavior; 
