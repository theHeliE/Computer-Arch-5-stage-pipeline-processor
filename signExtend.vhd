library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity signExtend is
    port (
        imm16 : in signed(15 downto 0);
        imm32 : out signed(31 downto 0)
    );
end entity signExtend;

architecture Behavioral of signExtend is
begin
    imm32 <= resize(imm16, 32);
end architecture Behavioral;