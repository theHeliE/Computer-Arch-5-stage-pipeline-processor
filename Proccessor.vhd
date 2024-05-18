library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.memregisterfile_pkg.all;
entity processor is
    Port ( 
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        --PC  : in  STD_LOGIC_VECTOR (31 downto 0);

        inPort: in STD_LOGIC_VECTOR (31 downto 0);

        alu_result: out signed (31 downto 0);
        flag: out STD_LOGIC_VECTOR (3 downto 0);
        Registers: out vector_array;
        exception: out std_logic;
        outVal : out std_logic_vector(31 downto 0)
        );

        
        
end processor;

architecture Behavioral of processor is
signal Instruction: std_logic_vector(31 downto 0):=(others=>'0');
signal opcode : std_logic_vector (4 downto 0):=(others=>'0');
signal Rsrc1 :  STD_LOGIC_VECTOR (2 downto 0):=(others=>'0');
signal Rsrc2 :  STD_LOGIC_VECTOR (2 downto 0):=(others=>'0');
signal Rdst :  STD_LOGIC_VECTOR (2 downto 0):=(others=>'0');
signal imm:  signed (15 downto 0):=(others=>'0');
signal Data1_int, Data2_int, PC_int, outInPort_int, outData1_int, outData2_int: std_logic_vector (31 downto 0):=(others=>'0');
signal immExtended_int: unsigned (31 downto 0):=(others=>'0');
signal outIMM_int: signed (31 downto 0):=(others=>'0');
signal outRsrc1_int, outRdst_int: std_logic_vector (2 downto 0):=(others=>'0');
signal alu_sel_inDE: std_logic_vector(3 downto 0):=(others=>'0');
signal alu_sel_outDE: std_logic_vector(3 downto 0):=(others=>'0');
signal MemToReg: std_logic_vector(1 downto 0):=(others=>'0');
signal alu_src_inDE, flag_enable_inDE, RegWrite1_inDE, RegWrite2_inDE, Regdst_inDE, MemWrite_inDE, MemRead_inDE, SPplus_inDE, SPmin_inDE, OUTenable_inDE, JMP, Z, PROTECT_inDE,FREE_inDE ,UC_inDE,RET: std_logic:='0';
signal alu_src_outDE: std_logic:='0';
signal alu_src_ex: std_logic_vector(1 downto 0):=(others=>'0');
signal RegDst_val: std_logic_vector(2 downto 0):=(others=>'0');
signal outALUresult, ALUresultToWB : signed(31 downto 0):=(others=>'0');
signal data1ToWB : std_logic_vector(31 downto 0):=(others=>'0');
signal WBRegDst : std_logic_vector(2 downto 0):=(others=>'0');
signal RegMemoutDE :std_logic_vector(1 downto 0):=(others=>'0');--new
signal RegMemoutEM: std_logic_vector(1 downto 0):=(others=>'0');--new
signal RegMemoutMWB: std_logic_vector(1 downto 0):=(others=>'0');--new
signal Reg1WriteEXMEM,Reg2WriteEXMEM,Reg1WriteDE,Reg2WriteDE:std_logic:='0';--new
signal FinalReg1Write,FinalReg2Write:std_logic:='0'; 
signal flagReg: std_logic_vector(3 downto 0):=(others=>'0');
signal FinalWrittenData : std_logic_vector(31 downto 0) := (others => '0');
signal finalDataout : std_logic_vector(31 downto 0) := (others => '0');
signal finaloutmemoryout: std_logic_vector(31 downto 0) := (others => '0');
signal FinalIn : std_logic_vector(31 downto 0) := (others => '0');
signal FinalALU: std_logic_vector(31 downto 0) := (others => '0');
signal REG_DSToutt: std_logic_vector(2 downto 0) := (others => '0');
signal SELECTION_SP: std_logic_vector(1 downto 0):=(others=>'0');
signal OUTPUT_SELECTION: std_logic_vector(2 downto 0):=(others=>'0');
signal SPFinalNEW:std_logic_vector(31 downto 0):=(others=>'0');
signal SPFINALOLD:std_logic_vector(31 downto 0):=(others=>'0');
signal ExceptionOut: std_logic :='0';
signal RegdistoutDE: std_logic:='0';
signal MemRead_outDE,MemWrite_outDE,Free_outDE,SPplus_outDE,SPminus_outDE,OUTenable_outDE,UCout_outDE,PROTECTED_outDE,Flag_enable_outDE:std_logic:='0';
signal MemRead_outEx,MemWrite_outEx,Free_outEx,SPplus_outEX,SPminus_outEX,OUTenable_outEX,UC_outEX,PROTECTED_outEX: std_logic:='0';
signal OutEnableFinal,OutEnable_outMEM: std_logic:='0';

