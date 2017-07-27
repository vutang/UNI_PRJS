library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity intro_screen is
port
	(
		clk, reset					:	in	std_logic;
		video_on					:	in	std_logic;
		p_x, p_y					: 	in	std_logic_vector(9 downto 0);				
		col             			: 	in 	integer range 0 to 31;
		row             			: 	in 	integer range 0 to 23;
		intro_screen_rgb			:	out	std_logic_vector(11 downto 0)
		);
end intro_screen;

architecture structural of intro_screen is
	-- type map_type is array (0 to 23, 0 to 31) of unsigned(1 downto 0);
	-- constant intro_map	: map_type :=
			
		-- (	("01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01"),
			-- ("01","01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01","01"),
			-- ("01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01"),
			-- ("01","01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","10","00","00","00","00","00","00","01"),--8
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","11","00","00","00","00","00","00","01"),--11
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01"),
			-- ("01","01","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","01","01"),
			-- ("01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01","01")	);
			
	signal 		address						:	std_logic_vector(8 downto 0);
	signal 		font_row, font_col			: 	std_logic_vector(2 downto 0);
	signal 		font_row1, font_col1			: 	std_logic_vector(2 downto 0);
	signal 		font_row2, font_col2			: 	std_logic_vector(2 downto 0);
	signal 		font_row3, font_col3			: 	std_logic_vector(2 downto 0);
	signal 		char_out, char1_on, char2_on, char3_on			: 	std_logic;
	signal 		brick_rgb, grass_rgb, stone_rgb, tank_left_rgb				: std_logic_vector(11 downto 0);
	signal		character_adr, character_adr1, character_adr2, character_adr3: std_logic_vector(7 downto 0);
	signal		s1							: unsigned(1 downto 0);
		
