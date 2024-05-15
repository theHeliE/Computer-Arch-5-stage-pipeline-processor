LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY dataMem IS
	PORT(
		clk              : IN std_logic;
        rst              : IN std_logic;
        readEnable       : IN std_logic;
        readAddress      : IN  std_logic_vector(31 DOWNTO 0);
		writeEnable      : IN std_logic;
		writeAddress     : IN  std_logic_vector(31 DOWNTO 0);
		writeData        : IN  std_logic_vector(31 DOWNTO 0);
		readData         : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY dataMem;

ARCHITECTURE archMem OF dataMem IS

	TYPE ram_type IS ARRAY(0 TO (2**12)-1) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		PROCESS(clk,rst) IS
			BEGIN
                IF rst = '1' THEN
                    ram <= (OTHERS => (OTHERS => '0'));
				ELSIF rising_edge(clk) AND writeEnable = '1' THEN 
						ram(to_integer(unsigned(writeAddress))) <= writeData(15 downto 0);
                        ram(to_integer(unsigned(writeAddress)+1)) <= writeData(31 downto 16);
				END IF;
		END PROCESS;
		readData(15 downto 0) <= ram(to_integer(unsigned(readAddress))) WHEN readEnable = '1' 
        ELSE (OTHERS => '0');
        readData(31 downto 16) <= ram(to_integer(unsigned(readAddress)+1)) WHEN readEnable = '1' 
        ELSE (OTHERS => '0');
END archMem;

