library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity de2_wm8731_audio is
port (
    audio_clk : in std_logic;       --  Audio CODEC Chip Clock AUD_XCK (18.43 MHz)
    reset_n : in std_logic;
    clk50 : in std_logic;
    disable : in std_logic; --when '1', no output from wm8731
    -- Audio interface signals
    AUD_ADCLRCK  : out  std_logic;   --    Audio CODEC ADC LR Clock
    AUD_ADCDAT   : in   std_logic;   --    Audio CODEC ADC Data
    AUD_DACLRCK  : out  std_logic;   --    Audio CODEC DAC LR Clock
    AUD_DACDAT   : out  std_logic;   --    Audio CODEC DAC Data
    AUD_BCLK     : inout std_logic;  --    Audio CODEC Bit-Stream Clock
	key1, key2, key3: in std_logic
  );
end  de2_wm8731_audio;

architecture rtl of de2_wm8731_audio is     

    signal lrck : std_logic;
    signal bclk : std_logic;
    signal xck  : std_logic;
    
    signal lrck_divider : std_logic_vector(11 downto 0); 
    signal bclk_divider : std_logic_vector(3 downto 0);
    
    signal set_bclk : std_logic;
    signal set_lrck : std_logic;
    signal clr_bclk : std_logic;
    signal lrck_lat : std_logic;
    
    signal shift_out : std_logic_vector(15 downto 0);

    signal rom_data_shooted : std_logic_vector(15 downto 0);-- from "shooted" rom to mux
    signal rom_data_fire : std_logic_vector(15 downto 0); -- from "fire" rom to mux
    signal mem_addr_shooted : std_logic_vector(9 DOWNTO 0);
    signal mem_addr_fire : std_logic_vector(11 downto 0);
	signal rom_data_item : std_logic_vector(15 downto 0); -- from "fire" rom to mux
	signal s_rom_data_item : std_logic_vector(15 downto 0); -- from "fire" rom to mux
    signal mem_addr_item : std_logic_vector(15 DOWNTO 0);
    signal counter1 : std_logic_vector(2 downto 0);
    signal counter2 : std_logic_vector(2 downto 0);
    signal counter3 : std_logic_vector(2 downto 0);
    signal data_from_mux : std_logic_vector(15 downto 0);
    signal temp_data_fire : std_logic_vector(15 downto 0);
    signal temp_data_shooted : std_logic_vector(15 downto 0);
    signal temp_data_item : std_logic_vector(15 downto 0);
    
    signal temp : std_logic; -- control the output from wm8731
    
  signal shooted_finish : std_logic;-- shooted
	signal fire_finish : std_logic;-- fire
	signal item_finish : std_logic;-- fire
	signal disable_shooted : std_logic := '1';
	signal disable_fire : std_logic := '1';
	signal disable_item : std_logic := '1';
	signal counter : std_logic_vector(31 downto 0);
	
	component ROM_sound_fire IS
	PORT(	rom_address				: 	IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
			rom_data				: 	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0));
	END component;

	-- component ROM_shooted IS
		-- PORT
		-- (
		-- address		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		-- clock		: IN STD_LOGIC  := '1';
		-- q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		-- );
	-- END component;

