-------------------------------------------------------
--! @file
--! @author Eduardo Mendes <eduardo.brandao.de.souza.mendes@cern.ch> (CERN - EP-ESE-BE)
--! @version 2.0
--! @brief Simulation Example design top - Includes pattern gen/check.
-------------------------------------------------------

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
    
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.bus_multiplexer_pkg.all;
use work.lpgbtfpga_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--
entity lpgbtfpga_sim is
   GENERIC(
         FEC                              : integer range 0 to 2 := FEC5;                  --! FEC selection can be: FEC5 or FEC12
         DATARATE                         : integer range 0 to 2 := DATARATE_10G24  --! Datarate selection can be: DATARATE_10G24 or DATARATE_5G12  		
    );
    port (  
      
      --===============--
      -- Clocks scheme --
      --===============--       
      -- MGT(Ideal SerDes) serial clock:
      ----------------------------
      -- Comment: * The MGT reference clock frequency must be 10.24GHz for 10G and 5.12GHz for 5G
      -- This is implemented only for simulation purposes, in real-life the SerDes generates this high-speed clock from the reference clock with a PLL
      MGT_SERCLK                                    : in  std_logic; -- High-speed clock
                                                                     -- 10.24 GHz for 10G, 5.12 GHz for 5G 	  

      -- Fabric clock:
      ----------------     
      BUNCH_CLOCK                                   : in  std_logic; -- 40 MHz
      USER_CLOCK                                    : in  std_logic; -- 125 MHz  
      
      --==========--
      -- MGT(GTX) --
      --==========--
      -- Serial lanes:
      ----------------
      SER_TX                                        : out std_logic;
      SER_RX                                        : in  std_logic

   ); 
