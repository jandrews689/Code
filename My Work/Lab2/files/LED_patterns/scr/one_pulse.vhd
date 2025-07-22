library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity one_pulse is
    port (
        clk         : in std_logic;
        reset_n       : in std_logic;
        input_n   : in std_logic;
        Q       : out std_logic
    );

end entity one_pulse;

architecture logic of one_pulse is

    signal input_signal : std_logic := '1';
    signal input_signal_prev : std_logic := '1';
    type state_type is (S_IDLE, S_PULSE_H, S_PULSE_L);
    signal current_state, next_state : state_type := S_IDLE;

begin

    -- edge detection 
    process(clk) 
    begin
        if rising_edge(clk) then
            input_signal_prev <= input_signal;
            input_signal <= input_n;
        end if;
    end process;

    -- clocked process
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            -- reset everything
            input_signal <= '1';
            input_signal_prev <= '1';
            current_state <= S_IDLE;
        elsif rising_edge(clk) then
            -- change state
            current_state <= next_state;
        end if;
    end process;

    -- combinational process
    process(current_state, input_signal, input_signal_prev) 
    begin
        case current_state is
            when S_IDLE =>
                if input_signal = '0' and input_signal_prev = '1' then
                    next_state <= S_PULSE_H;
                else 
                    next_state <= S_IDLE;
                end if;

            when S_PULSE_H =>
                next_state <= S_PULSE_L;

            when S_PULSE_L =>
                if input_signal = '1' and input_signal_prev = '0' then
                    next_state <= S_IDLE;
                else 
                    next_state <= S_PULSE_L;
                end if;
        end case;
    end process;

    -- Output logic
    process(current_state)
    begin
        case current_state is
            when S_PULSE_H => 
                Q <= '1';
            when S_PULSE_L =>
                Q <= '0';
            when others => 
                Q <= '0';
        end case;
    end process;
end logic;