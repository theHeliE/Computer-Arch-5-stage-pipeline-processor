LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY BranchPredict IS
 PORT (reset, z_signal : IN STD_LOGIC; --z_signal indicates a JZ instruction in execute stage, acts as enable here
       zero_flag : IN STD_LOGIC; --changes the state
       branch_state : OUT STD_LOGIC; --0 -> untaken, 1 -> taken 
       prediction_actual_state : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)); --01 -> prediction was untaken, wrong   10 -> prediction was taken, wrong
       --prediction_actual_state is used to control which instruction goes to the pc
       END ENTITY BranchPredict;

ARCHITECTURE BranchArch OF BranchPredict IS
    TYPE state_type IS (s0, s1);
    SIGNAL state : state_type;
BEGIN
state_process : PROCESS (reset, z_signal)
BEGIN
    IF reset = '1' THEN
        state <= s0;
    ELSIF z_signal='1' THEN
        CASE state IS
            WHEN s0 =>
                IF zero_flag = '1' THEN
                    state <= s1;
                ELSE
                    state <= s0;
                END IF;
            WHEN s1 =>
                IF zero_flag = '0' THEN
                    state <= s0;
                ELSE
                    state <= s1;
                END IF;
            WHEN OTHERS =>
                state <= s0;
        END CASE; 
    END IF;
END PROCESS state_process;

output_process : PROCESS (state,zero_flag)
BEGIN
    CASE state IS
        WHEN s0 =>
            if zero_flag = '1' then
                prediction_actual_state <= "01";
                branch_state <= '0';
            else
                prediction_actual_state <= "00";
                branch_state <= '0';
            end if;
        WHEN s1 =>
            if zero_flag = '0' then
                prediction_actual_state <= "10";
                branch_state <= '1';
            else
                prediction_actual_state <= "00";
                branch_state <= '1';
            end if;
        WHEN OTHERS =>
        prediction_actual_state <= "00";
        branch_state <= '0';
    END CASE;
END PROCESS output_process;
END ARCHITECTURE BranchArch;