end lpgbtfpga_sim;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of lpgbtfpga_sim is

    -- Components declaration
    component lpgbtFpga is 
       GENERIC(
            FEC                              : integer range 0 to 2;                  --! FEC selection can be: FEC5 or FEC12
            DATARATE                         : integer range 0 to 2 := DATARATE_5G12  --! Datarate selection can be: DATARATE_10G24 or DATARATE_5G12  		
       );
       PORT (
            -- Clocks
            downlinkClk_i                    : in  std_logic;                         --! 40MHz user clock
            uplinkClk_i                      : in  std_logic;                         --! 40MHz user clock
    
            downlinkRst_i                    : in  std_logic;                         --! Reset the downlink path
            uplinkRst_i                      : in  std_logic;                         --! Reset the uplink path
    
            -- Down link                                                              
            downlinkUserData_i               : in  std_logic_vector(31 downto 0);     --! Downlink data (user)
            downlinkEcData_i                 : in  std_logic_vector(1 downto 0);      --! Downlink EC field
            downlinkIcData_i                 : in  std_logic_vector(1 downto 0);      --! Downlink IC field
                                                                                      
            downLinkBypassInterleaver_i      : in  std_logic;                         --! Bypass downlink interleaver (test purpose only)
            downLinkBypassFECEncoder_i       : in  std_logic;                         --! Bypass downlink FEC (test purpose only)
            downLinkBypassScrambler_i        : in  std_logic;                         --! Bypass downlink scrambler (test purpose only)
            downlinkReady_o                  : out std_logic;                         --! Downlink ready status
                                                                                      
            -- Fixed-phase downlink CDC operation                                     
            downlinkPhase_o                  : out  std_logic_vector(9 downto 0);     --! Phase to check fixed-phase
            downlinkPhaseCalib_i             : in   std_logic_vector(9 downto 0);     --! Phase measured in first reset
            downlinkPhaseForce_i             : in   std_logic                   ;     --! Force phase after first reset to ensure fixed-phase operation
                                                                                      
            -- Up link                                                                
            uplinkUserData_o                 : out std_logic_vector(229 downto 0);    --! Uplink data (user)
            uplinkEcData_o                   : out std_logic_vector(1 downto 0);      --! Uplink EC field
            uplinkIcData_o                   : out std_logic_vector(1 downto 0);      --! Uplink IC field
                                                                                      
            uplinkBypassInterleaver_i        : in  std_logic;                         --! Bypass uplink interleaver (test purpose only)
            uplinkBypassFECEncoder_i         : in  std_logic;                         --! Bypass uplink FEC (test purpose only)
            uplinkBypassScrambler_i          : in  std_logic;                         --! Bypass uplink scrambler (test purpose only)
                                                                                      
            uplinkFECCorrectedClear_i        : in  std_logic;                         --! Uplink FEC corrected error clear (debugging)
            uplinkFECCorrectedLatched_o      : out std_logic;                         --! Uplink FEC corrected error latched (debugging)
                                                                                      
            uplinkReady_o                    : out std_logic;                         --! Uplink ready status
                                                                                      
            -- Fixed-phase uplink CDC operation                                       
            uplinkPhase_o                    : out  std_logic_vector(2 downto 0);     --! Phase to check fixed-phase
            uplinkPhaseCalib_i               : in   std_logic_vector(2 downto 0);     --! Phase measured in first reset
            uplinkPhaseForce_i               : in   std_logic;                        --! Force the phase to be the calibrated one
                                                                                      
            -- MGT                                                                    
            clk_mgtserclk_i                  : in  std_logic;                         --! Transceiver reference clock 320 MHz
            clk_mgtfreedrpclk_i              : in  std_logic;                         --! 125MHz Free-running clock
    
            clk_mgtTxClk_o                   : out std_logic;
            clk_mgtRxClk_o                   : out std_logic;
		
            mgt_rx_i                         : in  std_logic;
            mgt_tx_o                         : out std_logic;
                   
            mgt_txpolarity_i                 : in  std_logic;	   
            mgt_rxpolarity_i                 : in  std_logic    
       ); 
    end component lpgbtFpga;
          
    COMPONENT lpgbtfpga_patterngen is
      port(
          clk320DnLink_i            : in  std_logic;
          clkEnDnLink_i             : in  std_logic;
    
          generator_rst_i           : in  std_logic;
    
          config_group0_i           : in  std_logic_vector(1 downto 0);
          config_group1_i           : in  std_logic_vector(1 downto 0);
          config_group2_i           : in  std_logic_vector(1 downto 0);
          config_group3_i           : in  std_logic_vector(1 downto 0);
    
          fixed_pattern_i           : in  std_logic_vector(31 downto 0);
    
          downlink_o                : out std_logic_vector(31 downto 0);
    
          eport_gen_rdy_o           : out std_logic_vector(15 downto 0)
      );
    END COMPONENT;
        
    COMPONENT lpgbtfpga_patternchecker
        port (
            reset_checker_i  : in  std_logic;
            ser320_clk_i     : in  std_logic;
            ser320_clkEn_i   : in  std_logic;
    
            data_rate_i      : in  std_logic;
    
            elink_config_i   : in  conf2b_array(27 downto 0);
    
            error_detected_o : out std_logic_vector(27 downto 0);
    
            userDataUpLink_i : in  std_logic_vector(229 downto 0)
        );
    END COMPONENT;
    
    -- Signals:
            
        -- Clocks:
        signal mgtSerClk   : std_logic;

        signal mgt_freedrpclk_s                   : std_logic;
        
        signal lpgbtfpga_mgttxclk_s               : std_logic;
        signal lpgbtfpga_mgtrxclk_s               : std_logic;
        
        
        -- User CDC for lpGBT-FPGA		
        signal lpgbtfpga_clk40                    : std_logic;		
        signal uplinkPhase_s                      : std_logic_vector(2 downto 0) := "000";
        signal uplinkPhaseCalib_s                 : std_logic_vector(2 downto 0) := "000";
        signal uplinkPhaseForce_s                 : std_logic := '0';                 
                                                                                 
        signal downlinkPhase_s                    : std_logic_vector(9 downto 0) := "0000000000";
        signal downlinkPhaseCalib_s               : std_logic_vector(9 downto 0) := "0000000000";
        signal downlinkPhaseForce_s               : std_logic := '0';
		
        -- LpGBT-FPGA                             
        signal lpgbtfpga_downlinkrst_s            : std_logic := '1';
        signal lpgbtfpga_downlinkrdy_s            : std_logic;
        signal lpgbtfpga_uplinkrst_s              : std_logic := '0';
        signal lpgbtfpga_uplinkrdy_s              : std_logic := '0';
        
        signal lpgbtfpga_downlinkUserData_s       : std_logic_vector(31 downto 0);
        signal lpgbtfpga_downlinkEcData_s         : std_logic_vector(1 downto 0);
        signal lpgbtfpga_downlinkIcData_s         : std_logic_vector(1 downto 0);
        
        signal lpgbtfpga_uplinkUserData_s         : std_logic_vector(229 downto 0);
        signal lpgbtfpga_uplinkEcData_s           : std_logic_vector(1 downto 0);
        signal lpgbtfpga_uplinkIcData_s           : std_logic_vector(1 downto 0);
        signal lpgbtfpga_uplinkclk_s              : std_logic;

        signal lpgbtfpga_mgt_txpolarity_s         : std_logic := '0';
        signal lpgbtfpga_mgt_rxpolarity_s         : std_logic := '0';
                                
        signal downLinkBypassInterleaver_s        : std_logic := '0';
        signal downLinkBypassFECEncoder_s         : std_logic := '0';
        signal downLinkBypassScrambler_s          : std_logic := '0';
        
        signal upLinkScramblerBypass_s            : std_logic := '0';
        signal upLinkFecBypass_s                  : std_logic := '0';
        signal upLinkInterleaverBypass_s          : std_logic := '0';
        
        signal upLinkFECCorrectedClear_s          : std_logic := '0';
        signal upLinkFECCorrectedLatched_s        : std_logic       ;
		
        -- Config
        signal uplinkSelectDataRate_s             : std_logic := '0';

        signal generator_rst_s                    : std_logic := '0';
        signal downconfig_g0_s                    : std_logic_vector(1 downto 0) := "00";
        signal downconfig_g1_s                    : std_logic_vector(1 downto 0) := "00";
        signal downconfig_g2_s                    : std_logic_vector(1 downto 0) := "00";
        signal downconfig_g3_s                    : std_logic_vector(1 downto 0) := "00";   
        signal downlink_gen_rdy_s                 : std_logic_vector(15 downto 0);
    
        signal upelink_config_s                   : conf2b_array(27 downto 0);
        signal uperror_detected_s                 : std_logic_vector(27 downto 0);
        signal reset_upchecker_s                  : std_logic := '0';

