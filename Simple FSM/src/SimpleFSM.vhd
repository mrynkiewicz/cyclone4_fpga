-------------------------------------------------------------------------------
--	FILE:			SimpleFSM.vhd
--
--	DESCRIPTION:	Desgin to give exmaple of FinitStateMachine. Each state is
--						represented by display position (1 of 4) on the board.
--						Swtiches S1 and S2 shift position left and right.
--						Switched S3 and S4 decrement and increment value on the display
--
--	ENGINEER:		Marcin Rynkiewicz
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimpleFSM is
port (
	clk		: in std_logic;
	rst		: in std_logic;
	sw1		: in std_logic;
	sw2		: in std_logic;
	sw3		: in std_logic;
	sw4		: in std_logic;
	seg		: out std_logic_vector(6 downto 0);
	reg		: out std_logic_vector(3 downto 0));
	
end entity;

architecture rtl of SimpleFSM is

signal hex_value 		: std_logic_vector(3 downto 0);
signal sw1_r, sw2_r	: std_logic;
signal sw3_r, sw4_r	: std_logic;

signal delayed_sw1	: std_logic;
signal delayed_sw2	: std_logic;
signal delayed_sw3	: std_logic;
signal delayed_sw4	: std_logic;

signal btn1pressed	: std_logic;
signal btn2pressed	: std_logic;
signal btn3pressed	: std_logic;
signal btn4pressed	: std_logic;

type state_type is (DISP1, DISP2, DISP3, DISP4);

signal state : state_type;

begin

	seg0 : entity work.Hex_To_7Seg port map(seg, hex_value);
	switch1 : entity work.debounce port map(clk, rst, sw1, sw1_r);
	switch2 : entity work.debounce port map(clk, rst, sw2, sw2_r);
	switch3 : entity work.debounce port map(clk, rst, sw3, sw3_r);
	switch4 : entity work.debounce port map(clk, rst, sw4, sw4_r);
	
	
	deleyed_switch  : process(clk, rst)
	begin
		if rst = '0' then
			delayed_sw1 <= '1';
			delayed_sw2 <= '1';
			delayed_sw3 <= '1';
			delayed_sw4 <= '1';
			btn1pressed <= '0';
			btn2pressed <= '0';
			btn3pressed <= '0';
			btn4pressed <= '0';
		elsif rising_edge(clk) then
			delayed_sw1 <= sw1_r;
			delayed_sw2 <= sw2_r;
			delayed_sw3 <= sw3_r;
			delayed_sw4 <= sw4_r;
			
			-- Button is pulling FPGA pin to ground when pressed.
			-- Checking previous value to detect falling edge.
			if sw1_r = '0' and delayed_sw1 = '1' then
				btn1pressed <= '1';
			else
				btn1pressed <= '0';
			end if;
			if sw2_r = '0' and delayed_sw2 = '1' then
				btn2pressed <= '1';
			else
				btn2pressed <= '0';
			end if;
			if sw3_r = '0' and delayed_sw3 = '1' then
				btn3pressed <= '1';
			else
				btn3pressed <= '0';
			end if;
			if sw4_r = '0' and delayed_sw4 = '1' then
				btn4pressed <= '1';
			else
				btn4pressed <= '0';
			end if;
		end if;
	end process;
	
	
	disp_value : process(clk, rst)
	begin
		if rst = '0' then
			hex_value <= "0000";
		elsif rising_edge(clk) then
			if btn3pressed = '1' then
				hex_value <= std_logic_vector(unsigned(hex_value) - 1);
			elsif btn4pressed = '1' then
				hex_value <= std_logic_vector(unsigned(hex_value) + 1);
			end if;
		end if;
	end process;
	
	-- Main FSM process.
	-- Shifting left and right based on key pressed.
	state_machine : process(clk, rst)
	begin

	if rst = '0' then
		state <= DISP1;
	elsif rising_edge(clk) then
		case state is
			when DISP1 =>
				if btn1pressed = '1' then
					state <= DISP4;
				elsif btn2pressed = '1' then
					state <= DISP2;
				else
					state <= DISP1;
				end if;
				reg <= "1110";
			when DISP2 =>
				if btn1pressed = '1' then
					state <= DISP1;
				elsif btn2pressed = '1' then
					state <= DISP3;
				else
					state <= DISP2;
				end if;
				reg <= "1101";
			when DISP3 =>
				if btn1pressed = '1' then
					state <= DISP2;
				elsif btn2pressed = '1' then
					state <= DISP4;
				else
					state <= DISP3;
				end if;
				reg <= "1011";
			when DISP4 =>
				if btn1pressed = '1' then
					state <= DISP3;
				elsif btn2pressed = '1' then
					state <= DISP1;
				else
					state <= DISP4;
				end if;
				reg <= "0111";
			when others =>
				state <= DISP1;
				reg <= "1110";
			end case;
	end if;
	end process;

end rtl;