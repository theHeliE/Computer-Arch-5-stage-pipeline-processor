LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY controller IS
    PORT (
	Reset : IN STD_LOGIC;
        opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        RegDist : OUT STD_LOGIC;
	RegWrite1 : OUT STD_LOGIC;
	RegWrite2 : OUT STD_LOGIC;
	ALUsrc : OUT STD_LOGIC;
	MemWrite : OUT STD_LOGIC;
	MemRead : OUT STD_LOGIC;
	MemToReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	SPplus : OUT STD_LOGIC;
	SPmin : OUT STD_LOGIC; 
        ALUselector : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        OUTenable : OUT STD_LOGIC;
	JMP : OUT STD_LOGIC;
	Z : OUT STD_LOGIC;
	PROTECT : OUT STD_LOGIC;
	RET : OUT STD_LOGIC;
	FlagEnable : OUT STD_LOGIC
    );
END controller;

ARCHITECTURE controllerMain OF controller IS
BEGIN
    aluSelector <= "0000" WHEN Reset = '1' ELSE
	"0000" WHEN opCode = "00000" ELSE --NOP
        "0001" WHEN opCode = "00001" ELSE --NOT
	"1010" WHEN opCode = "00010" ELSE --NEG
	"1001" WHEN opCode = "00011" ELSE --INC
	"0101" WHEN opCode = "00100" ELSE --DEC	
	"0110" WHEN opCode = "00101" ELSE --OUT	
	"0110" WHEN opCode = "00111" ELSE --MOV	
	"0111" WHEN opCode = "01000" ELSE --SWAP	
	"1000" WHEN opCode = "01001" ELSE --ADD
	"1000" WHEN opCode = "01010" ELSE --ADDI
	"0100" WHEN opCode = "01011" ELSE --SUB	
	"0100" WHEN opCode = "01100" ELSE --SUBI
	"0010" WHEN opCode = "01101" ELSE --AND	
	"0000" WHEN opCode = "01110" ELSE --OR	
	"0011" WHEN opCode = "01111" ELSE --XOR	
	"0100" WHEN opCode = "10000" ELSE --CMP	
	"1000" WHEN opCode = "10100" ELSE --LDD	
	"1000" WHEN opCode = "10101"; --STD	


RegDist <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "00110" ELSE --IN	
	'1' WHEN opCode = "00111" ELSE --MOV	
	'1' WHEN opCode = "01001" ELSE --ADD
	'1' WHEN opCode = "01010" ELSE --ADDI
	'1' WHEN opCode = "01011" ELSE --SUB	
	'1' WHEN opCode = "01100" ELSE --SUBI
	'1' WHEN opCode = "01101" ELSE --AND	
	'1' WHEN opCode = "01110" ELSE --OR	
	'1' WHEN opCode = "01111" ELSE --XOR	
	'1' WHEN opCode = "10010" ELSE --POP	
	'1' WHEN opCode = "10011" ELSE --LDM	
	'1' WHEN opCode = "10100" ELSE --LDD	
	'0';

RegWrite1 <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "00001" ELSE --NOT
	'1' WHEN opCode = "00010" ELSE --NEG
	'1' WHEN opCode = "00011" ELSE --INC
	'1' WHEN opCode = "00100" ELSE --DEC	
	'1' WHEN opCode = "00110" ELSE --IN	
	'1' WHEN opCode = "00111" ELSE --MOV	
	'1' WHEN opCode = "01000" ELSE --SWAP	
	'1' WHEN opCode = "01001" ELSE --ADD
	'1' WHEN opCode = "01010" ELSE --ADDI
	'1' WHEN opCode = "01011" ELSE --SUB	
	'1' WHEN opCode = "01100" ELSE --SUBI
	'1' WHEN opCode = "01101" ELSE --AND	
	'1' WHEN opCode = "01110" ELSE --OR	
	'1' WHEN opCode = "01111" ELSE --XOR	
	'1' WHEN opCode = "10010" ELSE --POP	
	'1' WHEN opCode = "10011" ELSE --LDM	
	'1' WHEN opCode = "10100" ELSE --LDD	
	'0';

RegWrite2 <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "00101" --OUT	
	ELSE '0' ;

ALUsrc <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "01010" ELSE --ADDI
	'1' WHEN opCode = "01100" ELSE --SUBI
	'1' WHEN opCode = "10100" ELSE --LDD	
	'1' WHEN opCode = "10101" ELSE --STD
        '0';	

MemWrite <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "10001" ELSE --PUSH
	'1' WHEN opCode = "10101" ELSE --STD		
	'1' WHEN opCode = "11010" ELSE --CALL	
	'0';

MemRead <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "10010" ELSE --POP	
	'1' WHEN opCode = "10011" ELSE --LDM	
	'1' WHEN opCode = "10100" ELSE --LDD	
	'1' WHEN opCode = "11011" ELSE --RET	
	'1' WHEN opCode = "11100" ELSE --RTI	
	'0';

MemToReg <= "00" WHEN Reset = '1' ELSE
	"10" WHEN opCode = "00110" ELSE --IN	
	"01" WHEN opCode = "10010" ELSE --POP	
	"01" WHEN opCode = "10011" ELSE --LDM	
	"01" WHEN opCode = "10100" ELSE --LDD	
	"00";

SPplus <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "10010" ELSE --POP	
	'1' WHEN opCode = "11011" ELSE --RET	
	'1' WHEN opCode = "11100" ELSE --RTI
	'0';

SPmin <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "10001" ELSE --PUSH	
	'1' WHEN opCode = "11010" ELSE --CALL	
	'0';

OUTenable <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "00101" ELSE --OUT	
	'0';

JMP <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "11000" ELSE --JZ	
	'1' WHEN opCode = "11001" ELSE --JMP	
	'1' WHEN opCode = "11010" ELSE --CALL	
	'1' WHEN opCode = "11011" ELSE --RET	
	'1' WHEN opCode = "11100" ELSE --RTI	
	'0';

Z <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "11000" ELSE --JZ	
	'0';

PROTECT <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "10110" ELSE --PROTECT 	
	'0';

RET <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "11011" ELSE --RET	
	'1' WHEN opCode = "11100" ELSE --RTI	
	'0';

FlagEnable <= '0' WHEN Reset = '1' ELSE
	'1' WHEN opCode = "00001" ELSE --NOT
	'1' WHEN opCode = "00010" ELSE --NEG
	'1' WHEN opCode = "00011" ELSE --INC
	'1' WHEN opCode = "00100" ELSE --DEC	
	'1' WHEN opCode = "01001" ELSE --ADD
	'1' WHEN opCode = "01010" ELSE --ADDI
	'1' WHEN opCode = "01011" ELSE --SUB	
	'1' WHEN opCode = "01100" ELSE --SUBI
	'1' WHEN opCode = "01101" ELSE --AND	
	'1' WHEN opCode = "01110" ELSE --OR	
	'1' WHEN opCode = "01111" ELSE --XOR	
	'1' WHEN opCode = "10000" ELSE --CMP	
	'1' WHEN opCode = "11100" ELSE --RTI	
	'0';


END controllerMain;