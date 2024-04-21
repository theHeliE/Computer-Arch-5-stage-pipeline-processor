library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_CCR_Integeration is port(
    reset: in std_logic;
    A, B: in signed(31 downto 0);
    ALU_out: out signed(31 downto 0);
    sel: in std_logic_vector(3 downto 0);
    zero_flag : out std_logic;
    carry_flag : out std_logic;
    overflow_flag : out std_logic;
    negative_flag : out std_logic
);
end entity;

architecture alu_ccr_arch of ALU_CCR_Integeration is
    component ALU is
        port (
            A : in  signed(31 downto 0);
            B : in  signed(31 downto 0);
            sel : in  std_logic_vector(3 downto 0);
            alu_output : out signed(31 downto 0);
            carry: out std_logic;
            zero: out std_logic;
            overflow: out std_logic;
            negative: out std_logic
        );
    end component;

    component CCR is
        port (
            reset : in std_logic;
            alu_res : in signed(31 downto 0);
            alu_op1:in signed(31 downto 0);
            alu_op2:in signed(31 downto 0);
            alu_carry: in std_logic;
            alu_zero: in std_logic;
            alu_overflow: in std_logic;
            alu_negative: in std_logic;
            zero_flag : out std_logic;
            carry_flag : out std_logic;
            overflow_flag : out std_logic;
            negative_flag : out std_logic
        );
    end component;

    signal ALU_out_int : signed(31 downto 0);
    signal carry_int, zero_int, overflow_int, negative_int : std_logic;
    begin
        ALU1: ALU port map(A, B, sel, ALU_out_int, carry_int, zero_int, overflow_int, negative_int);
        CCR1: CCR port map(reset, ALU_out_int, A, B, carry_int, zero_int, overflow_int, negative_int, zero_flag, carry_flag, overflow_flag, negative_flag);
        ALU_out <= ALU_out_int;
end architecture alu_ccr_arch;
