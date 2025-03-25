library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--! Include the LpGBT-FPGA specific package
use work.lpgbtfpga_package.all;

entity lpgbtFpga_tb is
end lpgbtFpga_tb;

architecture Behavioral of lpgbtFpga_tb is

    -- Se�ales para el DUT (LpGBT FPGA)
    signal downlinkClk_i      : std_logic := '0';
    signal uplinkClk_i        : std_logic := '0';
    signal downlinkRst_i      : std_logic := '0';
    signal uplinkRst_i        : std_logic := '0';
    signal downlinkUserData_i : std_logic_vector(31 downto 0) := (others => '0');
    signal downlinkEcData_i   : std_logic_vector(1 downto 0) := (others => '0');
    signal downlinkIcData_i   : std_logic_vector(1 downto 0) := (others => '0');
    signal uplinkUserData_o   : std_logic_vector(229 downto 0);
    signal uplinkEcData_o     : std_logic_vector(1 downto 0);
    signal uplinkIcData_o     : std_logic_vector(1 downto 0);
    signal mgt_tx_o           : std_logic;
    signal mgt_rx_i           : std_logic := '0';

    -- Se�ales de control
    signal clk_mgtserclk_i    : std_logic := '0';
    signal clk_mgtfreedrpclk_i: std_logic := '0';

    -- Constantes
    constant CLK_PERIOD       : time := 3.125 ns;  -- 320 MHz
    constant CLK40_PERIOD     : time := 25 ns;     -- 40 MHz

begin

    -- Instanciaci�n del DUT (LpGBT FPGA)
    dut: entity work.lpgbtFpga
        generic map (
            FEC      => FEC5,
            DATARATE => DATARATE_10G24
        )
        port map (
            downlinkClk_i      => downlinkClk_i,
            uplinkClk_i        => uplinkClk_i,
			
            downlinkRst_i      => downlinkRst_i,
            uplinkRst_i        => uplinkRst_i,
			
            downlinkUserData_i => downlinkUserData_i,
            downlinkEcData_i   => downlinkEcData_i,
            downlinkIcData_i   => downlinkIcData_i,
			
            downLinkBypassInterleaver_i => '0',                            
            downLinkBypassFECEncoder_i  => '0',                            
            downLinkBypassScrambler_i   => '0',                         
            downlinkReady_o             => open,  -- Observar en simulaci�n
			                                   
            downlinkPhase_o             => open,  -- Observar en simulaci�n
            downlinkPhaseCalib_i        => "0000000000",        
            downlinkPhaseForce_i        => '0',          
			
            uplinkUserData_o   => uplinkUserData_o,
            uplinkEcData_o     => uplinkEcData_o,
            uplinkIcData_o     => uplinkIcData_o,
			
            uplinkBypassInterleaver_i => '0',  
            uplinkBypassFECEncoder_i => '0',         
            uplinkBypassScrambler_i => '0',
			
            uplinkFECCorrectedClear_i => '0',    
            uplinkFECCorrectedLatched_o => open,  -- Observar en simulaci�n
			
            uplinkReady_o => open,  -- Observar en simulaci�n
			
            uplinkPhase_o => open,  -- Observar en simulaci�n
            uplinkPhaseCalib_i => "000",          
            uplinkPhaseForce_i => '0',            
			
            clk_mgtserclk_i   => clk_mgtserclk_i,
            clk_mgtfreedrpclk_i => clk_mgtfreedrpclk_i,	
			
            clk_mgtTxClk_o => open,  -- Observar en simulaci�n
            clk_mgtRxClk_o => open,  -- Observar en simulaci�n
			
            mgt_tx_o           => mgt_tx_o,
            mgt_rx_i           => mgt_tx_o,  -- Realimentaci�n: tx_o conectado a rx_i
			
            mgt_txpolarity_i => '0',       	   
            mgt_rxpolarity_i => '0'             
        );

    -- Generaci�n del reloj de 320 MHz
    clk_mgtserclk_i_process: process
    begin
        clk_mgtserclk_i <= '0';
        wait for CLK_PERIOD / 2;
        clk_mgtserclk_i <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Generaci�n del reloj de 40 MHz
    downlinkClk_i_process: process
    begin
        downlinkClk_i <= '0';
        wait for CLK40_PERIOD / 2;
        downlinkClk_i <= '1';
        wait for CLK40_PERIOD / 2;
    end process;

    uplinkClk_i_process: process
    begin
        uplinkClk_i <= '0';
        wait for CLK40_PERIOD / 2;
        uplinkClk_i <= '1';
        wait for CLK40_PERIOD / 2;
    end process;

    -- Proceso de estimulaci�n
    stim_proc: process
    begin
        -- Inicializaci�n
        downlinkRst_i <= '0';
        uplinkRst_i <= '0';
        wait for 100 ns;

        -- Liberar reset
        downlinkRst_i <= '1';
        uplinkRst_i <= '1';
        wait for 100 ns;

        -- Enviar datos de prueba por el downlink
        downlinkUserData_i <= x"12345678";  -- Datos de ejemplo
        downlinkEcData_i   <= "01";         -- Campo EC de ejemplo
        downlinkIcData_i   <= "10";         -- Campo IC de ejemplo
        wait for 200 ns;

        -- Simular recepci�n de datos por el uplink
        -- La realimentaci�n ya est� conectada (mgt_tx_o -> mgt_rx_i)
        wait for 200 ns;

        -- Finalizar simulaci�n
        wait;
    end process;

end Behavioral;