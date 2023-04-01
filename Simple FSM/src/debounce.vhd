--------------------------------------------------------------------------------
--
--   FileName:         debounce.vhd
--   Dependencies:     none
--   Design Software:  Quartus Prime Version 17.0.0 Build 595 SJ Lite Edition
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 2.0 6/28/2019 Scott Larson
--     Added asynchronous active-low reset
--     Made stable time higher resolution and simpler to specify
--   Version 1.0 3/26/2012 Scott Larson
--     Initial Public Release
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity debounce is
generic(
	clk_freq		: integer := 50_000_000; -- external clock of the board is 50[MHz]
	stable_time	: integer := 25); -- time after which state of switch can be read 10[ms]
port (
	clk			: in std_logic;
	rst			: in std_logic;
	sw				: in std_logic;
	output		: out std_logic);
end entity;

architecture rtl of debounce is

signal flipflops		: std_logic_vector(1 downto 0);
signal counter_set	: std_logic;

begin

	counter_set <= flipflops(0) xor flipflops(1);
	
	main_porc: process(clk, rst)
		variable count : integer range 0 to clk_freq * stable_time / 1000;
	begin
		if rst = '0' then
			flipflops <= "11";
			output <= '1';
		elsif rising_edge(clk) then
			flipflops(0) <= sw;
			flipflops(1) <= flipflops(0);
			if counter_set = '1' then
				count := 0;
			elsif (count < clk_freq * stable_time / 1000) then
				count := count + 1;
			else
				output <= flipflops(1);
			end if;
		end if;
	end process;
end rtl;
	