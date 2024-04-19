library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port (
        A : in  signed(31 downto 0);
        B : in  signed(31 downto 0);
        sel : in  std_logic_vector(3 downto 0);
        Output : out signed(31 downto 0)
    );
end entity ALU;

architecture Behavioral of ALU is
begin
    with sel select
        Output <=
            A or B when "0000",
            not A when "0001",
            A - B when "0010",
            A - 1 when "0011",
            A when "0100",
            B when "0101",
            (others => '0') when others;
end architecture Behavioral;
