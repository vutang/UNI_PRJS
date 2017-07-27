library ieee;
use ieee.std_logic_1164.all;
entity ps2_test is
	port (
		CLOCK_50: in std_logic;
		PS2_DAT: in std_logic;
		PS2_CLK: in std_logic;
		LEDG: out std_logic_vector(7 downto 0);
		LEDR: out std_logic_vector(5 downto 0)
	);
end ps2_test;

architecture bahavior of ps2_test is
begin
ps2: entity work.ps2kb
	port map (PS2_CLK,ps2_dat,clock_50,ledg(5 downto 0),ledr);
ledg(7) <='1';
ledg(6) <='1';
end bahavior;
