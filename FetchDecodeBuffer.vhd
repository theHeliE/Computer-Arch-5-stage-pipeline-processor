library ieee;
use ieee.std_logic_1164.all;

entity fetchDecodeBuffer is
    port (
        clk : in std_logic;
        reset : in std_logic;
        instructionin : in std_logic_vector(15 downto 0);
        externalBuffer: out std_logic_vector(31 downto 0)
    );
end entity fetchDecodeBuffer;

architecture fdb of fetchDecodeBuffer is 
SIGNAL firstBuffer: std_logic_vector(15 downto 0):=(others=>'0');
SIGNAL secondBuffer: std_logic_vector(15 downto 0):=(others=>'0');
begin
process (clk)
VARIABLE secondBufferUpdated:boolean :=false;
begin
    if rising_edge(clk) then
        if reset = '1' then
            externalbuffer <= (others => '0');
            secondBufferUpdated := false;
        elsif (reset='0' or falling_edge(reset)) then
            if secondBufferUpdated then
                externalBuffer <= firstBuffer & secondBuffer;
                secondBufferUpdated := false;
            end if;
            firstBuffer <= instructionin; 
        end if;
    elsif falling_edge(clk) then
      if reset = '1' then
            externalbuffer <= (others => '0');
            secondBufferUpdated := false;
        elsif (reset='0' or falling_edge(reset)) then
        secondBuffer <= instructionin;
        secondBufferUpdated := true;
     end if;
    end if;
end process;
end fdb;
    

