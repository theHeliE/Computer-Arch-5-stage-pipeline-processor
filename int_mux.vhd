LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY int_mux_generic IS 
	Generic ( n : Integer:=32);
	PORT ( in0,in1,in2,in3 : IN signed (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT signed (n-1 DOWNTO 0));
END int_mux_generic;


ARCHITECTURE when_else_int_mux OF int_mux_generic is
	BEGIN
		
  out1 <= 	in0 when sel = "00"
	else	in1 when sel = "01"
	else	in2 when sel = "10"
	else 	in3; 
END when_else_int_mux;


ARCHITECTURE with_select_int_mux OF int_mux_generic is
	BEGIN
		
with Sel select
	out1 <= in0 when "00",
		in1 when "01",
		in2 when "10",
		in3 when others;
END with_select_int_mux;

 --SIGNAL bus : bit_vector(0 TO 7) := (4=>'1', OTHERS=>'0');  -- default value 
		-- of "bus" is B"0000_1000"