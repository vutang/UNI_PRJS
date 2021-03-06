library ieee;
use ieee.std_logic_1164.all;

entity ps2kb is
	port (
		ps2c: in std_logic; -- ps2 clock
		ps2d: in std_logic; --ps2 data
		clk: in std_logic;
		btnp1: out std_logic_vector(5 downto 0); -- player 1
		btnp2: out std_logic_vector(5 downto 0);
		b_enter : out std_logic;--player 2
		b_esc : out std_logic
		--btnf: out std_logic_vector(2 downto 0) -- funtions
	);
end ps2kb;
architecture behavior of ps2kb is
	signal ps2rc: std_logic; -- ps2 received one BYTE
	signal ps2temp,ps2d1,ps2d2,ps2d3: std_logic_vector(7 downto 0); -- temp and last three received bytes
	signal ps2ft: std_logic_vector (15 downto 0); -- ps2 filtered
	signal ps2clk: std_logic;
	signal btnp1t,btnp2t: std_logic_vector(5 downto 0);
	signal ps2rcstate: integer range 0 to 11;
begin	
	process (clk)
	begin
		if(clk'event and clk='1') then 
			ps2ft <= ps2ft(14 downto 0) & ps2c;
		end if;
	end process;
	ps2clk <= '0' when ps2ft ="0000000000000000" else
			  '1' when ps2ft ="1111111111111111" else
			  ps2clk;
	process (ps2clk)
	begin
		if (ps2clk'event and ps2clk='0') then
			ps2rc <= '0';
			case ps2rcstate is
			--start bit
			when 0 =>
				if ps2d = '0' then ps2rcstate <= ps2rcstate + 1; -- ps2d = 1: idle
				end if;
			--parity
			when 9 => 
				if '1' = (ps2d xor ps2temp(0) xor ps2temp(1) xor ps2temp(2) xor ps2temp(3) xor ps2temp(4) xor ps2temp(5) xor ps2temp(6) xor ps2temp(7)) then
						ps2d3 <= ps2d2;
						ps2d2 <= ps2d1;
						ps2d1 <= ps2temp;
						ps2rc <= '1';
				end if;
				ps2rcstate <= ps2rcstate+1;
			when 10 => -- stopbit
				if ps2d='1' then ps2rcstate <= 0;
				end if;
			when others => -- databit
				ps2temp <= ps2d & ps2temp(7 downto 1);
				ps2rcstate <= ps2rcstate + 1;
			end case;
		end if;
	end process;
	process (ps2rc)
	begin
		if (ps2rc'event and ps2rc = '0') then
		-- player1: 0-up, 1-down,2-left,3-right, 4-fire, 5 - mission
			if ps2d1=X"75" and (ps2d2=X"E0" xor ps2d3 = X"E0") then
				if ps2d2 = X"F0" then
					btnp1t(0)<='0';
				else
					btnp1t(0)<='1';
				end if;
			end if;
			if ps2d1=X"72" and (ps2d2=X"E0" xor ps2d3 = X"E0") then
				if ps2d2 = X"F0" then
					btnp1t(1)<='0';
				else
					btnp1t(1)<='1';
				end if;
			end if;
			if ps2d1=X"6B" and (ps2d2=X"E0" xor ps2d3 = X"E0") then
				if ps2d2 = X"F0" then
					btnp1t(2)<='0';
				else
					btnp1t(2)<='1';
				end if;
			end if;
			
			if ps2d1=X"74" and (ps2d2=X"E0" xor ps2d3 = X"E0") then
				if ps2d2 = X"F0" then
					btnp1t(3)<='0';
				else
					btnp1t(3)<='1';
				end if;
			end if;
			if ps2d1=X"5B" then
				if ps2d2 = X"F0" then
					btnp1t(4) <= '0';
				else
					btnp1t(4) <= '1';
				end if;
			end if;
			if ps2d1=X"5D" then
				if ps2d2 = X"F0" then
					btnp1t(5) <= '0';
				else
					btnp1t(5) <= '1';
				end if;
			end if;
			if ps2d1=X"5A" then
				if ps2d2 = X"F0" then
					b_enter <= '0';
				else
					b_enter <= '1';
				end if;
			end if;
			if ps2d1=X"76" then
				if ps2d2 = X"F0" then
					b_esc <= '0';
				else
					b_esc <= '1';
				end if;
			end if;
			
			-- player2: s-dn, w-up,a-left,d-right, g-fire, h - mission
				
			if ps2d1=X"1D"
			then
				if ps2d2 = X"F0" then
					btnp2t(0)<='0';
				else
					btnp2t(0)<='1';
				end if;
			end if;
			if ps2d1=X"1B"
			then
				if ps2d2 = X"F0" then
					btnp2t(1)<='0';
				else
					btnp2t(1)<='1';
				end if;
			end if;
			if ps2d1=X"1C"
			then
				if ps2d2 = X"F0" then
					btnp2t(2)<='0';
				else
					btnp2t(2)<='1';
				end if;
			end if;
			
			if ps2d1=X"23"
			then
				if ps2d2 = X"F0" then
					btnp2t(3)<='0';
				else
					btnp2t(3)<='1';
				end if;
			end if;
			if ps2d1=X"34" then
				if ps2d2 = X"F0" then
					btnp2t(4) <= '0';
				else
					btnp2t(4) <= '1';
				end if;
			end if;
			if ps2d1=X"33" then
				if ps2d2 = X"F0" then
					btnp2t(5) <= '0';
				else
					btnp2t(5) <= '1';
				end if;
			end if;
		end if;
	end process;
	btnp1 <= btnp1t;
	btnp2 <= btnp2t;
end behavior;
				
				
				
				
				
				
				
				
				
				
				
				
				