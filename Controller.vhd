LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY controller IS
    PORT (
        opCode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        aluSelector : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        aluCin : OUT STD_LOGIC;
        writeEnable : OUT STD_LOGIC
    );
END controller;

ARCHITECTURE controllerMain OF controller IS
BEGIN
    aluSelector <= "0110" WHEN opCode = "101" ELSE
        "0000" WHEN opCode = "001"-- cin = 1
        ELSE
        "----";

    aluCin <= '1' WHEN opCode = "001" ELSE
        '0';

    writeEnable <= '1' WHEN opCode = "001" OR opCode = "101" ELSE
        '0';

END controllerMain;
