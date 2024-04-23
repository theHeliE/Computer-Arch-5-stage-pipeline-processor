LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY writeBackReg IS
    PORT (
        clk : IN STD_LOGIC;
        writeAddress : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeEnable : IN STD_LOGIC;
        writeData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- output
        qWriteAddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        qWriteEnable : OUT STD_LOGIC;
        qWriteData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END ENTITY writeBackReg;

ARCHITECTURE writeBackRegMain OF writeBackReg IS
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            qWriteAddr <= writeAddress;
            qWriteEnable <= writeEnable;
            qWriteData <= writeData;
        END IF;
    END PROCESS;
END writeBackRegMain;