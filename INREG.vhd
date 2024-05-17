LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;


ENTITY INREG IS
PORT(
    clk: in std_logic;
    rst: in std_logic;
    data_in: in std_logic_vector(31 downto 0);
    data_out: out std_logic_vector(31 downto 0)
);
END INREG;

ARCHITECTURE BEHAVIORAL OF INREG IS
signal data_out_in: std_logic_vector(31 downto 0):=(others=>'0');
BEGIN
    PROCESS(clk, rst)
    BEGIN
        IF rst = '1' THEN
            data_out_in <= (OTHERS => '0');
        ELSIF clk'EVENT AND clk = '1' THEN
            data_out_in <= data_in;
        END IF;
    END PROCESS;
    data_out <= data_out_in;
END BEHAVIORAL;

