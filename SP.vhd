Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity SP is
    port(
        clk : in std_logic;
        rst : in std_logic;
        add : in std_logic_vector(2 downto 0); --can be 2, 0 or -2

        SPnew  : out std_logic_vector(31 downto 0); --SP
        SPold  : out std_logic_vector(31 downto 0) --SPold
    );
end entity SP;

architecture behavioral of SP is
    begin
        process(clk, rst)
        variable SPtemp : std_logic_vector(31 downto 0);
        variable SP     : std_logic_vector(31 downto 0);
        begin
            if rst = '1' then
                SPnew <="00000000000000000000111111111111";
                SPold <="00000000000000000000111111111111";
                SP := "00000000000000000000111111111111";
                SPtemp := "00000000000000000000111111111111";
            elsif rising_edge(clk) then
                    SP := SPtemp;
                    SPtemp := std_logic_vector(signed(SP) + signed(add));
                    SPnew<=SPtemp;
                    SPold <=SP;
            end if;
        end process;
end architecture;

