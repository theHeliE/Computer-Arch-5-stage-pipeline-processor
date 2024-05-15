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

        WriteEnable : IN STD_LOGIC;
        readEnable : IN STD_LOGIC;

        ALUresult : IN signed(31 DOWNTO 0); 
        SPold : IN std_logic_vector(31 DOWNTO 0);
        SPnew : IN std_logic_vector(31 DOWNTO 0);
        SPminus: IN std_logic;
        SPplus: IN std_logic;
        
        
        readData: OUT std_logic_vector(31 downto 0)
    );
end entity;

architecture archMemory of MemoryStage is
    signal readAddress : std_logic_vector(31 DOWNTO 0); 
    signal writeAddress : std_logic_vector(31 DOWNTO 0);

    signal SPnew_int : IN std_logic_vector(31 DOWNTO 0);
    signal SPold_int : IN std_logic_vector(31 DOWNTO 0);
    signal add_int   : IN std_logic_vector(2 downto 0);
    signal alu_result_int : IN std_logic_vector(31 DOWNTO 0);

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
		readData         : OUT std_logic_vector(31 DOWNTO 0));
    END component;
begin
    SPnew_int <= SPnew;
    SPold_int <= SPold;
    alu_result_int <= alu_result;
    add_int <= add;
    
    mux1: mux_generic generic map(3) port map(
        in0 => SPold_int,
        in1 => SPnew_int,
        in2 => alu_result_int,
        in3 => to_signed(0,32),
        sel => SPminus & SPplus,
        out1 => add_int
    );
    sp: SP port map(
        clk => clk,
        rst => rst,
        add => "000",
        SPnew => SPnew_int,
        SPold => SPold_int
    );
    
end archMemory;