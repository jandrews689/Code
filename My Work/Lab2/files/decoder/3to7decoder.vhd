library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity three_2_seven_decoder is
    port (
        CLK : in std_logic;
        EN  : in std_logic;

        I : in std_logic_vector(2 downto 0);
        Y : out std_logic_vector(6 downto 0)

    );
end three_2_seven_decoder;

architecture Behavioural of three_2_seven_decoder is
    signal Y_s: std_logic_vector(6 downto 0);
begin
    process(clk)
    begin 
        if rising_edge(CLK) then 
            if EN = '1' then
                case I is
                    when "000" => Y_s <= "0000000";
                    when "001" => Y_s <= "0110000";
                    when "010" => Y_s <= "1101101";
                    when "011" => Y_s <= "1111001";
                    when "100" => Y_s <= "0110111";
                    when "101" => Y_s <= "1011011";
                    when "110" => Y_s <= "0011111";
                    when "111" => Y_s <= "1110000";
                    when others => Y_s <= "0000000";  -- blank or off
                end case;
            end if;
        end if;

    end process;

    Y <= not Y_s;

end Behavioural;
