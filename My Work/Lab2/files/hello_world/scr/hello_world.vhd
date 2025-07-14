--=======================================================
-- This code is converted from Verilog by Terasic System Builder
--=======================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hello_world is
    Port (
        -- CLOCK
        CLOCK_50   : in  std_logic;

        -- KEY
        KEY        : in  std_logic_vector(3 downto 0);

        -- LED
        LEDR       : out std_logic_vector(9 downto 0);

        -- SWITCHES
        SW         : in  std_logic_vector(9 downto 0)

        -- SEVEN SEGMENT

--        HEX0      : out std_logic_vector(6 downto 0);
--        HEX1      : out std_logic_vector(6 downto 0);
--        HEX2      : out std_logic_vector(6 downto 0);
--        HEX3      : out std_logic_vector(6 downto 0);
--        HEX4      : out std_logic_vector(6 downto 0);
--        HEX5      : out std_logic_vector(6 downto 0)

    );
end hello_world;

architecture Behavioral of hello_world is

	

begin

	
end Behavioral;
