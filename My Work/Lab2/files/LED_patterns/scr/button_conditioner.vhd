library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity button_conditioner is
    port (
        clk : in std_logic;
        reset : in std_logic;
        SW : in std_logic;
        Q : out std_logic
    );

end button_conditioner;

architecture logic of button_conditioner is

    signal sync_reg1, sync_reg2, stored_value : std_logic := '0';
    signal counter : unsigned(22 downto 0) := (others => '0');
    signal debounced : std_logic := '0';

    type state_type is (IDLE, COUNT);
    signal current_state, next_state : state_type := IDLE;

    signal pulse_signal : std_logic;	-- one_pulse output signal from the one_pulse
    signal PB_signal : std_logic; 		-- push button output signal from the conditioner

begin

    u2_one_pulse : entity work.one_pulse
    port map (
        clk => clk,
        reset => reset,
        input => PB_signal,
        Q => pulse_signal

    );


    -- Double DFF
    process(clk)
    begin
        if rising_edge(clk) then
            sync_reg1 <= SW;
            sync_reg2 <= sync_reg1;
        end if;
    end process;

    -- clocked process: clocked processes
    process(clk, reset)
    begin
        if reset = '0' then
            current_state <= IDLE;
            counter <= (others => '0');
            stored_value <= '0';
            debounced <= '0';
        elsif rising_edge(clk) then
            current_state <= next_state;

            case current_state is
                when IDLE =>
                    if sync_reg2 /= debounced then
                        stored_value <= sync_reg2;
                    end if;

                when COUNT =>
                    counter <= counter + 1;
                    if counter = to_unsigned(5_000_000 - 1, counter'length) then
                        counter   <= (others => '0');
                        debounced <= stored_value;
                    end if;
                
                when others =>
                    null;
            end case;

            -- Safety: reset counter if not in COUNT
            if current_state /= COUNT then
                counter <= (others => '0');
            end if;
        end if;
    end process;

    -- combinational process: next state logic. 
    process(current_state, stored_value, debounced)
    begin

        case current_state is

            when IDLE =>
                if stored_value = debounced then
                    next_state <= IDLE; 
                else
                    next_state <= COUNT;
                end if;
                
            when COUNT => 
                if debounced = stored_value then
                    next_state <= IDLE; 
                else
                    next_state <= COUNT;
                end if;

            when others =>
                next_state <= IDLE;

        end case;
    end process;
    
    PB_signal <= debounced;
    Q <= pulse_signal;
end logic;



