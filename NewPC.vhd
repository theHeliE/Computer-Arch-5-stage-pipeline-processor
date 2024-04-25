LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY NewPC IS
    PORT (
        clk, reset : IN STD_LOGIC;
        sel: in std_logic;
        counterout :OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END NewPC;

ARCHITECTURE pcMain OF NewPC IS
BEGIN
    PROCESS (clk, reset)
    VARIABLE internalCounter: std_logic_vector(31 downto 0):=(others=>'0');
    VARIABLE sid:std_logic:='0';
    BEGIN
        IF reset='1' THEN
            internalcounter := (OTHERS => '0');
             counterout<=internalcounter;
        ELSIF rising_edge(clk)  THEN
             if sid ='1' then
             internalcounter:=std_logic_vector(unsigned(internalcounter)+2);
             else
             internalcounter:=std_logic_vector(unsigned(internalcounter)+1);
             end if;
             counterout<=internalcounter;
         ELSIF falling_edge(clk) then
              sid:=sel;
        END IF;              
   END PROCESS;
END pcMain;

