LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity one_pulse_tb is
end entity;

architecture logic of one_pulse_tb is
    -- signals and initial values. 
    signal clk : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal input : std_logic := '0';
    signal Q : std_logic;

    -- components
    component one_pulse is
        port (
            -- clk
            -- reset_n
            -- input
            -- Q
            clk         : in std_logic;
            reset_n       : in std_logic;
            input       : in std_logic;
            Q           : out std_logic
        );
    
    end component one_pulse;

    begin 
    -- port map 
    uut : one_pulse 
        port map (
            clk => clk,
            reset_n => reset_n,
            input => input,
            Q => Q
        );

    -- 50 Mhz Clock
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
        --alias 
        alias uut_input_signal is <<signal uut.input_signal : std_logic>>;
        alias uut_input_signal_prev is <<signal uut.input_signal_prev : std_logic>>;
    begin
        -- reset stimulus, testing the reset 
        reset_n <= '1';
        wait for 20 ns;
        reset_n <= '0'; -- reset active. 
        wait for 20 ns;

        -- Print what the internal signals are.
        report "uut_input_signal is:" & to_string(uut_input_signal);
        report "uut_input_signal_prev is:" & to_string(uut_input_signal_prev);

        reset_n <= '1'; 
        wait for 40 ns;
    
        -- input stimulus
        input <= '0';
        wait for 20 ns;
        -- input_signal change to '0'
            assert uut_input_signal = '1'
                report "uut_input_signal is:" & to_string(uut_input_signal)
                severity warning;
        wait for 20 ns;
            assert uut_input_signal_prev = '1'
                report "uut_input_signal_prev is:" & to_string(uut_input_signal_prev)
                severity warning;

        wait for 20 ns;
            assert Q = '0'
                report "Q is:" & to_string(Q) & "INCORRECT VALUE LOW"
                severity warning;
            report "Q is:" & to_string(Q);

        wait for 20 ns;
            assert Q = '1'
                report "Q is:" & to_string(Q) & "INCORRECT VALUE HIGH AFTER ONE CLOCK CYCLE"
                severity warning;
            report "Q is:" & to_string(Q);
        
        -- reset_n during input stimulus
        input <= '0';
        wait for 30 ns;
        reset_n <= '0';
        wait for 20 ns;
            assert uut_input_signal = '0' 
                report "input_signal is:" & to_string(uut_input_signal) & "INCORRECT VALUE LOW WHEN IN RESET"
                severity warning;
            assert uut_input_signal_prev = '0'
                report "input_signal_prev is:" & to_string(uut_input_signal_prev) & "INCORRECT VALUE LOW WHEN IN RESET"
                severity warning;
        -- end simulation
        wait;
        report "Q = " & std_logic'image(Q);
    end process;
end logic;