Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

Entity WriteBackStage is Port(
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
        Data1out: out std_logic_vector(31 downto 0);
        Dataoutmemoryout: out std_logic_vector(31 downto 0);
        Alu_resout: out std_logic_vector(31 downto 0);
        Reg_dstout: out std_logic_vector(2 downto 0);
        INoutput : out std_logic_vector (31 downto 0);
        MemtoRegout:out std_logic_vector(1 downto 0);
        Reg1Writeout: out std_logic;
        Reg2Writeout:out std_logic;  
        ValueOut: out std_logic_vector(31 downto 0)
);
End WriteBackStage;

Architecture wbs of WriteBackStage is
component MemoryWriteBack is
    Port(
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
        Data1out: out std_logic_vector(31 downto 0);
        Dataoutmemoryout: out std_logic_vector(31 downto 0);
        Alu_resout: out std_logic_vector(31 downto 0);
        Reg_dstout: out std_logic_vector(2 downto 0);
        INoutput : out std_logic_vector (31 downto 0);
        MemtoRegout:out std_logic_vector(1 downto 0);
        Reg1Writeout: out std_logic;
        Reg2Writeout:out std_logic
    );
    END component;
    component  mux_generic IS 
	Generic ( n : Integer:=32);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END component;
SIGNAL dataoutmem:std_logic_vector(31 downto 0);
SIGNAL aluresult:std_logic_vector(31 downto 0);
SIGNAL Inoutp:std_logic_vector(31 downto 0);
SIGNAL MemtoRegister:std_logic_vector(1 downto 0);
begin
    MemoryWriteBack1: MemoryWriteBack port map(
        clk => clk,
        rst => rst,
        Data1in => Data1in,
        Dataoutmemoryin => Dataoutmemoryin,
        ALU_resin => ALU_resin,
        Reg_dstin => Reg_dstin,
        INin => INin,
        MemtoRegin => MemtoRegin,
        Reg1Writein => Reg1Writein,
        Reg2Writein => Reg2Writein,
        Data1out => Data1out,
        Dataoutmemoryout => dataoutmem,
        Alu_resout => aluresult,
        Reg_dstout => Reg_dstout,
        INoutput => INoutp,
        MemtoRegout => MemtoRegister,
        Reg1Writeout => Reg1Writeout,
        Reg2Writeout => Reg2Writeout
    );
mu: mux_generic GENERIC MAP(32) PORT MAP(
in0=>aluresult,
in1=>dataoutmem,
in2=>Inoutp,
in3=>(others=>'0'),
sel=>MemtoRegister,
out1=>Valueout
);
Dataoutmemoryout<=dataoutmem;
ALU_resout<=aluresult;
INoutput<=Inoutp;
MemtoRegout<=MemtoRegister;
end wbs;
