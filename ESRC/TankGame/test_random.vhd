library ieee;
use ieee.std_logic_1164.all;
entity test_random is
	port(
		clock_50: in std_logic;
		count: in std_logic_vector(2 downto 0);
		dir,dir1,dir2: out std_logic_vector(1 downto 0)
		);
end test_random;
architecture behave of test_random is
	signal clk1hz,clk5hz,clk7hz: std_logic;
	signal num,num1,num2: integer range 2 to 17;

	component random is
	GENERIC(max: integer:=17;
			min: integer:=2);
    Port ( 	clk: in  STD_LOGIC;
				cnt: in std_logic_vector(2 downto 0);
				random_num: out  integer range min to max);
	end component;
	
begin
	randoms: random generic map(3,0) port map(
									clk => clk1hz,
									cnt => count,
									random_num => num
									);
	randoms1: random generic map(3,0) port map(
									clk => clk5hz,
									cnt => count,
									random_num => num1
									);
	randoms2: random generic map(3,0) port map(
									clk => clk7hz,
									cnt => count,
									random_num => num2
									);
	clock_1hz: entity work.clk1s_gen
				  port map (
								clk25 => clock_50,
								clk1s => clk1hz
								);
	clock_5hz: entity work.clk5hz
				  port map (
								clock_50 => clock_50,
								clk5hz => clk5hz
								);
	clock_7hz: entity work.clk7hz
				  port map (
								clock_50 => clock_50,
								clk7hz => clk7hz
								);
	
	process(num,num1,num2)
	begin
		if(num=0) then
			dir<="00"; 
		elsif(num=2) then
			dir<="01";
		elsif(num=1) then
			dir<="10";
		elsif(num=3) then
			dir<="11";
	   end if;
		if(num1=3) then
			dir1<="00"; 
		elsif(num1=1) then
			dir1<="01";
		elsif(num1=2) then
			dir1<="10";
		elsif(num1=0) then
			dir1<="11";
	   end if;
		if(num2=3) then
			dir2<="00"; 
		elsif(num2=0) then
			dir2<="01";
		elsif(num2=1) then
			dir2<="10";
		elsif(num2=2) then
			dir2<="11";
	   end if;
	end process;
end behave;
	