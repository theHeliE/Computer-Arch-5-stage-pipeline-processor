LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY ExecuteMemory IS
    PORT ( 
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        alu_result: IN signed(31 downto 0);
        flag: IN STD_LOGIC_VECTOR(3 downto 0);
        RegDst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        inPort: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- In Instruction
        RegMemin :IN std_logic_vector(1 downto 0);
        Reg1Writein,Reg2Writein:std_logic; 
        MemReadin: IN std_logic;
        MemWritein: IN std_logic;
        Freein :IN std_logic;
        SPplusin: IN std_logic;
        SPminusin: IN std_logic;
        OUTenablein: IN std_logic;
        UCin : IN std_logic;
        PROTECTEDin: IN std_logic;
        outPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        outWriteData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        outData1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        outALUresult : OUT signed(31 DOWNTO 0); 
        outRegDst : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        outInPort: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        RegMemOut: OUT std_logic_vector(1 downto 0);
        Reg1Writeout:out std_logic;
        Reg2Writeout:out std_logic;
        MemReadout: OUT std_logic;
        MemWriteout: OUT std_logic;
        Freeout :OUT std_logic;
        SPplusout: OUT std_logic;
        SPminusout: OUT std_logic;
        OUTenableout: OUT std_logic;
        UCout : OUT std_logic;
        PROTECTEDout: OUT std_logic
    );

END ENTITY ExecuteMemory;

ARCHITECTURE decExecMemMain OF ExecuteMemory IS
BEGIN
    PROCESS (clk) IS
    BEGIN
    IF rst = '1' THEN
    outPC <= (others => '0');
    outWriteData <= (others => '0');
    outData1 <= (others => '0');
    outALUresult <= (others => '0');
    outRegDst <= (others => '0');
    outInPort <= (others => '0');
    RegMemOut<=(others=>'0');
    Reg1Writeout<='0';
    Reg2Writeout<='0';
    MemReadout<='0';
    MemWriteout<='0';
    Freeout<='0';
    SPplusout<='0';
    SPminusout<='0';
    OUTenableout<='0';
    UCout<='0';
    PROTECTEDout<='0';

ELSIF falling_edge(clk) THEN
    outPC <= PC;
    outWriteData <= data1;
    outData1 <= data1;
    outALUresult <= alu_result;
    outRegDst <= RegDst;
    outInPort <= inPort;
    RegMemOut<=RegMemin;
    Reg1Writeout<=Reg1Writein;
    Reg2Writeout<=Reg2Writein;
    MemReadout<=MemReadin;
    MemWriteout<=MemWritein;
    Freeout<=Freein;
    SPplusout<=SPplusin;
    SPminusout<=SPminusin;
    OUTenableout<=OUTenablein;
    UCout<=UCin;
    PROTECTEDout<=PROTECTEDin;
END IF;
    END PROCESS;
END decExecMemMain;

