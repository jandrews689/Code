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
        alias uut_current_state is <<signal uut.current_state : state_type>>;
        alias uut_counter is <<signal uut.counter : unsigned(22 downto 0)>>;
        alias uut_stored_value is <<signal uut.stored_value : std_logic>>;
        alias uut_debouced is <<signal uut.debounced : std_logic>>;
    begin

        -- reset test
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        reset <= '1';
        wait for 100 ns;

        -- input test 1 - check to see output for stable input
        SW <= '1';
        wait until Q = '1';
            report "Q went HIGH at time " & time'image(now);

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
            -- assert testing
            assert uut_current_state = COUNT
                report "current_state is IDLE"
                severity warning;
            assert uut_counter /= 0
                report "counter is 0"
                severity warning;
            assert uut_stored_value /= '0'
                report "stored_value is 0"
                severity warning;
            assert uut_debouced /= '0'
                report "debouced is 0"
                severity warning;
        SW <= '0';
        wait for 20 ns;
        reset <= '0';
        wait for 100 ms; 

        -- end simulation 
        wait;
        report "Q = " & std_logic'image(Q);
    end process;
end logic;

        
