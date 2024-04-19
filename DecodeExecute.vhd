LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DecodeExecute IS
    PORT (
        clk : IN STD_LOGIC;
        writeAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- fetch decode
        writeEnable : IN STD_LOGIC; -- fetch decode
        readData1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- reg file
        readData2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- reg file
        aluSelector : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- controller
        aluCin : IN STD_LOGIC; -- controller

        
        outWriteAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        outWriteEnable : OUT STD_LOGIC;
        outReadData1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        outReadData2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        outAluSelector : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        outAluCin : OUT STD_LOGIC
    );

END ENTITY DecodeExecute;

ARCHITECTURE decExecRegMain OF DecodeExecute IS
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            outWriteAddr <= writeAddress;
            outWriteEnable <= writeEnable;
            outReadData1 <= readData1;
            outReadData2 <= readData2;
            outAluSelector <= aluSelector;
            outAluCin <= aluCin;
        END IF;
    END PROCESS;
END decExecRegMain;
