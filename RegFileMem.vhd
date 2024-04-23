LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE memregisterfile_pkg IS
    TYPE vector_array IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
END memregisterfile_pkg;

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
USE work.memregisterfile_pkg.ALL;

ENTITY RegFileMem IS
    PORT (
        clk : IN STD_LOGIC;
        read1enable : IN STD_LOGIC;
        read2enable : IN STD_LOGIC;
        write1enable : IN STD_LOGIC;
        write2enable : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        addressread1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        addressread2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        addresswrite1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        addresswrite2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write1,write2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        read1,read2: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        registers : OUT vector_array
    );
END RegFileMem;

ARCHITECTURE memRegMain OF RegFileMem IS
    SIGNAL memory : vector_array := (OTHERS => (OTHERS => '0'));

BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            memory <= (OTHERS => (OTHERS => '0'));
        ELSE
            IF rising_edge(clk) THEN
                IF write1enable = '1' THEN
                    memory(to_integer(unsigned(addresswrite1))) <= write1;
                END IF;

                IF write2enable = '1' THEN
                    memory(to_integer(unsigned(addresswrite2))) <= write2;
                END IF;
            ELSIF falling_edge(clk) THEN
                IF read1enable = '1' THEN
                    read1 <= memory(to_integer(unsigned(addressread1)));
                END IF;

                IF read2enable = '1' THEN
                    read2 <= memory(to_integer(unsigned(addressread2)));
                END IF;
            END IF;
        END IF;
    END PROCESS;
    registers <= memory;
END memRegMain;
