library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
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
end entity ALU;

architecture Behavioral of ALU is
    signal alu_output_int : signed(31 downto 0);
begin
    with sel select
    alu_output_int <=
            A or B when "0000",
            not A when "0001",
            A - B when "0010",
            A - 1 when "0011",
            A when "0100",
            B when "0101",
            A + B when "0110",
            A + 1 when "0111",
            (others => '0') when others;
        carry <= '1' when (sel="0110" and ((A >= 0 and B > to_signed(2147483647, 32) - A) or
            (B >= 0 and A > to_signed(2147483647, 32) - B))) or
            (sel="0010" and unsigned(A) < unsigned(B)) or (sel="0111" and ((A >= 0 and A > to_signed(2147483647, 32) - 1))) else '0';
        zero <= '1' when alu_output_int = "00000000000000000000000000000000" else '0';
        overflow <= '1' when ((A(31) = B(31)) and (A(31) /= alu_output_int(31))) else '0';       
        negative <= alu_output_int(31);
        alu_output <= alu_output_int;
end architecture Behavioral;

