library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CCR is
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
end entity ;

architecture Behavioral of CCR is
component thirtytwobitadder is generic (n: integer:=32);
port (
A,B :IN std_logic_vector(n-1 DOWNTO 0);
Cin:in std_logic;
F: OUT std_logic_vector (n-1 DOWNTO 0);
Cout: out std_logic
);
end component;
    signal zero_flag_internal : std_logic;
    signal carry_flag_internal : std_logic;
    signal overflow_flag_internal : std_logic;
    signal negative_flag_internal : std_logic;
    signal TestAdd:std_logic_vector(31 downto 0);
    signal TestCarry:std_logic;
begin
    adds: thirtytwobitadder port map (std_logic_vector(alu_op1), std_logic_vector(alu_op2), '0', TestAdd, TestCarry);
    process (reset, alu_res, alu_op1, alu_op2)
    begin
        if reset = '1' then
            zero_flag_internal <= '0';
            carry_flag_internal <= '0';
            overflow_flag_internal <= '0';
            negative_flag_internal <= '0';
        else
            zero_flag_internal<= alu_zero;
            carry_flag_internal<=alu_carry;
            overflow_flag_internal <= alu_overflow;
            negative_flag_internal<=alu_negative;
        end if;
    end process;

    zero_flag <= zero_flag_internal;
    carry_flag <= carry_flag_internal;
    overflow_flag <= overflow_flag_internal;
    negative_flag <= negative_flag_internal;
end architecture Behavioral;