--branches
signal wrongPrediction_int : std_logic_vector(1 downto 0);
signal BranchPredict_int : std_logic;
signal decode_JMP_int, decode_z_sig_int, exec_z_sig_int, decode_UC_sig_int, MEM_RET_int : std_logic;
signal Flushed_int, ResetFetchDecode_int, ResetDecodeExecute_int, ResetExecuteMemory_int, ResetControl_int : std_logic;
signal PCexec, PCorigin : std_logic_vector(31 downto 0);
signal ZoutDE, JMPoutDE : std_logic;


    component controller IS
    PORT (
	Reset : IN STD_LOGIC;
        opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        RegDist : OUT STD_LOGIC;
	RegWrite1 : OUT STD_LOGIC;
	RegWrite2 : OUT STD_LOGIC;
	ALUsrc : OUT STD_LOGIC;
	MemWrite : OUT STD_LOGIC;
	MemRead : OUT STD_LOGIC;
	MemToReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	SPplus : OUT STD_LOGIC;
	SPmin : OUT STD_LOGIC; 
    ALUselector : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    OUTenable : OUT STD_LOGIC;
	JMP : OUT STD_LOGIC;
	Z : OUT STD_LOGIC;
	PROTECT : OUT STD_LOGIC;
	RET : OUT STD_LOGIC;
	FlagEnable : OUT STD_LOGIC;
	FREE: OUT STD_LOGIC;
	UC :OUT std_logic
    );
END component;

component FetchStage is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;     
           Instruction : out STD_LOGIC_VECTOR(31 downto 0);
           PCout : out STD_LOGIC_VECTOR(31 downto 0));
    End component;

    component OUTREG is port(
    clk : in std_logic;
    reset : in std_logic;
    data_in : in std_logic_vector(31 downto 0);
    data_out : out std_logic_vector(31 downto 0);
    enable : in std_logic
    );
    end component;

    component decode is 
    Port ( 
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        Rsrc1 : in  STD_LOGIC_VECTOR (2 downto 0);
        Rsrc2 : in  STD_LOGIC_VECTOR (2 downto 0);
        Rdst : in  STD_LOGIC_VECTOR (2 downto 0);
        imm : in  signed (15 downto 0);

        regWrite1 : in STD_LOGIC;
        regWrite2 : in STD_LOGIC;
        
        writeData1 : in STD_LOGIC_VECTOR (31 downto 0);
        writeData2 : in STD_LOGIC_VECTOR (31 downto 0);
        regDst1 : in STD_LOGIC_VECTOR (2 downto 0);


        immExtended : out  unsigned (31 downto 0);
        Data1: out STD_LOGIC_VECTOR (31 downto 0);
        Data2: out STD_LOGIC_VECTOR (31 downto 0);
        reg: out vector_array

    );
    end component;
    component WriteBackStage is Port(
        clk:in std_logic;
        rst:in std_logic;
        Data1in: in std_logic_vector(31 downto 0);
        Dataoutmemoryin:in std_logic_vector(31 downto 0);
        ALU_resin:in std_logic_vector(31 downto 0);
        Reg_dstin: in std_logic_vector(2 downto 0);
        INin: in std_logic_vector(31 downto 0);
        MemtoRegin: in std_logic_vector(1 downto 0);
        Reg1Writein:in std_logic;
        Reg2Writein:in std_logic;
        OUTenablein: in std_logic;
        Data1out: out std_logic_vector(31 downto 0);
        Dataoutmemoryout: out std_logic_vector(31 downto 0);
        Alu_resout: out std_logic_vector(31 downto 0);
        Reg_dstout: out std_logic_vector(2 downto 0);
        INoutput : out std_logic_vector (31 downto 0);
        MemtoRegout:out std_logic_vector(1 downto 0);
        Reg1Writeout: out std_logic;
        Reg2Writeout:out std_logic;  
        OUTenableout: out std_logic;
        ValueOut: out std_logic_vector(31 downto 0)
    );
