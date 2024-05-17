Library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY MemoryWriteBack is
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
        OUTenablein : in std_logic;
        Data1out: out std_logic_vector(31 downto 0);
        Dataoutmemoryout: out std_logic_vector(31 downto 0);
        Alu_resout: out std_logic_vector(31 downto 0);
        Reg_dstout: out std_logic_vector(2 downto 0);
        INoutput : out std_logic_vector (31 downto 0);
        MemtoRegout:out std_logic_vector(1 downto 0);
        Reg1Writeout: out std_logic;
        Reg2Writeout:out std_logic;
        OUTenableout: out std_logic
    );
    END MemoryWriteBack;

    Architecture MemWB of MemoryWriteBack is
    begin
    PROCESS(clk,rst)
    begin
        if rst='1'then
            Data1out<=(others=>'0');
            Dataoutmemoryout<=(others=>'0');
            Alu_resout<=(others=>'0');
            Reg_dstout<=(others=>'0');
            Inoutput<=(others=>'0');
            MemtoRegout<=(others=>'0');
            Reg1Writeout<='0';
            Reg2Writeout<='0'; 
            OUTenableout<='0';
        elsif falling_edge(clk) then
            Data1out<=Data1in;
            Dataoutmemoryout<=Dataoutmemoryin;
            Alu_resout<=Alu_resin;
            Reg_dstout<=Reg_dstin;
            Inoutput<=Inin;
            MemtoRegout<=MemtoRegin;
            Reg1Writeout<=Reg1Writein;
            Reg2Writeout<=Reg2Writein;
            OUTenableout<=OUTenablein;
       end if;
       end process;
       end architecture;
