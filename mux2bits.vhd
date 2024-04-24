LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux2bits IS 
	Generic ( n : Integer:=32);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
		sel : IN  std_logic;
		out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END mux2bits;


ARCHITECTURE with_select_mux OF mux2bits is
	BEGIN	
with Sel select
	out1 <= in0 when '0',
		in1 when others;
END with_select_mux;

 --SIGNAL bus : bit_vector(0 TO 7) := (4=>'1', OTHERS=>'0');  -- default value 
		-- of "bus" is B"0000_1000"
