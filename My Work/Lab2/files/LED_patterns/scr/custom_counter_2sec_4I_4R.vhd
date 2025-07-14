library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity custom_counter_2sec_4I_4R is
    port(
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        clk_freq_mhz : in integer; --clock frequency in megahertz.
        base_rate_4I_4R : in unsigned(31 downto 0); -- base rate in Q4.4 up to maximum of 2 seconds. 
        Q : out std_logic
    );
end entity;

architecture logic of custom_counter_2sec_4I_4R is
    -- signals
    constant FIXED_POINT_F : integer := 4;
    constant SCALE : integer := 2**FIXED_POINT_F;

    signal counter : unsigned(31 downto 0) := (others => '0');
    signal baserate_raw : unsigned (31 downto 0);
    signal counter_Q : std_logic;


    function scaled_tick_count(
        base     : unsigned(31 downto 0);
        clk_mhz : integer
    ) return unsigned is
        variable base_scaled : unsigned(127 downto 0);
        variable result      : unsigned(127 downto 0);
    begin
        -- base x clk_mhz x 1_000_000
        base_scaled := resize(base, 64) * to_unsigned(clk_mhz * 1_000_000, 64);

        -- Divide by 16 (SCALE = 2^4)
        result := base_scaled / to_unsigned(SCALE, 64);

        return resize(result, 32);
    end function;

begin
    -- process clk
    clocked : process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter <= (others => '0');
                baserate_raw <= scaled_tick_count(base_rate_4I_4R, clk_freq_mhz);
                counter_Q <= '0';
            elsif enable = '1' then
                if counter < baserate_raw then
                    counter <= counter + 1;
                    counter_Q <= '0';
                else 
                    counter_Q <= '1';
                    counter <= (others => '0');
                end if;
            else
                --calculate <= '0';
                counter_Q <= '0';
            end if;
        end if;
    end process;

    Q <= counter_Q;

end logic;
