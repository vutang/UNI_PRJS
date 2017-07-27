library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity char_value is
port
(
		char_out						:	out std_logic;
		char_on							:	out	std_logic;
		p_x, p_y						:	in 	std_logic_vector(9 downto 0);
		score1_1, score1_2, score1_3	:	in	integer range 0 to 9;
		score2_1, score2_2, score2_3  	:   in  integer range 0 to 9;
		ai_dv_t1, ai_chuc_t1, ai_dv_t2, ai_chuc_t2: in integer range 0 to 9;
		p_tick							: 	in 	std_logic;
		rst								:	in	std_logic
);
end char_value;

architecture behavior of char_value is

-- Text Signal
signal character_adr, character_adr1, character_adr2, character_adr3, character_adr4:	std_logic_vector(7 downto 0);
signal font_row, font_col							:	std_logic_vector(2 downto 0);
signal font_row1, font_row2, font_row3, font_row4	: std_logic_vector(2 downto 0);
signal font_col1, font_col2, font_col3, font_col4	: std_logic_vector(2 downto 0);
signal char1_on										:	std_logic;--_vector(2 downto 0);
signal char2_on, char3_on, char4_on					: std_logic;--_vector(2 downto 0);
signal digit_sec1, digit_sec2, digit_min1, digit_min2	:	std_logic_vector(7 downto 0);
signal s_sec1, s_sec2, s_min1, s_min2					: unsigned(3 downto 0) := "0000";
signal score1_1_digit, score1_2_digit, score1_3_digit	:	std_logic_vector(7 downto 0);
signal score2_1_digit, score2_2_digit, score2_3_digit	:	std_logic_vector(7 downto 0);
signal ai_dv_t1_d, ai_dv_t2_d, ai_c_t1_d, ai_c_t2_d		:   std_logic_vector(7 downto 0);