End component;

    component DecodeExecute IS
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
        JMPin: in std_logic;
        Zin: in std_logic;
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
        PROTECTEDout: out std_logic;
        JMPoutp: out std_logic;
        Zout: out std_logic
    );

    END component;


    component Execute is
        port(
            clk: in STD_LOGIC;
            reset: in STD_LOGIC;
            A:in signed(31 downto 0);
            data2: in signed(31 downto 0);
            imm: in signed(31 downto 0);
            alu_sel:in std_logic_vector(3 downto 0);
            alu_src:in std_logic_vector(1 downto 0);
            flag_enable: in std_logic;
            Output:out signed(31 downto 0);
            flagReg:out std_logic_vector(3 downto 0)
        );

    end component;
    component mux_generic IS 
	Generic ( n : Integer:=32);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
    END component;

    component mux2bits IS 
	Generic ( n : Integer:=32);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
		sel : IN  std_logic;
		out1 : OUT std_logic_vector (n-1 DOWNTO 0));
    END component;
    
    COMPONENT BranchFinal IS
    PORT (
        reset, clock : IN STD_LOGIC;
        Execute_Read_Data1, Execute_Pc_incremented, Decode_Read_Data1, Pop_Data, PC_incremented : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        decode_UC_signal, decode_z_signal, execute_z_signal, zeroFlag, decodeJMP, MemRET : IN STD_LOGIC;
        Final_PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        ResetFetchDecode, ResetDecodeExecute, ResetExecuteMemory, ResetControl : OUT STD_LOGIC
    );
    END COMPONENT;

    component ExecuteMemory IS
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
    END component;

    COMPONENT FlushUnit IS
    PORT (
        clk, reset : IN STD_LOGIC;
        WrongPredictionState : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        BranchPredict : IN STD_LOGIC;
        decode_JMP, decode_z_sig, exec_z_sig, decode_UC_sig, MEM_RET : IN STD_LOGIC;
        Flushed, ResetFetchDecode, ResetDecodeExecute, ResetExecuteMemory, ResetControl : OUT STD_LOGIC
    );
    END COMPONENT;

    component BranchHandling IS
    PORT (

        reset : IN STD_LOGIC;
        Execute_Read_Data1, Execute_Pc_incremented, Decode_Read_Data1, Pop_Data, PC_incremented : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        decode_UC_sig, decode_z_sig, execute_z_sig, zeroFlag, RET, Flushed : IN STD_LOGIC;
        --decode_z_sig: for branch predict ****** execute_z_sig : for pc 
        Final_PC : out std_logic_vector(31 downto 0);
        WrongState : out std_logic_vector(1 downto 0);
        PredictedBranch : out std_logic    
        );
    END component;
    
   component MemoryStage is
    port(
        clk: in STD_LOGIC;
        rst: in STD_LOGIC;

        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        UC: IN STD_LOGIC;
        PROTECT: IN STD_LOGIC;
        FREEsig: IN STD_LOGIC;
        WriteEnable : IN STD_LOGIC;
        readEnable : IN STD_LOGIC;

        ALUresult : IN signed(31 DOWNTO 0); 
        SPminus: IN std_logic;
        SPplus: IN std_logic;
        
        
        readData: OUT std_logic_vector(31 downto 0)
    );
