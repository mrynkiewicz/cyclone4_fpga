-------------------------------------------------------------------------------
--	FILE:			four_leds.vhd
--
--	DESCRIPTION:	Simple example switching on LED's LED[1-4] on the board.
--
-- CREATOR:		MARCIN RYNKIEWICZ
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity four_leds is
port (
	leds		: out std_logic_vector(4 downto 1)
	);
end four_leds;


architecture rtl of four_leds is
begin

	leds <= "0000";

end rtl;