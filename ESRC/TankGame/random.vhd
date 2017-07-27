library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use work.my_package.all;
entity random is
	 GENERIC(
			max: integer:=17;
			min: integer:=2
			);
    Port ( 	clk: in  STD_LOGIC;
				cnt: in std_logic_vector(2 downto 0);
				random_num: out  integer range min to max);
end random;
architecture Behavior of random is
		signal rand_temp : std_logic_vector(3 downto 0):= '1' & cnt;
		signal temp : std_logic := '0';
		signal random_next,random_reg,q_next,q_reg: integer range min to max;
begin	
	process(clk)	
	begin
	if ( clk'event and clk='1') then	
		temp <= rand_temp(3) xor rand_temp(2);
		rand_temp(3 downto 1) <= rand_temp(2 downto 0);
		rand_temp(0) <= temp;
		random_reg<=random_next;
		q_reg<=q_next;
	end if;
	end process;
	process(random_reg,q_reg)
	begin
		q_next<=conv_integer(rand_temp)+min;
		if(q_reg>max) then random_next<=random_reg;
		else random_next<=q_reg;
		end if;
	end process;
	random_num <= random_reg;
end Behavior;

