library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_right_shift is
    port (
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        Base_rate : in std_logic_vector(7 downto 0);
        LEDR : out std_logic_vector(6 downto 0)
    );
end entity led_right_shift;

architecture logic of led_right_shift is
    constant CLK_FREQ_MHZ : integer := 50;
    signal led_output : std_logic_vector(6 downto 0);
    type state_type is (S0, S1, S2, S3, S4, S5, S6);
    signal current_state, next_state : state_type;
    --signal counter : unsigned(11 downto 0) := (others => '0'); -- this size for overflow protection. 
    --signal base_limit : unsigned(11 downto 0);
    signal counter_Q : std_logic;

begin

    u1_counter : entity work.custom_counter_2sec_4I_4R 
        port map(
            clk => clk,
            reset => reset,
            enable => enable,
            clk_freq_mhz => CLK_FREQ_MHZ,
            base_rate_4I_4R => resize(unsigned(Base_rate), 32),
            Q => counter_Q
        );

    -- edge detection
    process(clk)
    begin
        if rising_edge(clk) then
            LEDR <= led_output;
        end if;
    end process;

    -- clocked process;
    process(clk, reset, enable)
    begin
        if enable = '1' then
            if reset = '0' then
                -- reset logic here.
                current_state <= S0;
            elsif rising_edge(clk) then
                
                if counter_Q = '1' then
                    current_state <= next_state;
                end if;

                -- output state machine for the LED
                case current_state is
                    when S0 =>
                        led_output <= "0000001";

                    when S1 =>
                        led_output <= "1000000";
                        
                    when S2 =>
                        led_output <= "0100000";
                        
                    when S3 =>
                        led_output <= "0010000";
                        
                    when S4 =>
                        led_output <= "0001000";
                        
                    when S5 =>
                        led_output <= "0000100";

                    when S6 =>
                        led_output <= "0000010";
                        
                    when others =>
                        led_output <= "0000000";
                        

                end case;
            end if;
        end if;
    end process;

    -- combinational logic
    process(current_state, next_state)
    begin
        case current_state is
            when S0 => next_state <= S1;
            when S1 => next_state <= S2;
            when S2 => next_state <= S3;
            when S3 => next_state <= S4;
            when S4 => next_state <= S5;
            when S5 => next_state <= S6;
            when S6 => next_State <= S0;
        end case;
    end process;

end logic;