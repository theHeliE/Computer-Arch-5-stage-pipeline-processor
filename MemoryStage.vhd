Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity MemoryStage is
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
end entity;

architecture archMemory of MemoryStage is

    component SP is port (
        clk : in std_logic;
        rst : in std_logic;
        add : in std_logic_vector(2 downto 0); --can be 2, 0 or -2

        SPnew  : out std_logic_vector(31 downto 0); --SP
        SPold  : out std_logic_vector(31 downto 0) --SPold
    );
    end component;

    component mux2bits IS 
        Generic ( n : Integer:=32);
        PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
            sel : IN  std_logic;
            out1 : OUT std_logic_vector (n-1 DOWNTO 0));
    end component;

    component mux_generic IS 
	Generic ( n : Integer:=32);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
    END component;

    component dataMem IS
	PORT(
		clk              : IN std_logic;
        rst              : IN std_logic;
        readEnable       : IN std_logic;
        readAddress      : IN  std_logic_vector(31 DOWNTO 0);
		writeEnable      : IN std_logic;
		writeAddress     : IN  std_logic_vector(31 DOWNTO 0);
		writeData        : IN  std_logic_vector(31 DOWNTO 0);
		protectSignal 	 : IN std_logic;
		freeSignal       : IN std_logic;
		readData         : OUT std_logic_vector(31 DOWNTO 0));
    END component;
    signal MemAddress : std_logic_vector(31 DOWNTO 0):=(others=>'0'); 
    signal SPnew_int :  std_logic_vector(31 DOWNTO 0):=(others=>'0');
    signal SPold_int :  std_logic_vector(31 DOWNTO 0):=(others=>'0');
    signal add_int   :  std_logic_vector(2 downto 0):=(others=>'0');
    signal alu_result_int :  signed(31 DOWNTO 0):=(others=>'0');
    signal selection_option : std_logic_Vector(1 downto 0):=(others=>'0');
begin
    alu_result_int <= ALUresult;
    selection_option(0)<=SPplus;
    selection_option(1)<=SPminus;
    mux1: mux_generic generic map(3) port map(
        in0 => "000",
        in1 => "010",
        in2 => "110",
        in3 => "000",
        sel => selection_option,
        out1 => add_int
    ); 
    sp1: SP port map(
        clk => clk,
        rst => rst,
        add => add_int,
        SPnew => SPnew_int,
        SPold => SPold_int
    );
    mux2: mux_generic generic map(32) port map(
        in0=> std_logic_vector(alu_result_int),
        in1=>SPold_int,
        in2=>SPnew_int,
        in3=>(others=>'0'),
        sel=>selection_option,
        out1 =>MemAddress
    );
     datamemory : datamem port map(
        clk => clk,
        rst => rst,
        readEnable => readEnable,
        readAddress => MemAddress,
        writeEnable => writeEnable,
        writeAddress => MemAddress,
        writeData => WriteData,
        protectSignal => PROTECT,
        freeSignal => FREEsig,
        readData => readData
     );
end archMemory;