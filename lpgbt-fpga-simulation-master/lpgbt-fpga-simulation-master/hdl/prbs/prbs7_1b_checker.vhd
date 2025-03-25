library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity prbs7_1b_checker is
    port (
        reset_i          : in  std_logic;
        clk_i            : in  std_logic;
        clken_i          : in  std_logic;
        prbs_word_i      : in  std_logic;
        err_o            : out std_logic_vector(3 downto 0);
        rdy_o            : out std_logic
    );
end prbs7_1b_checker;

architecture rtl of prbs7_1b_checker is
    signal feedback_reg         : std_logic_vector(7 downto 0);
    signal err_s                : std_logic_vector(3 downto 0);
    
    type checker_state_T is (waitForLock, Locked);
    signal status : checker_state_T;
                                
    constant STATS_CONFIG_c     : integer := 10;
    signal cnt_stats            : integer range 0 to STATS_CONFIG_c;
begin
    
    -- PRBS7 equation: x^7 + x^6 + 1
    -- LSB first
    checker_fsm_proc: process(reset_i, clk_i)
    begin
        if reset_i = '1' then
            status <= waitForLock;
            cnt_stats <= 0;
            
        elsif rising_edge(clk_i) then
            case status is
                when waitForLock =>
                    if err_s = "0000" and feedback_reg /= x"00" then
                        cnt_stats <= cnt_stats + 1;
                    else
                        cnt_stats <= 0;
                    end if;
                    
                    if cnt_stats= STATS_CONFIG_c then
                        status <= Locked;
                    end if;
                
                when Locked => null;
            end case;
        end if;
    end process;
    
    prbs7_proc: process(reset_i, clk_i)
    begin

        if reset_i = '1' then
            feedback_reg <= (others => '0');
            err_s        <= "0000";

        elsif rising_edge(clk_i) then
            if clken_i = '1' then
                err_s(0) <= (feedback_reg(6) xor feedback_reg(5)) xor prbs_word_i;  
                err_s(3 downto 1) <= "000";

                feedback_reg(7 downto 1) <= feedback_reg(6 downto 0);
                if status /= Locked then                    
                    feedback_reg(0) <= prbs_word_i;
                else
                    feedback_reg(0) <= (feedback_reg(5) xor feedback_reg(6));
                end if;
            end if;
        end if;
    end process;
            
    err_o <= err_s;
    rdy_o <= '1' when status = Locked else '0';
            
end rtl;