begin
	char_rom: entity work.char_rom
	port map 
	( character_adr, font_row, font_col, char_out);	
	
	Process(p_tick, rst)
	variable		count		: integer range 0 to 25000000 := 0;
	begin
		if rising_edge(p_tick) then 
		count := count +1;
		if count > 25000000 then s_sec1 <= s_sec1 + "0001"; count := 0;end if;
		if s_sec1 >"1001" then s_sec1 <= "0000" ; s_sec2 <= s_sec2 +"0001"; end if;
		if s_sec2 >"0101" then s_sec2 <= "0000" ; s_min1 <= s_min1 +"0001"; end if;
		if s_min1 >"1001" then s_min1 <= "0000" ; s_min2 <= s_min2 +"0001"; end if;
		if s_min2 >"1001" then s_min2 <= "0000"; end if;
		end if;
		if (rst ='1') then
			s_sec1 <= "0000";
			s_sec2 <= "0000";
			s_min1 <= "0000";
			s_min2 <= "0000"; 
		end if;
	end process;
	
	digit_sec1 <= 	"00110000"	when s_sec1 = "0000" else	
					"00110001"	when s_sec1 = "0001" else
					"00110010"	when s_sec1 = "0010" else
					"00110011"	when s_sec1 = "0011" else
					"00110100"	when s_sec1 = "0100" else
					"00110101"	when s_sec1 = "0101" else
					"00110110"	when s_sec1 = "0110" else
					"00110111"	when s_sec1 = "0111" else
					"00111000"	when s_sec1 = "1000" else
					"00111001"	when s_sec1 = "1001" else
					"00000000";
	digit_sec2 <= 	"00110000"	when s_sec2 = "0000" else	
					"00110001"	when s_sec2 = "0001" else
					"00110010"	when s_sec2 = "0010" else
					"00110011"	when s_sec2 = "0011" else
					"00110100"	when s_sec2 = "0100" else
					"00110101"	when s_sec2 = "0101" else
					"00110110"	when s_sec2 = "0110" else
					"00110111"	when s_sec2 = "0111" else
					"00111000"	when s_sec2 = "1000" else
					"00111001"	when s_sec2 = "1001" else
					"00000000";
	digit_min1 <= 	"00110000"	when s_min1 = "0000" else	
					"00110001"	when s_min1 = "0001" else
					"00110010"	when s_min1 = "0010" else
					"00110011"	when s_min1 = "0011" else
					"00110100"	when s_min1 = "0100" else
					"00110101"	when s_min1 = "0101" else
					"00110110"	when s_min1 = "0110" else
					"00110111"	when s_min1 = "0111" else
					"00111000"	when s_min1 = "1000" else
					"00111001"	when s_min1 = "1001" else
					"00000000";
	digit_min2<= 	"00110000"	when s_min2 = "0000" else	
					"00110001"	when s_min2 = "0001" else
					"00110010"	when s_min2 = "0010" else
					"00110011"	when s_min2 = "0011" else
					"00110100"	when s_min2 = "0100" else
					"00110101"	when s_min2 = "0101" else
					"00110110"	when s_min2 = "0110" else
					"00110111"	when s_min2 = "0111" else
					"00111000"	when s_min2 = "1000" else
					"00111001"	when s_min2 = "1001" else
					"00000000";
			
	ai_dv_t1_d <= 	"00110000"	when ai_dv_t1 = 0 else	
					"00110001"	when ai_dv_t1 = 1 else
					"00110010"	when ai_dv_t1 = 2 else
					"00110011"	when ai_dv_t1 = 3 else
					"00110100"	when ai_dv_t1 = 4 else
					"00110101"	when ai_dv_t1 = 5 else
					"00110110"	when ai_dv_t1 = 6 else
					"00110111"	when ai_dv_t1 = 7 else
					"00111000"	when ai_dv_t1 = 8 else
					"00111001"	when ai_dv_t1 = 9 else
					"00000000";
	ai_c_t1_d <= 	"00110000"	when ai_chuc_t1 = 0 else	
					"00110001"	when ai_chuc_t1 = 1 else
					"00110010"	when ai_chuc_t1 = 2 else
					"00110011"	when ai_chuc_t1 = 3 else
					"00110100"	when ai_chuc_t1 = 4 else
					"00110101"	when ai_chuc_t1 = 5 else
					"00110110"	when ai_chuc_t1 = 6 else
					"00110111"	when ai_chuc_t1 = 7 else
					"00111000"	when ai_chuc_t1 = 8 else
					"00111001"	when ai_chuc_t1 = 9 else
					"00000000";
	ai_dv_t2_d <= 	"00110000"	when ai_dv_t2 = 0 else	
					"00110001"	when ai_dv_t2 = 1 else
					"00110010"	when ai_dv_t2 = 2 else
					"00110011"	when ai_dv_t2 = 3 else
					"00110100"	when ai_dv_t2 = 4 else
					"00110101"	when ai_dv_t2 = 5 else
					"00110110"	when ai_dv_t2 = 6 else
					"00110111"	when ai_dv_t2 = 7 else
					"00111000"	when ai_dv_t2 = 8 else
					"00111001"	when ai_dv_t2 = 9 else
					"00000000";
	ai_c_t2_d<= 	"00110000"	when ai_chuc_t2 = 0 else	
					"00110001"	when ai_chuc_t2 = 1 else
					"00110010"	when ai_chuc_t2 = 2 else
					"00110011"	when ai_chuc_t2 = 3 else
					"00110100"	when ai_chuc_t2 = 4 else
					"00110101"	when ai_chuc_t2 = 5 else
					"00110110"	when ai_chuc_t2 = 6 else
					"00110111"	when ai_chuc_t2 = 7 else
					"00111000"	when ai_chuc_t2 = 8 else
					"00111001"	when ai_chuc_t2 = 9 else
					"00000000";		
	score1_1_digit <= 	"00110000"	when score1_1 = 0 else	
						"00110001"	when score1_1 = 1 else
						"00110010"	when score1_1 = 2 else
						"00110011"	when score1_1 = 3 else
						"00110100"	when score1_1 = 4 else
						"00110101"	when score1_1 = 5 else
						"00110110"	when score1_1 = 6 else
						"00110111"	when score1_1 = 7 else
						"00111000"	when score1_1 = 8 else
						"00111001"	when score1_1 = 9 else
						"00000000";
	score1_2_digit <= 	"00110000"	when score1_2 = 0 else	
						"00110001"	when score1_2 = 1 else
						"00110010"	when score1_2 = 2 else
						"00110011"	when score1_2 = 3 else
						"00110100"	when score1_2 = 4 else
						"00110101"	when score1_2 = 5 else
						"00110110"	when score1_2 = 6 else
						"00110111"	when score1_2 = 7 else
						"00111000"	when score1_2 = 8 else
						"00111001"	when score1_2 = 9 else
						"00000000";
	score1_3_digit<= 	"00110000"	when score1_3 = 0 else	
						"00110001"	when score1_3 = 1 else
						"00110010"	when score1_3 = 2 else
						"00110011"	when score1_3 = 3 else
						"00110100"	when score1_3 = 4 else
						"00110101"	when score1_3 = 5 else
						"00110110"	when score1_3 = 6 else
						"00110111"	when score1_3 = 7 else
						"00111000"	when score1_3 = 8 else
						"00111001"	when score1_3 = 9 else
						"00000000";
					
					
	score2_1_digit <= 	"00110000"	when score2_1 = 0 else	
						"00110001"	when score2_1 = 1 else
						"00110010"	when score2_1 = 2 else
						"00110011"	when score2_1 = 3 else
						"00110100"	when score2_1 = 4 else
						"00110101"	when score2_1 = 5 else
						"00110110"	when score2_1 = 6 else
						"00110111"	when score2_1 = 7 else
						"00111000"	when score2_1 = 8 else
						"00111001"	when score2_1 = 9 else
						"00000000";
	score2_2_digit <= 	"00110000"	when score2_2 = 0 else	
						"00110001"	when score2_2 = 1 else
						"00110010"	when score2_2 = 2 else
						"00110011"	when score2_2 = 3 else
						"00110100"	when score2_2 = 4 else
						"00110101"	when score2_2 = 5 else
						"00110110"	when score2_2 = 6 else
						"00110111"	when score2_2 = 7 else
						"00111000"	when score2_2 = 8 else
						"00111001"	when score2_2 = 9 else
						"00000000";
	score2_3_digit<= 	"00110000"	when score2_3 = 0 else	
						"00110001"	when score2_3 = 1 else
						"00110010"	when score2_3 = 2 else
						"00110011"	when score2_3 = 3 else
						"00110100"	when score2_3 = 4 else
						"00110101"	when score2_3 = 5 else
						"00110110"	when score2_3 = 6 else
						"00110111"	when score2_3 = 7 else
						"00111000"	when score2_3 = 8 else
						"00111001"	when score2_3 = 9 else
						"00000000";
					
	character_adr1 <=	"01010000" when (p_x(9 downto 3) = "1000001")  -- P
									and (p_y(9 downto 3) = "0000110") else  
						"01001100" when (p_x(9 downto 3) = "1000010")  -- L
									and (p_y(9 downto 3) = "0000110") else  
						"01000001" when (p_x(9 downto 3) = "1000011")  -- A
									and (p_y(9 downto 3) = "0000110") else  
						"01011001" when (p_x(9 downto 3) = "1000100")  -- Y
									and (p_y(9 downto 3) = "0000110") else  
						"01000101" when (p_x(9 downto 3) = "1000101")  -- E
									and (p_y(9 downto 3) = "0000110") else  
						"01010010" when (p_x(9 downto 3) = "1000110")  -- R
									and (p_y(9 downto 3) = "0000110") else  
						"00110001" when (p_x(9 downto 3) = "1000111")  -- 1						
									and (p_y(9 downto 3) = "0000110") else	
						"01010011" when (p_x(9 downto 3) = "1000001") 
									and (p_y(9 downto 3) = "0001000") else --S
						"01100011" when (p_x(9 downto 3) = "1000010") 
									and (p_y(9 downto 3) = "0001000") else --c
						"01101111" when (p_x(9 downto 3) = "1000011") 
									and (p_y(9 downto 3) = "0001000") else --o
						"01110010" when (p_x(9 downto 3) = "1000100") 
									and (p_y(9 downto 3) = "0001000") else --r
						"01100101" when (p_x(9 downto 3) = "1000101") 
									and (p_y(9 downto 3) = "0001000") else --e
						"00111010" when (p_x(9 downto 3) = "1000110") 
									and (p_y(9 downto 3) = "0001000") else --:
						score1_1_digit 	   when (p_x(9 downto 3) = "1000111") 
									and (p_y(9 downto 3) = "0001000") else --digit 1
						score1_2_digit	   when (p_x(9 downto 3) = "1001000") 
									and (p_y(9 downto 3) = "0001000") else --digit 2
						score1_3_digit	   when (p_x(9 downto 3) = "1001001") 
									and (p_y(9 downto 3) = "0001000") else --digit 3
						"00000000";
	font_row1 <= p_y(2 downto 0);
	font_col1 <= p_x(2 downto 0);
	char1_on <= '1' when (p_x(9 downto 3)>="1000001"  and p_x(9 downto 3) < "1001010") 
						and (p_y(9 downto 3)= "0000110" or p_y(9 downto 3) = "0001000" ) else
					'0';
	
	character_adr2 <=	"01010000" when (p_x(9 downto 3) = "1000001")  -- P
									and (p_y(9 downto 3) = "0011110") else  
						"01001100" when (p_x(9 downto 3) = "1000010")  -- L
									and (p_y(9 downto 3) = "0011110") else  
						"01000001" when (p_x(9 downto 3) = "1000011")  -- A
									and (p_y(9 downto 3) = "0011110") else  
						"01011001" when (p_x(9 downto 3) = "1000100")  -- Y
									and (p_y(9 downto 3) = "0011110") else  
						"01000101" when (p_x(9 downto 3) = "1000101")  -- E
									and (p_y(9 downto 3) = "0011110") else  
						"01010010" when (p_x(9 downto 3) = "1000110")  -- R
									and (p_y(9 downto 3) = "0011110") else  
						"00110010" when (p_x(9 downto 3) = "1000111")  -- 2						
									and (p_y(9 downto 3) = "0011110") else	
						"01010011" when (p_x(9 downto 3) = "1000001") 
									and (p_y(9 downto 3) = "0100000") else --S
						"01100011" when (p_x(9 downto 3) = "1000010") 
									and (p_y(9 downto 3) = "0100000") else --c
						"01101111" when (p_x(9 downto 3) = "1000011") 
									and (p_y(9 downto 3) = "0100000") else --o
						"01110010" when (p_x(9 downto 3) = "1000100") 
									and (p_y(9 downto 3) = "0100000") else --r
						"01100101" when (p_x(9 downto 3) = "1000101") 
									and (p_y(9 downto 3) = "0100000") else --e
						"00111010" when (p_x(9 downto 3) = "1000110") 
									and (p_y(9 downto 3) = "0100000") else --:
						score2_1_digit 	   when (p_x(9 downto 3) = "1000111") 
									and (p_y(9 downto 3) = "0100000") else --digit 1
						score2_2_digit	   when (p_x(9 downto 3) = "1001000") 
									and (p_y(9 downto 3) = "0100000") else --digit 2
						score2_3_digit	   when (p_x(9 downto 3) = "1001001") 
									and (p_y(9 downto 3) = "0100000") else --digit 3
						"00000000";
						
	font_row2 <= p_y(2 downto 0);
	font_col2 <= p_x(2 downto 0);
	char2_on <= 	'1' when (p_x(9 downto 3)>="1000001"  and p_x(9 downto 3) < "1001010") 
						and (p_y(9 downto 3)= "0011110" or p_y(9 downto 3) = "0100000") else '0';
	
	character_adr3 <=	"01010100" when (p_x(9 downto 3) = "1000001") 
											and (p_y(9 downto 3) = "0110111")  else -- T
						"01101001" 	when (p_x(9 downto 3) = "1000010") 
											and (p_y(9 downto 3) = "0110111") else -- i 
						"01101101" 	when (p_x(9 downto 3) = "1000011") 
											and (p_y(9 downto 3) = "0110111") else -- m
						"01100101"	when (p_x(9 downto 3) = "1000100") 
											and (p_y(9 downto 3) = "0110111") else -- e	
						"00111010"	when (p_x(9 downto 3) = "1000101") 
											and (p_y(9 downto 3) = "0110111") else -- :
						digit_min2 	when (p_x(9 downto 3) = "1000110") 
											and (p_y(9 downto 3) = "0110111") else -- digit1 
						digit_min1 	when (p_x(9 downto 3) = "1000111") 
											and (p_y(9 downto 3) = "0110111") else -- digit2
						"00111010"	when (p_x(9 downto 3) = "1001000") 
											and (p_y(9 downto 3) = "0110111") else -- :
						digit_sec2	when (p_x(9 downto 3) = "1001001") 
											and (p_y(9 downto 3) = "0110111") else -- digit3
						digit_sec1	when (p_x(9 downto 3) = "1001010") 
											and (p_y(9 downto 3) = "0110111") else -- digit4
						"00000000";
	font_row3 <= p_y(2 downto 0);
	font_col3 <= p_x(2 downto 0);

	char3_on <= '1' when (p_x(9 downto 3)>= "1000001" and p_x(9 downto 3) < "1001011") 
						 and (p_y(9 downto 3)= "0110111") else '0';
	character_adr4 <=  ai_c_t1_d 	when 	p_x(9 downto 3) = "1000100" and	p_y(9 downto 3) = "0001111" else
					   ai_dv_t1_d 	when 	p_x(9 downto 3) = "1000101" and	p_y(9 downto 3) = "0001111" else
					   ai_c_t2_d 	when 	p_x(9 downto 3) = "1000100" and	p_y(9 downto 3) = "0101000" else
					   ai_dv_t2_d 	when 	p_x(9 downto 3) = "1000101" and p_y(9 downto 3) = "0101000" else
					   "00000000";
	font_row4 <= p_y(2 downto 0);
	font_col4 <= p_x(2 downto 0);
	char4_on <= '1' when ((p_x(9 downto 3)= "1000100" or p_x(9 downto 3) = "1000101") and p_y(9 downto 3) = "0001111")
						or((p_x(9 downto 3)= "1000100" or p_x(9 downto 3) = "1000101") and p_y(9 downto 3) = "0101000") else '0';
						
	process(char1_on, char2_on, char3_on)
	begin
		if(char1_on = '1') then 
			character_adr <= character_adr1;
			font_row <= font_row1;
			font_col <= font_col1;
		elsif(char2_on = '1') then 
			character_adr <= character_adr2;
			font_row <= font_row2;
			font_col <= font_col2;
		elsif(char3_on = '1') then 
			character_adr <= character_adr3;
			font_row <= font_row3;
			font_col <= font_col3;
		elsif(char4_on = '1') then
			character_adr <= character_adr4;
			font_row <= font_row4;
			font_col <= font_col4;
		end if;
	end process;
	char_on <= char1_on or char2_on or char3_on or char4_on;
end behavior;
	
	