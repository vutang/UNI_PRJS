library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity audio_driver is

  port (	clk50	 : in std_logic;                                      -- 50 MHz
			I2C_SDAT : inout std_logic; -- I2C Data
			I2C_SCLK : out std_logic;   -- I2C Clock
			-- Audio CODEC
			AUD_ADCLRCK : inout std_logic;                      -- ADC LR Clock
			AUD_ADCDAT : in std_logic;                          -- ADC Data
			AUD_DACLRCK : inout std_logic;                      -- DAC LR Clock
			AUD_DACDAT : out std_logic;                         -- DAC Data
			AUD_BCLK : inout std_logic;                         -- Bit-Stream Clock
			AUD_XCK : out std_logic;                            -- Chip Clock
			key1,key2,key3: in std_logic	);
  
end audio_driver;

architecture datapath of audio_driver is
	component audio_pll IS
		PORT
		(	inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC );
	END component;

	component de2_wm8731_audio is
	port (
		audio_clk : in std_logic;       --  Audio CODEC Chip Clock AUD_XCK (18.43 MHz)
		reset_n : in std_logic;
		clk50 : in std_logic;
		disable : in std_logic;
		-- Audio interface signals
		AUD_ADCLRCK  : out  std_logic;   --    Audio CODEC ADC LR Clock
		AUD_ADCDAT   : in   std_logic;   --    Audio CODEC ADC Data
		AUD_DACLRCK  : out  std_logic;   --    Audio CODEC DAC LR Clock
		AUD_DACDAT   : out  std_logic;   --    Audio CODEC DAC Data
		AUD_BCLK     : inout std_logic;  --    Audio CODEC Bit-Stream Clock
		key1,key2,key3: in std_logic
	);
	end  component;

	component de2_i2c_av_config is
	port (
		iCLK : in std_logic;
		iRST_N : in std_logic;
		I2C_SCLK : out std_logic;
		I2C_SDAT : inout std_logic
	);
	end component;
	signal audio_clk : std_logic;
	signal disable : std_logic; -- when '1' disable audio module
	signal reset_n : std_logic; -- when '0' reset audio module
	
begin

	PLL : audio_pll port map (	inclk0 => clk50, c0	=> audio_clk);	
	
	i2c : de2_i2c_av_config port map (iCLK => clk50, iRST_n => '1', I2C_SCLK => I2C_SCLK, I2C_SDAT => I2C_SDAT);
	
	--port map to the wm8731 module
	audio: de2_wm8731_audio port map(	audio_clk, reset_n, clk50,	disable, 
										AUD_ADCLRCK, AUD_ADCDAT, AUD_DACLRCK, AUD_DACDAT, AUD_BCLK, key1,key2,key3);
  
	AUD_XCK <= audio_clk;
	
		disable <='0';
		reset_n <='1';
end datapath;