END component;
signal reset_signalFD : std_logic;
signal reset_signalDE : std_logic;
signal reset_signalEM : std_logic;

    begin

        process(clk)
        begin
            if rising_edge(clk) then
                reset_signalFD <= rst or ResetFetchDecode_int;
            end if;
        end process;

        process(clk)
        begin
            if rising_edge(clk) then
                reset_signalDE <= rst or ResetDecodeExecute_int;
            end if;
        end process;

        process(clk)
        begin
            if rising_edge(clk) then
                reset_signalEM <= rst or ResetExecuteMemory_int;
            end if;
        end process;

        branch1: BranchFinal port map(
            clock => clk,
            reset => rst,
            Execute_Read_Data1 => outData1_int,
            Execute_Pc_incremented => PCexec,
            Decode_Read_Data1 => Data1_int,
            Pop_data => finaloutmemoryout,
            PC_incremented => PCorigin,
            decode_UC_signal => UC_inDE,
            decode_z_signal => Z,
            execute_z_signal => ZoutDE,
            zeroFlag => flagReg(3),
            decodeJMP => JMP,
            MemRET => MEM_RET_int,
            Final_PC => PC_int,
            ResetFetchDecode => ResetFetchDecode_int,
            ResetDecodeExecute => ResetDecodeExecute_int,
            ResetExecuteMemory => ResetExecuteMemory_int,
            ResetControl => ResetControl_int
        );

        fetch1: FetchStage Port map ( clk => clk,
        reset =>  reset_signalFD,
        Instruction => Instruction,
        PCout => PCorigin
        );

        opcode<=Instruction(15 downto 11);
        Rsrc1<=Instruction(10 downto 8);
        Rsrc2<=Instruction(7 downto 5);
        Rdst<=Instruction(4 downto 2);
        imm<=signed(Instruction(31 downto 16));


        controller1: controller port map(
        Reset =>  ResetControl_int,
        opCode => opcode,
        RegDist => Regdst_inDE,
        RegWrite1 => RegWrite1_inDE,
        RegWrite2 => RegWrite2_inDE,
        ALUsrc => alu_src_inDE,
        MemWrite => MemWrite_inDE,
        MemRead => MemRead_inDE,
        MemToReg => MemToReg,
        SPplus => SPplus_inDE,
        SPmin => SPmin_inDE,
        ALUselector => alu_sel_inDE,
        OUTenable => OUTenable_inDE,
        JMP => JMP,
        Z => Z,
        PROTECT => PROTECT_inDE,
        RET => RET,
        FlagEnable => flag_enable_inDE,
        UC => UC_inDE
        );


        decode1: decode port map(
            clk => clk,
            reset => rst,
            Rsrc1 => Rsrc1,
            Rsrc2 => Rsrc2,
            Rdst => REG_DSToutt,
            imm => imm,
            regWrite1 => FinalReg1Write,
            regWrite2 => FinalReg2Write,
            writeData1 => FinalWrittenData,
            writeData2 => (others =>'0'),
            regDst1 => Rdst,
            immExtended => immExtended_int,
            Data1 => Data1_int,
            Data2 => Data2_int,
            reg => Registers
        );

        outRegg: OUTREG port map (
        clk => clk,
        reset => rst,
        data_in => FinalWrittenData,
        data_out => outVal,
        enable => OUTenableFinal
      );

        decodeExecute1: DecodeExecute port map(
            clk => clk,
            rst =>  ResetDecodeExecute_int,
            PC => PC_int,
            data1 => Data1_int,
            data2 => Data2_int,
            Rsrc1 => Rsrc1,
            Rdst => Rdst,
            IMM => signed(immExtended_int),
            inPort => inPort,
            memtoregin=>MemToReg,
            Reg1Writein =>RegWrite1_inDE,
            Reg2Writein=>RegWrite2_inDE,
            Regdistin=>Regdst_inDE,
            aluSelectorin=>alu_sel_inDE,
        ALUsrcin=>alu_src_inDE,
        MemWriteIn=>MemWrite_inDE,
        MemReadIn=>MemRead_inDE,
        SPplus=>SPplus_inDE,
        SPmin=>SPmin_inDE,
        Outenable=>OUTenable_inDE,
        FlagEnablein=>flag_enable_inDE,
        Freein =>FREE_inDE,
        UCin=>UC_inDE,
        PROTECTEDin=> PROTECT_inDE,
        JMPin => JMP,
        Zin => Z,
        outPC => PC_int,
        outData1 => outData1_int,
        outData2 => outData2_int,
        outRsrc1 => outRsrc1_int,
        outRdst => outRdst_int,
        outIMM => outIMM_int,
        outInPort => outInPort_int,
        memtoregout =>RegMemoutDE,
        Reg1WriteOut=>Reg1WriteDE ,
        Reg2WriteOut =>Reg2WriteDE,
        Regdistout=>RegdistoutDE,
        aluSelectorout=>alu_sel_outDE,
        ALUsrcout=>alu_src_outDE,
        MemWriteout=>MemWrite_outDE,
        MemReadout=>MemRead_outDE,
        SPplusout=>SPplus_outDE,
        SPminout=>SPminus_outDE,
        OUTenableout=>OUTenable_outDE,
        FlagEnableout=>Flag_enable_outDE,
        Freeout=>Free_outDE,
        UCout=>UCout_outDE,
        PROTECTEDout=>PROTECTED_outDE,
        JMPoutp => JMPoutDE,
        Zout => ZoutDE
        );

        PCexec <= PC_int;

        alu_src_ex <= '0' & alu_src_outDE;
        execute1: Execute port map(
            clk => clk,
            reset =>  ResetExecuteMemory_int,
            A => signed(Data1_int),
            data2 => signed(Data2_int),
            imm => signed(outIMM_int),
            alu_sel =>  alu_sel_outDE,
            alu_src => alu_src_ex,
            flag_enable => Flag_enable_outDE,
            Output => outALUresult,
            flagReg => flagReg
        );
      flag<=flagReg;
        mux1: mux2bits generic map(3) port map(
            in0 => outRsrc1_int, 
            in1 => outRdst_int,
		    sel => RegdistoutDE,
		    out1 => RegDst_val
        );
        
        executeMemory1: ExecuteMemory port map(
        clk => clk,
        rst => rst,
        PC => PC_int,
        data1  => outData1_int,
        alu_result => outALUresult,
        flag => flagReg,
        RegDst => RegDst_val,
        inPort => outInPort_int, -- In Instruction
        RegMemin =>RegMemoutDE ,
        Reg1Writein =>Reg1WriteDE ,
        Reg2Writein =>Reg2WriteDE ,
        MemReadin =>MemRead_outDE ,
        MemWritein =>MemWrite_outDE ,
        Freein =>Free_outDE ,
        SPplusin =>SPplus_outDE ,
        SPminusin =>SPminus_outDE ,
        OUTenablein =>OUTenable_outDE ,
        UCin =>UCout_outDE ,
        PROTECTEDin =>PROTECTED_outDE ,
        outPC => PC_int,
        outWriteData => data1ToWB,
        outData1 => data1ToWB,
        outALUresult => ALUresultToWB, 
        outRegDst => WBRegDst,
        outInPort => outInPort_int,
        RegMemOut => RegMemoutEM,
        Reg1Writeout => reg1WriteEXMEM,
        Reg2Writeout => reg2WriteEXMEM,
        MemReadout=>MemRead_outEX,
        MemWriteout=>MemWrite_outEX,
        Freeout=>Free_outEX,
        SPplusout=>SPplus_outEX,
        SPminusout=>SPminus_outEX,
        OUTenableout=>OUTenable_outEX,
        UCout =>UC_outEX,
        PROTECTEDout=>PROTECTED_outEX
        );

        memory1: MemoryStage port map(
            clk => clk,
            rst => rst,
            PC => PC_int,
            WriteData => outData1_int,
            UC => UC_outEX,
            PROTECT => PROTECTED_outEX,
            FREEsig => FREE_outEX,
            WriteEnable => MemWrite_outEX,
            readEnable => MemRead_outEX,
            ALUresult => outALUresult, 
            SPminus => SPminus_outEX,
            SPplus => SPplus_outEX,
            readData => finaloutmemoryout
        );

    wb: WriteBackStage port Map(
        clk=> clk,
        rst=> rst,
        Data1in =>data1ToWB,
        Dataoutmemoryin=>(others=>'0'),
        ALU_resin=>std_logic_vector(AlUresultToWB),
        Reg_dstin=>WBRegDst,
        INin =>outInPort_int,
        MemtoRegin=>RegMemoutEM,
        Reg1Writein => reg1WriteEXMEM,
        Reg2Writein => reg2WriteEXMEM,
        OUTenablein =>OUTenable_outEX,
        Data1out => finalDataout,
        Dataoutmemoryout=> finaloutmemoryout ,
        Alu_resout => FinalALU,
        Reg_dstout => REG_DSToutt,
        INoutput => FinalIn,
        MemtoRegout =>RegMemoutMWB,
        Reg1Writeout =>FinalReg1Write,
        Reg2Writeout =>FinalReg2Write, 
        OUTenableout =>OUTenableFinal,
        ValueOut =>FinalWrittenData
    );  
    exception <= flagReg(2);
end Behavioral;
        