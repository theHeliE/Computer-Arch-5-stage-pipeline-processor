LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity thirtytwobitsadder is
generic (n: integer:=32);
port (
A,B :IN std_logic_vector(n-1 DOWNTO 0);
Cin:in std_logic;
F: OUT std_logic_vector (n-1 DOWNTO 0);
Cout: out std_logic
);
end entity;

architecture archh of thirtytwobitsadder is
Component my_nadder IS
    generic (n: integer := 2);
	PORT (a,b : IN  std_logic_vector(n-1 downto 0);
          cin : in std_logic;
		  s : out std_logic_vector(n-1 downto 0);
           cout : OUT std_logic );
END Component;
Component  select_adder IS
    generic (n: integer := 2);
	PORT (a,b : IN  std_logic_vector(n-1 downto 0);
          cin : in std_logic;
		  s : out std_logic_vector(n-1 downto 0);
           cout : OUT std_logic );
END Component;
SIGNAL Carry: std_logic_vector (n/2 DOWNTO 0);
begin
Carry(0)<=Cin;
First2bits:my_nadder generic map(2) PORT MAP(A(1 DOWNTO 0),B(1 DOWNTO 0),Carry(0),F(1 DOWNTO 0),Carry(1));
loop1: for i in 1 to (n/2)-1 generate
            fx:select_adder port map(A(2*i+1 DOWNTO 2*i),B(2*i+1 DOWNTO 2*i),Carry(i),F(2*i+1 DOWNTO 2*i),Carry(i+1));
        end generate;
		Cout <= Carry(n/2);
end archh;
