-------------------------------------------------------------------------------
--	FILE:			LEDs_counter.vhd
--
--	DESCRIPTION:	This design implements binary up counter on 4 LED's.
--					Counter should be incremented every 1 second.
--
-- 	ENGINEER:		Marcin Rynkiewicz
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity LEDs_counter is

generic (
			-- board is clocked with 50MHz
			INPUT_CLK_FREQ		:	integer := 50000000);
port (clk	: in std_logic;
		rst	: in std_logic;
		led	: out std_logic_vector(3 downto 0)
		);
end LEDs_counter;


architecture rlt of LEDs_counter is

signal counter : integer range 0 to INPUT_CLK_FREQ;
signal out_reg	: integer range 0 to 15;


begin

counting_process : process(clk, rst)
begin
	if rising_edge(clk) then
		if rst = '0' then
			counter <= 0;
			out_reg <= 0000;
		else
			counter <= counter + 1;
		end if;
		
		if counter = INPUT_CLK_FREQ - 1 then
			counter <= 0;
			out_reg <= out_reg + 1;
		end if;
	end if;
end process;

display_process : process(out_reg)
begin
	case out_reg is
		when 0 => led <= "1111";
		when 1 => led <= "1110";
		when 2 => led <= "1101";
		when 3 => led <= "1100";
		when 4 => led <= "1011";
		when 5 => led <= "1010";
		when 6 => led <= "1001";
		when 7 => led <= "1000";
		when 8 => led <= "0111";
		when 9 => led <= "0110";
		when 10 => led <= "0101";
		when 11 => led <= "0100";
		when 12 => led <= "0011";
		when 13 => led <= "0010";
		when 14 => led <= "0001";
		when 15 => led <= "0000";
		
		when others => led <= "1111";
	end case;
end process;

end architecture;
