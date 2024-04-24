library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
ENTITY InstructionCache IS
    PORT(
        clk : IN std_logic;
        reset: IN std_logic;
        address : IN  std_logic_vector(31 DOWNTO 0);
        instruction : OUT std_logic_vector(15 DOWNTO 0)
		);
END ENTITY ;

ARCHITECTURE Cachemem OF InstructionCache IS
    TYPE ram_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
    SIGNAL ram : ram_type:=(others=>(others=>'0')) ;
    CONSTANT firstaddress: std_logic_vector(31 downto 0):=(others=>'0');
BEGIN
    PROCESS(reset,address) IS
    VARIABLE inst:std_logic_vector(15 downto 0):=(others=>'0');
    BEGIN
       if reset ='1'  then
          inst:=ram(to_integer(unsigned(firstaddress)));
          instruction<=inst;
        else
          inst:=ram(to_integer(unsigned(address)));
          instruction<=inst;
        END IF;
    END PROCESS; 
END Cachemem;