begin                 --========####   Architecture Body   ####========-- 
    
    gen_datarate_5G: if DATARATE=DATARATE_5G12 generate
      uplinkSelectDataRate_s <= '0';
    end generate gen_datarate_5G;
	
    gen_datarate_10G: if DATARATE=DATARATE_10G24 generate
      uplinkSelectDataRate_s <= '1';
    end generate gen_datarate_10G;
	
    -- Clocks
    
    -- MGT(GTX) reference clock:
    ----------------------------   
    mgtSerClk <= MGT_SERCLK;
    mgt_freedrpclk_s <= USER_CLOCK;  
  
    -- In this example design, the 40MHz clock comes from an external source which should be synchronous to the MGT reference clock
    lpgbtfpga_clk40 <= BUNCH_CLOCK;

    -- LpGBT FPGA
    lpgbtFpga_top_inst: lpgbtFpga 
      generic map(
            FEC                             => FEC,
            DATARATE                        => DATARATE
       )
       port map (
            -- Clocks
            downlinkClk_i                    => lpgbtfpga_clk40,
            uplinkClk_i                      => lpgbtfpga_clk40,

            downlinkRst_i                    => lpgbtfpga_downlinkrst_s,
            uplinkRst_i                      => lpgbtfpga_uplinkrst_s,

            -- Down link
            downlinkUserData_i               => lpgbtfpga_downlinkUserData_s,
            downlinkEcData_i                 => lpgbtfpga_downlinkEcData_s,
            downlinkIcData_i                 => lpgbtfpga_downlinkIcData_s,

            downLinkBypassInterleaver_i      => downLinkBypassInterleaver_s,
            downLinkBypassFECEncoder_i       => downLinkBypassFECEncoder_s,
            downLinkBypassScrambler_i        => downLinkBypassScrambler_s,

            downlinkReady_o                  => lpgbtfpga_downlinkrdy_s,

            -- Fixed-phase downlink CDC operation
            downlinkPhase_o                  => downlinkPhase_s     ,
            downlinkPhaseCalib_i             => downlinkPhaseCalib_s,
            downlinkPhaseForce_i             => downlinkPhaseForce_s,

            -- Up link
            uplinkUserData_o                 => lpgbtfpga_uplinkUserData_s,
            uplinkEcData_o                   => lpgbtfpga_uplinkEcData_s,
            uplinkIcData_o                   => lpgbtfpga_uplinkIcData_s,

            uplinkBypassInterleaver_i        => upLinkInterleaverBypass_s,
            uplinkBypassFECEncoder_i         => upLinkFecBypass_s,
            uplinkBypassScrambler_i          => upLinkScramblerBypass_s,
            
            uplinkFECCorrectedClear_i        => upLinkFECCorrectedClear_s,
			uplinkFECCorrectedLatched_o      => upLinkFECCorrectedLatched_s,
		
            uplinkReady_o                    => lpgbtfpga_uplinkrdy_s,

            -- Fixed-phase uplink CDC operation
            uplinkPhase_o                    => uplinkPhase_s     ,
            uplinkPhaseCalib_i               => uplinkPhaseCalib_s,
            uplinkPhaseForce_i               => uplinkPhaseForce_s,

            -- MGT
            clk_mgtserclk_i                  => mgtSerClk,
            clk_mgtfreedrpclk_i              => mgt_freedrpclk_s,
            
            clk_mgtTxClk_o                   => lpgbtfpga_mgttxclk_s,
            clk_mgtRxClk_o                   => lpgbtfpga_mgtrxclk_s,
            
            mgt_rx_i                         => SER_RX,
            mgt_tx_o                         => SER_TX,
            
            mgt_txpolarity_i                 => lpgbtfpga_mgt_txpolarity_s,
            mgt_rxpolarity_i                 => lpgbtfpga_mgt_rxpolarity_s
       );
       
    -- Data stimulis
    lpgbtfpga_downlinkEcData_s     <= (others => '1');
    lpgbtfpga_downlinkIcData_s     <= (others => '1');
	
    -- Data pattern generator / checker (PRBS7)
    lpgbtfpga_patterngen_inst: lpgbtfpga_patterngen
        port map(
            --clk40Mhz_Tx_i      : in  std_logic;
            clk320DnLink_i            => lpgbtfpga_clk40,
            clkEnDnLink_i             => '1',

            generator_rst_i           => generator_rst_s,

            -- Group configurations:
            --    "11": 320Mbps
            --    "10": 160Mbps
            --    "01": 80Mbps
            --    "00": Fixed pattern
            config_group0_i           => downconfig_g0_s,
            config_group1_i           => downconfig_g1_s,
            config_group2_i           => downconfig_g2_s,
            config_group3_i           => downconfig_g3_s,

            downlink_o                => lpgbtfpga_downlinkUserData_s,

            fixed_pattern_i           => x"12345678",

            eport_gen_rdy_o           => downlink_gen_rdy_s
        );

    lpgbtfpga_patternchecker_inst: lpgbtfpga_patternchecker
        port map(
            reset_checker_i  => reset_upchecker_s,
            ser320_clk_i     => lpgbtfpga_clk40,
            ser320_clkEn_i   => '1',
    
            data_rate_i      => uplinkSelectDataRate_s,
    
            elink_config_i   => upelink_config_s,
    
            error_detected_o => uperror_detected_s,
    
            userDataUpLink_i => lpgbtfpga_uplinkUserData_s
        );
        
  --------------------------------------------------------------------------------------------------------
  -- Those signals can be controlled in simulation using a FORCE to provide a stimulis for the test-bench
  --------------------------------------------------------------------------------------------------------
  -- INPUTS:  
  --------------------------------------------------------------------------------------------------------
  -- lpgbtfpga_downlinkrdy_s,
  -- lpgbtfpga_uplinkrdy_s,
  -- downlink_gen_rdy_s,
  -- uperror_detected_s,
  -- upLinkFECCorrectedLatched_s,  
  -- downlinkPhase_s,
  -- uplinkPhase_s,
  --------------------------------------------------------------------------------------------------------
  -- OUTPUTS:
  --------------------------------------------------------------------------------------------------------
  -- lpgbtfpga_downlinkrst_s,
  -- lpgbtfpga_uplinkrst_s,
  -- downLinkBypassInterleaver_s,
  -- downLinkBypassFECEncoder_s,
  -- downLinkBypassScrambler_s,
  -- upLinkInterleaverBypass_s,
  -- upLinkFecBypass_s,
  -- upLinkScramblerBypass_s,
  -- generator_rst_s,
  -- downconfig_g0_s,
  -- downconfig_g1_s,
  -- downconfig_g2_s,
  -- downconfig_g3_s,
  -- reset_upchecker_s,
  -- upelink_config_s(0),
  -- upelink_config_s(1),
  -- upelink_config_s(2),
  -- upelink_config_s(3),
  -- upelink_config_s(4),
  -- upelink_config_s(5),
  -- upelink_config_s(6),
  -- upelink_config_s(7),
  -- upelink_config_s(8),
  -- upelink_config_s(9),
  -- upelink_config_s(10),
  -- upelink_config_s(11),
  -- upelink_config_s(12),
  -- upelink_config_s(13),
  -- upelink_config_s(14),
  -- upelink_config_s(15),
  -- upelink_config_s(16),
  -- upelink_config_s(17),
  -- upelink_config_s(18),
  -- upelink_config_s(20),
  -- upelink_config_s(21),
  -- upelink_config_s(22),
  -- upelink_config_s(23),
  -- upelink_config_s(24),
  -- upelink_config_s(25),
  -- upelink_config_s(26),
  -- upelink_config_s(27),
  -- lpgbtfpga_mgt_txpolarity_s,
  -- lpgbtfpga_mgt_rxpolarity_s,
  -- upLinkFECCorrectedClear_s,
  -- downlinkPhaseCalib_s,
  -- uplinkPhaseCalib_s,
  -- downlinkPhaseForce_s,
  -- uplinkPhaseForce_s
  --------------------------------------------------------------------------------------------------------
    
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--