begin
	brick_rom_unit: entity work.brick_rom
		port map
		(address, clk, brick_rgb);
		
	--grass_rom_unit: entity work.tank_left_rom
		--port map
		--(address, clk, tank_left_rgb);
		
		
	char_ROM_unit: entity work.char_rom
		port map
		(character_adr, font_row, font_col, char_out);	
		
	address <= std_logic_vector(to_unsigned((to_integer(unsigned(p_y)) - row*20)*20 + (to_integer(unsigned(p_x)) - col*20),9));	
	--address <= (((p_y) - row*20)*20 + ((p_x) - col*20),9);	
	character_adr1 <= 	"01010100" when p_x(9 downto 5)= "00101" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= "0101100" and p_y(6 downto 0)<"1001101" ) else--T
						"01000001" when p_x(9 downto 5)= "00110" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= "0101100" and p_y(6 downto 0)<"1001101" ) else--A
						"01001110" when p_x(9 downto 5)= "00111" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= "0101100" and p_y(6 downto 0)<"1001101" ) else--N
						"01001011" when p_x(9 downto 5)= "01000" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= "0101100" and p_y(6 downto 0)<"1001101" ) else--K
						"00000000" when p_x(9 downto 5)= "01001" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= "0101100" and p_y(6 downto 0)<"1001101" ) else-- 
						"01000111" when p_x(9 downto 5)= "01010" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= "0101100" and p_y(6 downto 0)<"1001101" ) else--G
						"01000001" when p_x(9 downto 5)= "01011" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= "0101100" and p_y(6 downto 0)<"1001101" ) else--A
						"01001101" when p_x(9 downto 5)= "01100" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= "0101100" and p_y(6 downto 0)<"1001101" ) else--M
						"01000101" when p_x(9 downto 5)= "01101" and p_y(9 downto 7)= "000" and (p_y(6 downto 0)>= "0101100" and p_y(6 downto 0)<"1001101" ) else--E
						"00000000";
	font_col1 <= 	p_x(4 downto 2);
	font_row1 <= 	"000"	when (p_y(6 downto 0) >= "0101100" and p_y(6 downto 0)< "0110000") else
					"001"   when (p_y(6 downto 0) >= "0110000" and p_y(6 downto 0)< "0110100") else
					"010"	when (p_y(6 downto 0) >= "0110100" and p_y(6 downto 0)< "0111000") else
					"011"	when (p_y(6 downto 0) >= "0111000" and p_y(6 downto 0)< "0111100") else
					"100"	when (p_y(6 downto 0) >= "0111100" and p_y(6 downto 0)< "1000000") else
					"101"	when (p_y(6 downto 0) >= "1000000" and p_y(6 downto 0)< "1000100") else
					"110"	when (p_y(6 downto 0) >= "1000100" and p_y(6 downto 0)< "1001000") else
					"111"	when (p_y(6 downto 0) >= "1001000" and p_y(6 downto 0)< "1001100") else
					"---";	
	char1_on <= '1' when (p_x(9 downto 5)>= "00101" and p_x(9 downto 5)< "01110") and(p_y(9 downto 7)= "000" 
						 and (p_y(6 downto 0)>= "0101100" and p_y(6 downto 0)<"1001101" )) else 
					'0';
				
	
	character_adr2 <= 	
						"01001011" when (p_x(9 downto 4) = "001111")
								and (p_y(9 downto 4)>= "001010")  else--k
						"01010011" when (p_x(9 downto 4) = "010000") 
								and (p_y(9 downto 4)>= "001010")  else--s
						"01010100" when (p_x(9 downto 4) = "010001")
								and (p_y(9 downto 4)>= "001010")  else--t
						"01001110" when (p_x(9 downto 4) = "010010") 
								and (p_y(9 downto 4)>= "001010")  else--n
						"00000000" when (p_x(9 downto 4) = "010011") 
								and (p_y(9 downto 4)>= "001010")  else--
						"01010100" when (p_x(9 downto 4) = "010100") 
								and (p_y(9 downto 4)>= "001010")  else--t
						"01000101" when (p_x(9 downto 4) = "010101")
								and (p_y(9 downto 4)>= "001010")  else--e
						"01000001" when (p_x(9 downto 4) = "010110") 
								and (p_y(9 downto 4)>= "001010")  else--a
						"01001101" when (p_x(9 downto 4) = "010111") 
								and (p_y(9 downto 4)>= "001010")  else--m
						"00000000";
	font_col2 <= p_x(3 downto 1);
	font_row2 <= p_y(3 downto 1);
	char2_on <= '1' when (p_x(9 downto 4)>= "001111" and p_x(9 downto 4)<= "010111") 
						and(p_y(9 downto 4)= "001010") else 
				'0';
	
						
	character_adr3 <= 		
						--"00000000" when (p_x(9 downto 4) = "001111")
								--and (p_y(9 downto 4)= "001111") else--
						"01010011" when (p_x(9 downto 4) = "010001")
								and (p_y(9 downto 4)= "001111") else--s
						"01010100" when (p_x(9 downto 4) = "010010")  
								and (p_y(9 downto 4)= "001111") else--t
						"01000001" when (p_x(9 downto 4) = "010011") 
								and (p_y(9 downto 4)= "001111") else--a
						"01010010" when (p_x(9 downto 4) = "010100")
								and (p_y(9 downto 4)= "001111") else--r
						"01010100" when (p_x(9 downto 4) = "010101") 
								and (p_y(9 downto 4)= "001111") else--t
						--"00000000" when (p_x(9 downto 4) = "010101")  
								--and (p_y(9 downto 4)= "001111") else--
						--"00000000" when (p_x(9 downto 4) = "010110")
								--and (p_y(9 downto 4)= "001111") else--
						
						
						"01010000" when (p_x(9 downto 4) = "001110")
								and (p_y(9 downto 4)= "010010") else--p
						"01010010" when (p_x(9 downto 4) = "001111")
								and (p_y(9 downto 4)= "010010") else--r
						"01000101" when (p_x(9 downto 4) = "010000")  
								and (p_y(9 downto 4)= "010010") else--e
						"01010011" when (p_x(9 downto 4) = "010001") 
								and (p_y(9 downto 4)= "010010") else--s
						"01010011" when (p_x(9 downto 4) = "010010")
								and (p_y(9 downto 4)= "010010") else--s
						"00000000" when (p_x(9 downto 4) = "010011") 
								and (p_y(9 downto 4)= "010010") else--
						"01000101" when (p_x(9 downto 4) = "010100")  
								and (p_y(9 downto 4)= "010010") else--e
						"01001110" when (p_x(9 downto 4) = "010101")
								and (p_y(9 downto 4)= "010010") else--n
						"01010100" when (p_x(9 downto 4) = "010110") 
								and (p_y(9 downto 4)= "010010") else--t
						"01000101" when (p_x(9 downto 4) = "010111")  
								and (p_y(9 downto 4)= "010010") else--e
						"01010010" when (p_x(9 downto 4) = "011000")
								and (p_y(9 downto 4)= "010010") else--r
						"00000000";
	font_col3 <= p_x(3 downto 1);
	font_row3 <= p_y(3 downto 1);
	char3_on <= '1' when (p_x(9 downto 4)>= "001101" and p_x(9 downto 4)<= "011000") 
						and (p_y(9 downto 4)= "001111" or p_y(9 downto 4)= "010010") else
				'0';
				
	
	
	process(char1_on, char2_on, char3_on)
		begin
		if(char1_on = '1') then
			font_row <= font_row1; font_col <= font_col1;
			character_adr <= character_adr1;
		elsif(char2_on = '1') then
			font_row <= font_row2; font_col <= font_col2;
			character_adr <= character_adr2;
		elsif(char3_on = '1') then 
			font_row <= font_row3; font_col <= font_col3;
			character_adr <= character_adr3;
		end if;
	end process;
	
	intro_screen_rgb <= 	brick_rgb when (col = 0 or col = 31) 
							or (row = 0 or row = 5 or row = 23) 
							or(col = 1 and (row = 1 or row = 4 or row = 6 or row = 22))
							or(col = 30 and (row = 1 or row = 4 or row = 6 or row = 22))
							or (video_on = '1' and (char1_on = '1' or char2_on ='1' or char3_on = '1') and char_out = '1') else
							"000000000000";	
end structural;
		