begin
  
    -- LRCK divider 
    -- Audio chip main clock is 18.432MHz / Sample rate 48KHz
    -- Divider is 18.432 MHz / 48KHz = 192 (X"C0")
    -- Left justify mode set by I2C controller
    
 audio_shooted: 	entity work.shoot_sound_rom 	port map(mem_addr_shooted,clk50,rom_data_shooted);
 
 audio_fire: 	ROM_sound_fire 	port map(mem_addr_fire,rom_data_fire);
 item_sound: 	entity work.item_sound_rom port map (mem_addr_item(10 downto 0),clk50,s_rom_data_item);
 rom_data_item <= s_rom_data_item when mem_addr_item(15 downto 11) = "000" else "0000000000000000";
  process (audio_clk)
  begin
    if rising_edge(audio_clk) then
      if reset_n = '0' then 
        lrck_divider <= (others => '0');
      elsif lrck_divider = x"0C0" - 1  then        -- "C0" minus 1
        lrck_divider <= X"000";
      else 
        lrck_divider <= lrck_divider + 1;
      end if;
    end if;   
  end process;

  process (audio_clk)
  begin
    if rising_edge(audio_clk) then      
      if reset_n = '0' then 
        bclk_divider <= (others => '0');
      elsif bclk_divider = X"B" or set_lrck = '1'  then  
        bclk_divider <= X"0";
      else 
        bclk_divider <= bclk_divider + 1;
      end if;
    end if;
  end process;

  set_lrck <= '1' when lrck_divider = x"0C0" - 1 else '0';
    
  process (audio_clk)
  begin
    if rising_edge(audio_clk) then
      if reset_n = '0' then
        lrck <= '0';
      elsif set_lrck = '1' then 
        lrck <= not lrck;
      end if;
    end if;
  end process;
    
  -- BCLK divider
  set_bclk <= '1' when bclk_divider(3 downto 0) = "0101" else '0';
  clr_bclk <= '1' when bclk_divider(3 downto 0) = "1011" else '0';
  
  process (audio_clk)
  begin
    if rising_edge(audio_clk) then
      if reset_n = '0' then
        bclk <= '0';
      elsif set_lrck = '1' or clr_bclk = '1' then
        bclk <= '0';
      elsif set_bclk = '1' then 
        bclk <= '1';
      end if;
    end if;
  end process;

  -- Audio data shift output
  process (audio_clk)
  begin
    if rising_edge(audio_clk) then
      if reset_n = '0' then
        shift_out <= (others => '0');
      elsif set_lrck = '1' then
          shift_out <= data_from_mux;
      elsif clr_bclk = '1' then 
        shift_out <= shift_out (14 downto 0) & '0';
      end if;
  -- when disable = 1, no audio data output, which means mute.      
      if disable = '1' then
		temp <= '0';
	  else
	    temp <= shift_out(15);
	  end if; 
    end if;   
  end process;

    -- Audio outputs
    
    AUD_ADCLRCK  <= lrck;          
    AUD_DACLRCK  <= lrck;          
    AUD_DACDAT   <= temp; 
    AUD_BCLK     <= bclk;          

    -- read data from ROM

    -- mux to select which sound to be played
    
	data_from_mux <= temp_data_shooted 
					+ temp_data_item
					+ temp_data_fire;  
	process(clk50,fire_finish, shooted_finish, item_finish, disable_item,disable_fire, disable_shooted)
	variable	count : integer := 0;
	begin
	if rising_edge(clk50) then
		if item_finish = '1' then
			disable_item<='1';
		elsif
		 fire_finish = '1' then
			disable_fire<='1';
		elsif
		 shooted_finish = '1' then
			disable_shooted<='1';
		else
			if key1 = '1' then-- fire
				disable_fire<='0';
			end if;if key2 = '1' then-- fire
				disable_item<='0';
			end if;
			if key3 = '1'  then-- shooted
				disable_shooted <= '0';
			end if;
		end if;
	end if;
	end process;			  
					 
    
    
    -- counter 1 for shooted
    process(audio_clk)      
    begin
		if rising_edge(audio_clk) then
			if disable_shooted = '1' then 
				mem_addr_shooted <= (others=>'0');
				shooted_finish <= '0';
				counter1<=(others => '0');
				temp_data_shooted<=(others => '0');
			else
				temp_data_shooted<=rom_data_shooted;
				if lrck_lat = '1' and lrck = '0' then
					if counter1 = "101" then
						counter1 <= (others => '0');
						if mem_addr_shooted = 
			--			x"ace"
						x"3FF"
			--			x"568" 
						then 
							mem_addr_shooted <= (others => '0');
							shooted_finish <='1';
						else  
							mem_addr_shooted <= mem_addr_shooted + 1;
						end if;
					else
						counter1 <= counter1 + 1;
					end if;
				end if;
			end if;
		end if;
    end process;
    
    
	-- counter 2 for fire
   process(audio_clk)      
   begin
		if rising_edge(audio_clk) then
			if disable_item = '1' then 
				mem_addr_item <= (others => '0');
				item_finish <= '0';
				counter2 <= "000";
				temp_data_item <= (others => '0');
			else
				temp_data_item<=rom_data_item;
				if lrck_lat = '1' and lrck = '0' then
					if counter2 = "011" then
						counter2 <= "000";
						if mem_addr_item = "111111111111111"
				--		"110110010" 
						then 
							mem_addr_item <= (others => '0');
							item_finish <= '1';
						else  
							mem_addr_item <= mem_addr_item + 1;
						end if;
					else
						counter2 <= counter2 + 1;
					end if;
				end if;
			end if;
		end if;
   end process;
   process(audio_clk)      
   begin
		if rising_edge(audio_clk) then
			if disable_fire = '1' then 
				mem_addr_fire <= (others => '0');
				fire_finish <= '0';
				counter3 <= "000";
				temp_data_fire <= (others => '0');
			else
				temp_data_fire<=rom_data_fire;
				if lrck_lat = '1' and lrck = '0' then
					if counter3 = "101" then
						counter3 <= "000";
						if mem_addr_fire = x"1B1"
				--		"0x1b1" 
						then 
							mem_addr_fire <= (others => '0');
							fire_finish <= '1';
						else  
							mem_addr_fire <= mem_addr_fire + 1;
						end if;
					else
						counter3 <= counter3 + 1;
					end if;
				end if;
			end if;
		end if;
   end process;

    process(audio_clk)
    begin
      if rising_edge(audio_clk) then
        lrck_lat <= lrck;
      end if;
    end process;

end architecture;


