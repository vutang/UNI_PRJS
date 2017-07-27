library ieee;
use ieee.std_logic_1164.all;

entity audio_test is
port
(
	clock_50		: in std_logic;
	sw				: in std_logic_vector(2 downto 0);
	I2C_SDAT : inout std_logic; -- I2C Data
	I2C_SCLK : out std_logic;   -- I2C Clock
	-- Audio CODEC
	AUD_ADCLRCK : inout std_logic;                      -- ADC LR Clock
	AUD_ADCDAT : in std_logic;                          -- ADC Data
	AUD_DACLRCK : inout std_logic;                      -- DAC LR Clock
	AUD_DACDAT : out std_logic;                         -- DAC Data
	AUD_BCLK : inout std_logic;                         -- Bit-Stream Clock
	AUD_XCK : out std_logic                             -- Chip Clock

);
end audio_test;

architecture behavior of audio_test is

component audio_driver is
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
  
end component;

begin
audio: audio_driver	port map 
(clock_50, I2C_SDAT, I2C_SCLK, AUD_ADCLRCK, AUD_ADCDAT,
 AUD_DACLRCK, AUD_DACDAT, AUD_BCLK, AUD_XCK,sw(2), sw(1), sw(0));
end behavior;

	