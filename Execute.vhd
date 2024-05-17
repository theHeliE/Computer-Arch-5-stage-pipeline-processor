Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity Execute is
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
end entity;

Architecture ar of Execute is
    component ALU_CCR_Integeration is 
    port(
        reset: in std_logic;
        A,B: in signed(31 downto 0);
        ALU_out: out signed(31 downto 0);
        sel: in std_logic_vector(3 downto 0);
        flag_enable: in std_logic;
        zero_flag : out std_logic;
        carry_flag : out std_logic;
        overflow_flag : out std_logic;
        negative_flag : out std_logic
);
end component;

component int_mux_generic is
Generic ( n : Integer:=32);
PORT ( 
    in0,in1,in2,in3 : IN signed (n-1 DOWNTO 0);
    sel : IN  std_logic_vector (1 DOWNTO 0);
	out1 : OUT signed (n-1 DOWNTO 0)
);
end component;

    signal alu_result : signed(31 downto 0);
    SIGNAL alu_flag : std_logic_vector(3 downto 0);
    signal src2 : signed(31 downto 0);
    begin
        mux1: int_mux_generic generic map (32) port map(
            in0 => data2,
            in1 => imm,
            in2 => to_signed(0, 32),
            in3 => to_signed(0, 32),
            sel => alu_src,
            out1 => src2
        );

        add: ALU_CCR_Integeration port map(
            reset => reset,
            A => A,
            B => src2,
            ALU_out => alu_result,
            sel => alu_sel,
            flag_enable => flag_enable,
            zero_flag => alu_flag(3),
            carry_flag => alu_flag(0),
            overflow_flag => alu_flag(1),
            negative_flag => alu_flag(2)
        );


    Output<=alu_result;
    flagReg<=alu_flag;
    end ar;
