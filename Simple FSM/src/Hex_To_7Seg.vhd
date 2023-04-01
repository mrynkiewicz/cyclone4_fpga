-------------------------------------------------------------------------------
--	FILE:			Hex_To_7Seg.vhd
--
--	DESCRIPTION:	Simple design to translate hex number to seven segment display
--
--	ENGINEER:		Marcin Rynkiewicz
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Hex_To_7Seg is
port (
	seven_seg		: out std_logic_vector(6 downto 0);
	hex				: in std_logic_vector(3 downto 0));
end entity;

architecture rtl of Hex_To_7Seg is

signal seg_out: std_logic_vector(6 downto 0);

begin
	seven_seg<= not seg_out;
	
	decode_process : process(hex)
	begin
		case hex is
			when x"0" => seg_out <= "0111111";
			when x"1" => seg_out <= "0000110";
			when x"2" => seg_out <= "1011011";
			when x"3" => seg_out <= "1001111";
			when x"4" => seg_out <= "1100110";
			when x"5" => seg_out <= "1101101";
			when x"6" => seg_out <= "1111101";
			when x"7" => seg_out <= "0000111";
			when x"8" => seg_out <= "1111111";
			when x"9" => seg_out <= "1101111";
			when x"A" => seg_out <= "1110111";
			when x"B" => seg_out <= "1111100";
			when x"C" => seg_out <= "0111001";
			when x"D" => seg_out <= "1011110";
			when x"E" => seg_out <= "1111001";
			when x"F" => seg_out <= "1110001";
			when others =>
				seg_out <= (others => 'X');
		end case;
	end process;
end rtl;