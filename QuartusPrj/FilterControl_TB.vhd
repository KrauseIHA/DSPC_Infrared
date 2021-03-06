library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity FilterControl_tb is
end;

architecture bench of FilterControl_tb is
	component FilterControl
		port(
			clk     : in  std_logic;
			reset_n : in  std_logic;
			IR_RX   : in  std_logic;
			data    : out std_logic
		);
	end component;

	signal clk     : std_logic;
	signal reset_n : std_logic;
	signal IR_RX   : std_logic;
	signal data    : std_logic;

	constant clock_period   : time    := 2500 ns; -- 2 MHz;
	constant IrClock_period : time    := 27 us;
	constant Ir_signals     : integer := 32;

	signal stop_the_clock   : boolean;
	signal stop_the_Irclock : boolean := false;

begin
	uut : FilterControl
		port map(
			clk     => clk,
			reset_n => reset_n,
			IR_RX   => IR_RX,
			data    => data
		);

	stimulus : process
	begin
		reset_n <= '0';
		wait for 1 us;
		reset_n <= '1';

		-- Put test bench stimulus code here


		wait;
	end process;

	IRclocking : process
		variable Ir_recived : integer := 0;
	begin
		wait for 1 us;
		while not stop_the_Irclock loop
			IR_RX <= '1', '0' after IrClock_period / 3 * 2;
			if (Ir_recived = Ir_signals) then
				-- stop_the_Irclock <= true;
				IR_RX      <= '1';
				Ir_recived := 0;
				wait for 889 us;
			else
				Ir_recived := 1 + Ir_recived;
			end if;
			wait for IrClock_period;
		end loop;
		wait;
	end process;

	clocking : process
	begin
		while not stop_the_clock loop
			clk <= '0', '1' after clock_period / 2;
			wait for clock_period;
		end loop;
		wait;
	end process;

end;
