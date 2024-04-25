LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY DecodeExecute IS
    PORT ( 
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- from reg file
        data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- from reg file
        Rsrc1: IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- R source 1 (from F/D)
        Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- R destination (from F/D)
        IMM: IN signed(31 DOWNTO 0); -- Immediate (from F/D)
        inPort: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- In Instruction
        memtoregin: in std_logic_vector(1 downto 0);
        Reg1Writein,Reg2Writein: in std_logic;
       

        outPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --PC to Ex/Mem
        outData1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);--to ALU & Ex/Mem
        outData2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --to mux & ALU
        outRsrc1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); --to mux & Ex/Mem
        outRdst : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); --to mux & Ex/Mem
        outIMM: OUT signed(31 DOWNTO 0); --to mux & ALU
        outInPort: OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --to Ex/Mem
        memtoregout: out std_logic_vector(1 downto 0);
        Reg1WriteOut:out std_logic;
        Reg2WriteOut:out std_logic
    );

END ENTITY DecodeExecute;

ARCHITECTURE decExecRegMain OF DecodeExecute IS
BEGIN
    PROCESS (clk) IS
    BEGIN
    IF rst ='1' THEN
    outPC <= (others => '0');
    outData1 <= (others => '0');
    outData2 <= (others => '0');
    outRsrc1 <= (others => '0');
    outRdst <= (others => '0');
    outIMM <= (others => '0');
    outInPort <= (others => '0');
    memtoregout<=(others=>'0');
    Reg1WriteOut<='0';
    Reg2WriteOut<='0';
ELSIF rising_edge(clk) THEN
    outPC <= PC;
    outData1 <= data1;
    outData2 <= data2;
    outRsrc1 <= Rsrc1;
    outRdst <= Rdst;
    outIMM <= IMM;
    outInPort <= inPort;
    memtoregout<=memtoregin;
    Reg1WriteOut<=Reg1Writein;
    Reg2WriteOut<=Reg2Writein;
END IF;
    END PROCESS;
END decExecRegMain;
