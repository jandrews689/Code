LIBRARY ieee;

use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity Base_rate is 
    port(
        Q : out std_logic_vector(7 downto 0)
    );
end entity;

architecture logic of Base_rate is
begin
    Q <= "00100000";
end logic;
