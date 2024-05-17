LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity OUTREG is port(
clk : in std_logic;
reset : in std_logic;
data_in : in std_logic_vector(31 downto 0);
data_out : out std_logic_vector(31 downto 0);
enable : in std_logic
);
end OUTREG;

architecture Behavioral of OUTREG is
signal data_out_reg : std_logic_vector(31 downto 0):=(others=>'0');
begin
    process(clk,reset)
    begin
        if reset='1' then
            data_out_reg <= (others=>'0');
        elsif rising_edge(clk) then
            if enable='1' then
                data_out_reg <= data_in;
            end if;
        end if;
    end process;
    data_out <= data_out_reg;
end Behavioral;

