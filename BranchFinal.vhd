LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY BranchFinal IS
    PORT (
        reset, clock : IN STD_LOGIC;
        Execute_Read_Data1, Execute_Pc_incremented, Decode_Read_Data1, Pop_Data, PC_incremented : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        decode_UC_signal, decode_z_signal, execute_z_signal, zeroFlag, decodeJMP, MemRET : IN STD_LOGIC;
        Final_PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        ResetFetchDecode, ResetDecodeExecute, ResetExecuteMemory, ResetControl : OUT STD_LOGIC
    );
END ENTITY BranchFinal;

ARCHITECTURE BranArch OF BranchFinal IS
    SIGNAL Final_Branch_Return : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL WrongStateSig : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL PredictedBranchSig : STD_LOGIC;
    Signal FlushedSig : Std_logic;
    COMPONENT BranchHandling IS
        PORT (
            reset : IN STD_LOGIC;
            Exec_Read_Data1, Exec_Pc_incremented, Dec_Read_Data1, Popped_Data, PC_increment : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dec_UC_sig, dec_z_sig, exe_z_sig, zeroFlagg, RETT : IN STD_LOGIC;
            --decode_z_sig: for branch predict ****** execute_z_sig : for pc 
            Final_Branch_Ret : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            WrongState : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            PredictedBranch : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT FlushUnit IS
        PORT (
            clk, reset : IN STD_LOGIC;
            WrongPredictionState : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            BranchPredict : IN STD_LOGIC;
            decode_JMP, decode_z_sig, exec_z_sig, decode_UC_sig, MEM_RET : IN STD_LOGIC;
            Flushed, ResetFetchDecode, ResetDecodeExecute, ResetExecuteMemory, ResetControl : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT mux2bits IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC;
            out1 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0));
    END COMPONENT;

BEGIN

branchh: BranchHandling port map( reset, Execute_Read_Data1, Execute_Pc_incremented, Decode_Read_Data1, Pop_Data, PC_incremented, decode_UC_signal, decode_z_signal, execute_z_signal, zeroFlag, MemRET,Final_Branch_Return, WrongStateSig, PredictedBranchSig );
Flushh: FlushUnit port map (clock, reset, WrongStateSig, PredictedBranchSig, decodeJMP, decode_z_signal, execute_z_signal, zeroFlag, MemRET, FlushedSig,ResetFetchDecode, ResetDecodeExecute, ResetExecuteMemory, ResetControl);
FinalllPC: mux2bits port map (PC_incremented,Final_Branch_Return,FlushedSig,Final_pc);
END ARCHITECTURE BranArch;