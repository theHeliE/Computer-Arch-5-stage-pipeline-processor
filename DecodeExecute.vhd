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
        Regdistin: in std_logic;
        aluSelectorin :in std_logic_vector(3 downto 0);
        ALUsrcin: in std_logic;
        MemWriteIn: in std_logic;
        MemReadIn: in std_logic;
        SPplus: in std_logic;
        SPmin: in std_logic;
        Outenable: in std_logic;
        FlagEnablein : in std_logic;
        Freein : in std_logic;
        UCin : in std_logic;
        PROTECTEDin: in std_logic;
        outPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --PC to Ex/Mem
        outData1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);--to ALU & Ex/Mem
        outData2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --to mux & ALU
        outRsrc1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); --to mux & Ex/Mem
        outRdst : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); --to mux & Ex/Mem
        outIMM: OUT signed(31 DOWNTO 0); --to mux & ALU
        outInPort: OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --to Ex/Mem
        memtoregout: out std_logic_vector(1 downto 0);
        Reg1WriteOut:out std_logic;
        Reg2WriteOut:out std_logic;
        Regdistout: out std_logic;
        aluSelectorout :out std_logic_vector(3 downto 0);
        ALUsrcout: out std_logic;
        MemWriteout: out std_logic;
        MemReadout: out std_logic;
        SPplusout: out std_logic;
        SPminout: out std_logic;
        Outenableout: out std_logic;
        FlagEnableout : out std_logic;
        Freeout : out std_logic;
        UCout: out std_logic;
        PROTECTEDout: out std_logic
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
    Regdistout<='0';
    aluSelectorout <="0000";
    ALUsrcout<='0';
    MemWriteout<='0';
    MemReadout<='0';
    SPplusout<='0';
    SPminout<='0';
    Outenableout<='0';
    FlagEnableout <='0';
    Freeout<='0';
    UCout<='0';
    PROTECTEDout<='0';
ELSIF falling_edge(clk) THEN
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
    Regdistout<=Regdistin;
    aluSelectorout <=aluSelectorin;
    ALUsrcout<=ALUsrcin;
    MemWriteout<=MemWriteIn;
    MemReadout<=MemReadIn;
    SPplusout<=SPplus;
    SPminout<=SPmin;
    Outenableout<=Outenable;
    FlagEnableout <=FlagEnablein;
    Freeout<=Freein;
    UCout<=UCin;
    PROTECTEDout<=PROTECTEDin;
END IF;
    END PROCESS;
END decExecRegMain;
