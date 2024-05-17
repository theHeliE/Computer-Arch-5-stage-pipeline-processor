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
    signal alu_output_int : signed(32 downto 0);
begin
    with sel select
    alu_output_int <=
            ('0' & A) or ('0' & B) when "0000",
            not ('0' & A) when "0001",
            ('0' & A) and ('0' & B) when "0010",
            ('0' & A) xor ('0' & B) when "0011",
            ('0' & A) - ('0' & B) when "0100",
            ('0' & A) - 1 when "0101",
            ('0' & A) when "0110",
            ('0' & B) when "0111",
            ('0' & A) + ('0' & B) when "1000",
            ('0' & A) + 1 when "1001",
            0 - ('0' & A) when "1010",
            (others => '0') when others;
            carry <= alu_output_int(32);
        -- carry <= '1' when (sel="1000" and ((A >= 0 and B > to_signed(2147483647, 32) - A) or
        --     (B >= 0 and A > to_signed(2147483647, 32) - B))) or
        --     (sel="0100" and unsigned(A) < unsigned(B)) or (sel="1001" and ((A >= 0 and A > to_signed(2147483647, 32) - 1))) or (sel="0100" and unsigned(A) <    1) or sel="1010" else '0';
        zero <= '1' when alu_output_int = "00000000000000000000000000000000" else '0';
        overflow <= '1' when ((A(A'high) = B(B'high)) and (A(A'high) /= alu_output_int(31))) else '0';       
        negative <= alu_output_int(31);
        alu_output <= alu_output_int(31 downto 0);
end architecture Behavioral;
