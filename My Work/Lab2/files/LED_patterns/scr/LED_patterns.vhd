library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LED_Patterns is
	port(
        clk                 : in std_logic;                     -- System clock
        reset               : in std_logic;                     -- System reset 
        PB                  : in std_logic;                     -- Pushbutton to change state
        HPS_LED_control     : in std_logic;                     -- Hardware/software control 0/1
        SYS_CLKs_sec        : in std_logic_vector(31 downto 0); -- Number of system clock cycles in one second
        Base_rate           : in std_logic_vector(7 downto 0);  -- Base transistion period in seconds, fixed-point data type (W=8, F=4)
        LED_reg             : in std_logic_vector(7 downto 0);  -- LED register
		SW                  : in std_logic_vector(3 downto 0);  -- Switches to determine state
		  
        LEDR                 : out std_logic_vector(7 downto 0)  -- LEDs on the board
    );
end entity LED_Patterns;

architecture my_architecture of LED_Patterns is

    -- signal declarations
	signal led_enable : std_logic := '0';
	signal led_enable_shift_right : std_logic := '0';
	signal led_enable_shift_left : std_logic := '0';
	signal LEDR_pattern : std_logic_vector(6 downto 0);


	signal PB_signal : std_logic; 		-- push button output signal from the conditioner
	signal counter : unsigned(7 downto 0) := (others => '0');
	signal base_limit : unsigned(11 downto 0);

	type state_type is (LEFT_SHIFT, RIGHT_SHIFT);
	signal current_state, next_state : state_type;

begin 
    -- component declarations
	u1_button_conditioner : entity work.button_conditioner
		port map (
			clk => clk,
        	SW => PB,
        	Q => PB_signal,
			reset => reset
		);

	u2_led_right_shift : entity work.led_right_shift
		port map (
			clk => clk,
			reset => reset,
			enable => led_enable_shift_right,
			Base_rate => Base_rate,
			LEDR => LEDR_pattern --this needs converting to smaller vector size. 
		);
		
	-- state machine to detect button presses and then change the state to the next led pattern. 
	clocked : process(clk)
	begin
		if reset = '1' then
			--reset logic here. 
			current_state <= RIGHT_SHIFT;
			led_enable <= '0';
			counter <= (others => '0');
		elsif rising_edge(clk) then
			current_state <= next_state;
			led_enable <= '1';

			--led(7) always blink;
			counter <= counter + 1;
			base_limit <= resize(unsigned(Base_rate), 12);
			if counter = base_limit then
				counter <= (others => '0');
				LEDR(7) <= not LEDR(7);
			end if;
		end if;

		case current_state is
			-- when LEFT_SHIFT =>
			-- 	-- led(7) blink;
			-- 	led_enable_shift_left <= led_enable;
			-- 	led_enable_shift_right <= not led_enable;

			when RIGHT_SHIFT =>
				led_enable_shift_right <= led_enable;
				led_enable_shift_left <= not led_enable;

			when others =>

				-- do nothing. 

		end case;

		LEDR <= LEDR(7) & LEDR_pattern;


	end process;

	--combinational logic
	combinational : process(current_state, next_state)
  	begin
		case current_state is
			when RIGHT_SHIFT =>
				if PB_signal then
					next_state <= LEFT_SHIFT;
				end if;
			-- when LEFT_SHIFT =>
			-- 	if PB_signal then
			-- 		next_state <= RIGHT_SHIFT;
			-- 	end if;

			when others =>
				-- do nothing
		end case;

	end process;

end my_architecture;


/*
process(clk) 
begin
	led_signal <= PB_signal;
	
	if led_signal_prev /= led_signal then
		led_switch <= not led_switch;
	end if;
	
	led_signal <= led_signal_prev;
	LEDR(0) <= led_switch;
end process;
		
*/