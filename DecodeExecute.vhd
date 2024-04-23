LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DecodeExecute IS
    PORT ( 
        clk : IN STD_LOGIC;
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- from reg file
        data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- from reg file
        Rsrc1: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- R source 1 (from F/D)
        Rdst : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- R destination (from F/D)
        IMM: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Immediate (from F/D)
        inPort: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- In Instruction

       

        outPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --PC to Ex/Mem
        outData1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);--to ALU & Ex/Mem
        outData2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --to mux & ALU
        outRsrc1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --to mux & Ex/Mem
        outRdst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --to mux & Ex/Mem
        outIMM: OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --to mux & ALU
        outInPort: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) --to Ex/Mem
    );

END ENTITY DecodeExecute;

ARCHITECTURE decExecRegMain OF DecodeExecute IS
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            outPC <= PC;
            outData1 <= data1;
            outData2 <= data2;
            outRsrc1 <= Rsrc1;
            outRdst <= Rdst;
            outIMM <= IMM;
            outInPort <= inPort;
        END IF;
    END PROCESS;
END decExecRegMain;
