library ieee;
use ieee.std_logic_1164.all;
entity vga_test is
	port (
		clock_50,reset: in std_logic;
		sw: in std_logic_vector (8 downto 0);
		vga_hs,vga_vs: out std_logic;
		vga_r,vga_g,vga_b: out std_logic_vector (3 downto 0)
	);
end vga_test;

architecture behavior of vga_test is
signal vga_rt,vga_gt,vga_bt: std_logic_vector (3 downto 0);
signal video_on: std_logic;
begin
	vga_sync: entity work.vga_sync 
		port map (
			clock_50,reset,vga_hs,vga_vs,video_on,open,open,open,open
	);
	process (clock_50)
	begin
	if (clock_50'event and clock_50 = '1') then
		if (video_on = '1') then
			vga_r(2 downto 0) <= sw(8 downto 6) ;
			vga_g(2 downto 0) <= sw(5 downto 3) ;
			vga_b(2 downto 0) <= sw(2 downto 0) ;
		else 
			vga_r(2 downto 0) <= "000" ;
			vga_g(2 downto 0) <= "000" ;
			vga_b(2 downto 0) <= "000" ;
		end if;
	end if;
	end process;
	vga_r(3) <= '0';
	vga_g(3) <= '0';
	vga_b(3) <= '0';
end behavior;