Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity Execute is
    port(
        clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        A,B:in signed(31 downto 0);
        sel:in std_logic_vector(3 downto 0);
        Output:out signed(31 downto 0);
        zeroflag:out std_logic;
        carryflag:out std_logic;
        overflowflag:out std_logic;
        negativeflag:out std_logic
    );
end entity;

Architecture ar of Execute is
    component ALU is
        port(
            A,B:in signed(31 downto 0);
            sel:in std_logic_vector(3 downto 0);
            Output:out signed(31 downto 0)
        );
    end component;
    component CCR is 
    port( 
        reset : in std_logic;
        alu_res : in std_logic_vector(31 downto 0);
        zero_flag : out std_logic;
        carry_flag : out std_logic;
        overflow_flag : out std_logic;
        negative_flag : out std_logic
    );
    end component;
    signal alu_result : signed(31 downto 0);
    SIGNAL alu_R:std_logic_vector(31 downto 0);
    begin
    add:ALU port map(A,B,sel,alu_result);
    alu_R<=std_logic_vector(alu_result);
    ccrr:CCR port map(reset,std_logic_vector(alu_result),zeroflag,carryflag,overflowflag,negativeflag);
    Output<=alu_result;
    end ar;
