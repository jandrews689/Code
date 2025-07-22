library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity LED_Patterns_tb is
end entity;

architecture logic of LED_Patterns_tb is
        signal clk                 : std_logic;                     -- System clock
        signal reset               : std_logic;                     -- System reset 
        signal PB                  : std_logic;                     -- Pushbutton to change state
        signal HPS_LED_control     : std_logic;                     -- Hardware/software control 0/1
        signal SYS_CLKs_sec        : std_logic_vector(31 downto 0); -- Number of system clock cycles in one second
        signal Base_rate           : std_logic_vector(7 downto 0);  -- Base transistion period in seconds, fixed-point data type (W=8, F=4)
        signal LED_reg             : std_logic_vector(7 downto 0);  -- LED register
		signal SW                  : std_logic_vector(3 downto 0);  -- Switches to determine state
        signal LEDR                : std_logic_vector(7 downto 0);   -- LEDs on the board

        component LED_Patterns is
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
        end component;
begin

    uut : LED_Patterns
        port map(

            clk                 => clk,
            reset               => reset,
            PB                  => PB,
            HPS_LED_control     => HPS_LED_control,
            SYS_CLKs_sec        => SYS_CLKs_sec,
            Base_rate           => Base_rate,
            LED_reg             => LED_reg,
            SW                  => SW,
            LEDR                => LEDR

        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    stim_process: process
    alias uut_counter_base_rate_4I_4R is <<signal uut.base_rate_4I_4R : unsigned(31 downto 0)>>;
    alias uut_LEDR_7 is <<signal uut.LEDR_7 : std_logic>>;
    -- alias uut_LEDR is <<signal uut.LEDR : >>
    begin
        -- Set initial values
        Base_rate <= "00000001";

        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        reset <= '1';
        wait for 50 ms;
        PB <= '1';
        wait for 10 ms;
        PB <= '0';
        wait for 10 ms;
        PB <= '1';
        wait;



    end process;

end logic;