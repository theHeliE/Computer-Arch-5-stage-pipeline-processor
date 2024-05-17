LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FlushUnit IS
    PORT (
        clk, reset : IN STD_LOGIC;
        WrongPredictionState : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        BranchPredict : IN STD_LOGIC;
        decode_JMP, decode_z_sig, exec_z_sig, decode_UC_sig, MEM_RET : IN STD_LOGIC;
        Flushed, ResetFetchDecode, ResetDecodeExecute, ResetExecuteMemory, ResetControl : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE flusharch OF FlushUnit IS
    TYPE state_type IS (NoFlush, FlushOnce, FlushTwice, FlushThree);
    SIGNAL state : state_type;
BEGIN
    Flush_process : PROCESS (clk, WrongPredictionState, BranchPredict, decode_JMP, decode_z_sig, exec_z_sig, decode_UC_sig, MEM_RET)
    BEGIN
        IF falling_edge(clk) THEN
            CASE state IS
                WHEN NoFlush =>
                    IF MEM_RET = '1' THEN
                        state <= FlushThree;
                    ELSIF exec_z_sig = '1' AND WrongPredictionState = "01" THEN
                        state <= FlushTwice;
                    ELSIF exec_z_sig = '1' AND WrongPredictionState = "10" THEN
                        state <= FlushOnce;
                    ELSIF decode_UC_sig = '1' AND decode_JMP = '1' THEN
                        state <= FlushOnce;
                    ELSIF BranchPredict = '1' AND decode_z_sig = '1' THEN
                        state <= FlushOnce;
                    ELSE
                        state <= NoFlush;
                    END IF;

                WHEN FlushOnce =>
                    IF MEM_RET = '1' THEN
                        state <= FlushThree;
                    ELSIF exec_z_sig = '1' AND WrongPredictionState = "01" THEN
                        state <= FlushTwice;
                    ELSIF exec_z_sig = '1' AND WrongPredictionState = "10" THEN
                        state <= FlushOnce;
                    ELSIF decode_UC_sig = '1' AND decode_JMP = '1' THEN
                        state <= FlushOnce;
                    ELSIF BranchPredict = '1' AND decode_z_sig = '1' THEN
                        state <= FlushOnce;
                    ELSE
                        state <= NoFlush;
                    END IF;
                WHEN FlushTwice =>
                    IF MEM_RET = '1' THEN
                        state <= FlushThree;
                    ELSIF exec_z_sig = '1' AND WrongPredictionState = "01" THEN
                        state <= FlushTwice;
                    ELSIF exec_z_sig = '1' AND WrongPredictionState = "10" THEN
                        state <= FlushOnce;
                    ELSIF decode_UC_sig = '1' AND decode_JMP = '1' THEN
                        state <= FlushOnce;
                    ELSIF BranchPredict = '1' AND decode_z_sig = '1' THEN
                        state <= FlushOnce;
                    ELSE
                        state <= NoFlush;
                    END IF;

                WHEN FlushThree =>
                    IF MEM_RET = '1' THEN
                        state <= FlushThree;
                    ELSIF exec_z_sig = '1' AND WrongPredictionState = "01" THEN
                        state <= FlushTwice;
                    ELSIF exec_z_sig = '1' AND WrongPredictionState = "10" THEN
                        state <= FlushOnce;
                    ELSIF decode_UC_sig = '1' AND decode_JMP = '1' THEN
                        state <= FlushOnce;
                    ELSIF BranchPredict = '1' AND decode_z_sig = '1' THEN
                        state <= FlushOnce;
                    ELSE
                        state <= NoFlush;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

    output_process : PROCESS (state)
    BEGIN
        CASE state IS
            WHEN NoFlush =>
                ResetFetchDecode <= '0';
                ResetDecodeExecute <= '0';
                ResetExecuteMemory <= '0';
                ResetControl <= '0';
                Flushed <= '0';

            WHEN FlushOnce =>
                ResetFetchDecode <= '1';
                ResetDecodeExecute <= '0';
                ResetExecuteMemory <= '0';
                ResetControl <= '0';
                Flushed <= '1';

            WHEN FlushTwice =>
                ResetFetchDecode <= '1';
                ResetDecodeExecute <= '1';
                ResetExecuteMemory <= '0';
                ResetControl <= '1';
                Flushed <= '1';

            WHEN FlushThree =>
                ResetFetchDecode <= '1';
                ResetDecodeExecute <= '1';
                ResetExecuteMemory <= '1';
                ResetControl <= '1';
                Flushed <= '1';

            WHEN OTHERS =>
                ResetFetchDecode <= '0';
                ResetDecodeExecute <= '0';
                ResetExecuteMemory <= '0';
                ResetControl <= '0';
                Flushed <= '0';
        END CASE;
    END PROCESS output_process;
END ARCHITECTURE flusharch;