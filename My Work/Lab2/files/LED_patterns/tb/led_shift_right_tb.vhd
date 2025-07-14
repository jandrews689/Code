library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity led_right_shift_tb is
end entity;

architecture logic of led_right_shift_tb is
    --signals
    signal clk : std_logic;
    signal reset : std_logic;
    signal enable : std_logic;
    signal Base_rate : std_logic_vector(7 downto 0);
    signal LEDR : std_logic_vector(6 downto 0);
    signal LEDR_output : std_logic_vector(6 downto 0);

    type state_type is (S0, S1, S2, S3, S4, S5);


    --components
    component led_right_shift is
        port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            Base_rate : in std_logic_vector(7 downto 0);
            LEDR : out std_logic_vector(6 downto 0)
        );
    end component led_right_shift;

begin

    uut : led_right_shift
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            Base_rate => Base_rate,
            LEDR => LEDR
        );

    clk_process: process
    begin
        -- 50Mhz clk
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    stim_process: process
        --alias 
        alias uut_current_state is <<signal uut.current_state : state_type>>;
        alias uut_counter is <<signal uut.counter : unsigned(11 downto 0)>>;
    begin
        -- reset module to setup
        reset <= '0';
        wait for 20 ns;
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        enable <= '1';
        Base_rate <= "00010000";

        -- Testing required

        -- check which starting state
        report "current_state is: " & to_string(uut_current_state);
        assert uut_current_state = S0
            report "current_state is: " & to_string(uut_current_state) & "INCORRECT STATE"
            severity warning;
        -- check the output
        report "LEDR is:" & to_string(LEDR);
        wait for 40 ns;
        wait;




            
            -- check state changes after duration, checking the counter. 

    end process;


end logic;