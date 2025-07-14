library ieee;
use ieee.std_logic_1164.all;
use ieEe.NUMERIC_STD.all;

entity custom_counter_2sec_4I_4R_tb is
end entity;

architecture logic of custom_counter_2sec_4I_4R_tb is
    constant CLK_CYCLE : time := 10 ns;
    signal clk : std_logic;
    signal reset : std_logic;
    signal enable : std_logic;
    signal clk_freq_mhz : integer; --clock frequency in megahertz.
    signal base_rate_4I_4R : unsigned(31 downto 0); -- base rate in Q4.4 up to maximum of 2 seconds. 
    signal Q : std_logic;

    component custom_counter_2sec_4I_4R is
        port(
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            clk_freq_mhz : in integer; --clock frequency in megahertz.
            base_rate_4I_4R : in unsigned(31 downto 0); -- base rate in Q4.4 up to maximum of 2 seconds. 
            Q : out std_logic
        );
    end component;
begin
    uut : custom_counter_2sec_4I_4R
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            clk_freq_mhz => clk_freq_mhz,
            base_rate_4I_4R => base_rate_4I_4R,
            Q => Q
        );

    clk_process : process
    begin
        while true loop
            clk <= '1';
            wait for CLK_CYCLE;
            clk <= '0';
            wait for CLK_CYCLE;
        end loop;
    end process;

    stim_process: process
    --alias uut_calculate is <<signal uut.calculate : std_logic>>;
    alias uut_baserate_raw is <<signal uut.baserate_raw : unsigned(31 downto 0)>>;
    begin
        -- define some values for the module to work
        clk_freq_mhz <= 50;
        base_rate_4I_4R <= "00000000000000000000000000000001"; -- 0.625 seconds. 
        wait for CLK_CYCLE * 2;
        reset <= '1';
        wait for CLK_CYCLE * 2;
        reset <= '0';
        wait for CLK_CYCLE * 2;
        enable <= '1';
        wait for CLK_CYCLE * 2;

        --assert uut_calculate = '1' report "calculate is LOW" severity warning;
        --wait for 20 ns;

        assert uut_baserate_raw = "00000000000000000000000000000000" report "baserate_raw is 0" severity warning;
        wait for CLK_CYCLE * 2;

        wait for 2 sec;
        report "Q = " & std_logic'image(Q);

        wait;

    end process;

end logic;
