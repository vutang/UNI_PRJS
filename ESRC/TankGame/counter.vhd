library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	port(
		clk: in std_logic;
		enter: in std_logic;
		count: out std_logic_vector(2 downto 0)
		);
end counter;

architecture behave of counter is
	signal dem: integer range 0 to 15;
	signal cnt: std_logic_vector(3 downto 0);
	
begin
	process(clk)
	variable count1: integer range 0 to 15 := 0;
	begin
		if(clk'event and clk = '1') then
			count1:=count1+1;
		end if;
		if(count1 = 15) then
			count1 := 0;
		end if;
		if(enter='1') then
			dem <= count1;
			cnt <= std_logic_vector(to_unsigned(dem,4));
		end if;
	end process;
	count <= cnt(2 downto 0);
end behave;
			