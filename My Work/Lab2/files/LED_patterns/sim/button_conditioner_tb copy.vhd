LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity button_conditioner_tb is
end entity;

architecture logic of button_conditioner_tb is
    -- signal and inital values
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal SW : std_logic := '0';
    signal Q : std_logic;
    type state_type is (IDLE, COUNT);
    --external_current_state <= << signal uut.current_state : state_type >>;
    alias uut_current_state is <<signal uut.current_state : state_type>>;
    
    

    -- componenents 
    component button_conditioner is
        port (
            clk : in std_logic;
            reset : in std_logic;
            SW : in std_logic;
            Q : out std_logic
        );

    end component button_conditioner;

    begin 
    -- port map
    uut : button_conditioner
        port map (
            clk => clk,
            reset => reset,
            SW => SW,
            Q => Q
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
    begin
        -- reset test
        reset <= '0';
        wait for 20 ns;
        reset <= '1';
        wait for 20 ns;
        -- assert that the state is in the correct state
            -- current state is in idle
            assert uut_current_state /= IDLE
                report "state is not IDLE"
                severity note;

        -- assert that the counter is 0
        -- assert that the stored value is 0
        -- assert that debounced value is 0

        reset <= '0';
        wait for 100 ns;

        -- input test 1 - check to see output for stable input
        SW <= '1';
        wait for 150 ms;
        SW <= '0';
        wait for 50 ns;

        -- input test 2 - check to see output during a cycling of input. 
        SW <= '1';
        wait for 50 ns;
        SW <= '0';
        wait for 50 ms;
        SW <= '1';
        wait for 50 ns;
        SW <= '0';
        wait for 50 ns;
        SW <= '1';
        wait for 50 ns;
        SW <= '0';
        wait for 50 ns;       
        wait for 150 ms;

        -- reset test while input 
        SW <= '1';
        wait for 5 ms;
        reset <= '1';
        SW <= '0';
        wait for 20 ns;
        reset <= '0';
        wait for 100 ms; -- 

        -- end simulation 
        wait;
        report "Q = " & std_logic'image(Q);
    end process;
end logic;

        
