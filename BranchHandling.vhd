LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY BranchHandling IS
PORT (
    reset : IN STD_LOGIC;
    Exec_Read_Data1, Exec_Pc_incremented, Dec_Read_Data1, Popped_Data, PC_increment : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    dec_UC_sig, dec_z_sig, exe_z_sig, zeroFlagg, RETT : IN STD_LOGIC;
    --decode_z_sig: for branch predict ****** execute_z_sig : for pc 
    Final_Branch_Ret : out std_logic_vector(31 downto 0);  
    WrongState : out std_logic_vector(1 downto 0);
    PredictedBranch : out std_logic  
    );
END ENTITY;

ARCHITECTURE BArch OF BranchHandling IS

    SIGNAL branch_S : STD_LOGIC;
    SIGNAL predict_state : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL PredictionFixedAddress : STD_LOGIC_VECTOR (31 DOWNTO 0); --Branch address from execute, for JZ
    SIGNAL PredictedAddress : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL BranchDecodeAddress : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL FinalBranch : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL FinalBranchOrReturn : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL PC_state : STD_LOGIC;
    COMPONENT BranchPredict
        PORT (
            reset, z_signal : IN STD_LOGIC; --z_signal indicates a JZ instruction in execute stage, acts as enable here
            zero_flag : IN STD_LOGIC; --changes the state
            branch_state : OUT STD_LOGIC; --0 -> untaken, 1 -> taken 
            prediction_actual_state : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)); --01 -> prediction was untaken, wrong   10 -> prediction was taken, wrong
        --prediction_actual_state is used to control which instruction goes to the pc
    END COMPONENT;

    COMPONENT mux_generic IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            out1 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT mux2bits IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC;
            out1 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0));
    END COMPONENT;
BEGIN

    Branch_Prediction : BranchPredict PORT MAP(reset, dec_z_sig, zeroFlagg, branch_S, Predict_State);
    WrongPredictionFix : mux_generic PORT MAP(Exec_Read_Data1, Exec_Read_Data1, Exec_Pc_incremented, Exec_Pc_incremented, predict_state, PredictionFixedAddress);
    Prediction : mux2bits PORT MAP(PC_increment, Dec_Read_Data1, branch_S, PredictedAddress);
    Unconditional : mux2bits PORT MAP(PredictedAddress, Dec_Read_Data1, Dec_UC_sig, BranchDecodeAddress);
    PC_state <= (predict_state(1) XOR predict_state(0)) AND exe_z_sig;
    BranchAddress : mux2bits PORT MAP(BranchDecodeAddress, PredictionFixedAddress, PC_state, FinalBranch);
    Final_Branch : mux2bits PORT MAP(FinalBranch, Popped_Data, RETT, FinalBranchOrReturn);
    WrongState <= predict_state;
    PredictedBranch <= branch_s;
END ARCHITECTURE BArch;