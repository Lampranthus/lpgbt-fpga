-------------------------------------------------------
--! @file
--! @author Eduardo Mendes <eduardo.brandao.de.souza.mendes@cern.ch> (CERN - EP-ESE-BE)
--! @version 2.0
--! @brief Simulation Example design top - Includes lpgbt-fpga and lpgbt-model
-------------------------------------------------------

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.lpgbtfpga_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity top_tb is
  generic (
       FEC                              : integer range 0 to 2 := FEC5;           --! FEC selection can be: FEC5 or FEC12
       DATARATE                         : integer range 0 to 2 := DATARATE_10G24  --! Datarate selection can be: DATARATE_10G24 or DATARATE_5G12  		
  );	
end top_tb;

--=================================================================================================--
--####################################   Architecture   ###########################################--
--=================================================================================================--

architecture behavioral of top_tb is

    -- Components declaration
    component lpgbtfpga_sim is
       GENERIC(
             FEC                              : integer range 0 to 2;                  --! FEC selection can be: FEC5 or FEC12
             DATARATE                         : integer range 0 to 2 := DATARATE_5G12  --! Datarate selection can be: DATARATE_10G24 or DATARATE_5G12  		
        );
        port (  
          
          --===============--
          -- Clocks scheme --
          --===============--       
          -- MGT(Ideal SerDes) serial clock:
          ----------------------------
          -- Comment: * The MGT reference clock frequency must be 10.24GHz for 10G and 5.12GHz for 5G
    	  -- This is implemented only for simulation purposes, in real-life the SerDes generates this high-speed clock from the reference clock with a PLL
          MGT_SERCLK                                    : in  std_logic;
    
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
    end component lpgbtfpga_sim;

    COMPONENT lpgbt_model_wrapper
        GENERIC (
             FEC                              : integer range 0 to 2;                  --! FEC selection can be: FEC5 or FEC12
             DATARATE                         : integer range 0 to 2 := DATARATE_5G12  --! Datarate selection can be: DATARATE_10G24 or DATARATE_5G12  		
        );	
        PORT (
            -- Ref clk
            refclk_i         : in  std_logic; -- In real-life applications, the lpGBT recovers the clock from the incoming serial stream
                                              -- For simulation purposes, we provide the reference clock here

            -- Reset
            rst_lpgbtrstn_i         : in  std_logic;

            -- Status
            stat_lpgbtrdy_o         : out std_logic;

            -- MGT
            dat_downLinkSerial_i    : in  std_logic;
            dat_upLinkSerial_o      : out std_logic;

            -- eClocks
            clk_eport0_o            : out std_logic;
            clk_eport1_o            : out std_logic;
            clk_eport2_o            : out std_logic;
            clk_eport3_o            : out std_logic;
            clk_eport4_o            : out std_logic;
            clk_eport5_o            : out std_logic;
            clk_eport6_o            : out std_logic;
            clk_eport7_o            : out std_logic;
            clk_eport8_o            : out std_logic;
            clk_eport9_o            : out std_logic;
            clk_eport10_o           : out std_logic;
            clk_eport11_o           : out std_logic;
            clk_eport12_o           : out std_logic;
            clk_eport13_o           : out std_logic;
            clk_eport14_o           : out std_logic;
            clk_eport15_o           : out std_logic;
            clk_eport16_o           : out std_logic;
            clk_eport17_o           : out std_logic;
            clk_eport18_o           : out std_logic;
            clk_eport19_o           : out std_logic;
            clk_eport20_o           : out std_logic;
            clk_eport21_o           : out std_logic;
            clk_eport22_o           : out std_logic;
            clk_eport23_o           : out std_logic;
            clk_eport24_o           : out std_logic;
            clk_eport25_o           : out std_logic;
            clk_eport26_o           : out std_logic;
            clk_eport27_o           : out std_logic;
            clk_eport28_o           : out std_logic;

            -- Downstream ePorts
            dat_eport0_o            : out std_logic;
            dat_eport1_o            : out std_logic;
            dat_eport2_o            : out std_logic;
            dat_eport3_o            : out std_logic;
            dat_eport10_o           : out std_logic;
            dat_eport11_o           : out std_logic;
            dat_eport12_o           : out std_logic;
            dat_eport13_o           : out std_logic;
            dat_eport20_o           : out std_logic;
            dat_eport21_o           : out std_logic;
            dat_eport22_o           : out std_logic;
            dat_eport23_o           : out std_logic;
            dat_eport30_o           : out std_logic;
            dat_eport31_o           : out std_logic;
            dat_eport32_o           : out std_logic;
            dat_eport33_o           : out std_logic;

            -- Upstream ePorts
            dat_eport0_i            : in  std_logic;
            dat_eport1_i            : in  std_logic;
            dat_eport2_i            : in  std_logic;
            dat_eport3_i            : in  std_logic;

            dat_eport10_i           : in  std_logic;
            dat_eport11_i           : in  std_logic;
            dat_eport12_i           : in  std_logic;
            dat_eport13_i           : in  std_logic;

            dat_eport20_i           : in  std_logic;
            dat_eport21_i           : in  std_logic;
            dat_eport22_i           : in  std_logic;
            dat_eport23_i           : in  std_logic;

            dat_eport30_i           : in  std_logic;
            dat_eport31_i           : in  std_logic;
            dat_eport32_i           : in  std_logic;
            dat_eport33_i           : in  std_logic;

            dat_eport40_i           : in  std_logic;
            dat_eport41_i           : in  std_logic;
            dat_eport42_i           : in  std_logic;
            dat_eport43_i           : in  std_logic;

            dat_eport50_i           : in  std_logic;
            dat_eport51_i           : in  std_logic;
            dat_eport52_i           : in  std_logic;
            dat_eport53_i           : in  std_logic;

            dat_eport60_i           : in  std_logic;
            dat_eport61_i           : in  std_logic;
            dat_eport62_i           : in  std_logic;
            dat_eport63_i           : in  std_logic;

            -- EC ePort
            dat_ec_o                : out std_logic;
            dat_ec_i                : in  std_logic;

            -- Phase shifted clocks
            clk_psclk0_o            : out std_logic;
            clk_psclk1_o            : out std_logic;
            clk_psclk2_o            : out std_logic;
            clk_psclk3_o            : out std_logic;

            -- Slow control interfaces (IC)
            dat_i2cm0_sda           : inout std_logic;
            clk_i2cm0_scl           : inout std_logic;

            dat_i2cm1_sda           : inout std_logic;
            clk_i2cm1_scl           : inout std_logic;

            dat_i2cm2_sda           : inout std_logic;
            clk_i2cm2_scl           : inout std_logic;

            dat_gpio0_io            : inout std_logic;
            dat_gpio1_io            : inout std_logic;
            dat_gpio2_io            : inout std_logic;
            dat_gpio3_io            : inout std_logic;
            dat_gpio4_io            : inout std_logic;
            dat_gpio5_io            : inout std_logic;
            dat_gpio6_io            : inout std_logic;
            dat_gpio7_io            : inout std_logic;
            dat_gpio8_io            : inout std_logic;
            dat_gpio9_io            : inout std_logic;
            dat_gpio10_io           : inout std_logic;
            dat_gpio11_io           : inout std_logic;
            dat_gpio12_io           : inout std_logic;
            dat_gpio13_io           : inout std_logic;
            dat_gpio14_io           : inout std_logic;
            dat_gpio15_io           : inout std_logic
        );
    END COMPONENT;

  -- Clocks:
  constant c_REFERENCE_PERIOD   : time := 97.65625 ps ; -- 10.24GHz                            
  constant c_SYS_CLOCK_PERIOD   : time := 8 ns;         -- 125MHz

  signal clk_mgtser                           : std_logic := '0';
  signal clk_bunch_clock                      : std_logic := '0';
  signal clk_125                              : std_logic := '0';

  -- LpGBT-Model
  signal lpgbt_rstn_s                         : std_logic := '0';
  signal lpgbt_rdy_s                          : std_logic;
  signal dat_eport0_uplink_s                  : std_logic := '1';
  signal dat_eport1_uplink_s                  : std_logic := '1';
  signal dat_eport2_uplink_s                  : std_logic := '1';
  signal dat_eport3_uplink_s                  : std_logic := '1';
  signal dat_eport10_uplink_s                 : std_logic := '1';
  signal dat_eport11_uplink_s                 : std_logic := '1';
  signal dat_eport12_uplink_s                 : std_logic := '1';
  signal dat_eport13_uplink_s                 : std_logic := '1';
  signal dat_eport20_uplink_s                 : std_logic := '1';
  signal dat_eport21_uplink_s                 : std_logic := '1';
  signal dat_eport22_uplink_s                 : std_logic := '1';
  signal dat_eport23_uplink_s                 : std_logic := '1';
  signal dat_eport30_uplink_s                 : std_logic := '1';
  signal dat_eport31_uplink_s                 : std_logic := '1';
  signal dat_eport32_uplink_s                 : std_logic := '1';
  signal dat_eport33_uplink_s                 : std_logic := '1';
  signal dat_eport40_uplink_s                 : std_logic := '1';
  signal dat_eport41_uplink_s                 : std_logic := '1';
  signal dat_eport42_uplink_s                 : std_logic := '1';
  signal dat_eport43_uplink_s                 : std_logic := '1';
  signal dat_eport50_uplink_s                 : std_logic := '1';
  signal dat_eport51_uplink_s                 : std_logic := '1';
  signal dat_eport52_uplink_s                 : std_logic := '1';
  signal dat_eport53_uplink_s                 : std_logic := '1';
  signal dat_eport60_uplink_s                 : std_logic := '1';
  signal dat_eport61_uplink_s                 : std_logic := '1';
  signal dat_eport62_uplink_s                 : std_logic := '1';
  signal dat_eport63_uplink_s                 : std_logic := '0';
  
  signal dat_eport0_downlink_s                : std_logic;
  signal dat_eport1_downlink_s                : std_logic;
  signal dat_eport2_downlink_s                : std_logic;
  signal dat_eport3_downlink_s                : std_logic;
  signal dat_eport10_downlink_s               : std_logic;
  signal dat_eport11_downlink_s               : std_logic;
  signal dat_eport12_downlink_s               : std_logic;
  signal dat_eport13_downlink_s               : std_logic;
  signal dat_eport20_downlink_s               : std_logic;
  signal dat_eport21_downlink_s               : std_logic;
  signal dat_eport22_downlink_s               : std_logic;
  signal dat_eport23_downlink_s               : std_logic;
  signal dat_eport30_downlink_s               : std_logic;
  signal dat_eport31_downlink_s               : std_logic;
  signal dat_eport32_downlink_s               : std_logic;
  signal dat_eport33_downlink_s               : std_logic;
  
  -- Serial
  signal downlinkSerial                       : std_logic;
  signal uplinkSerial                         : std_logic;

begin                 --========####   Architecture Body   ####========--

    -- Clocks
    p_sys_clock : process
    begin
      clk_125 <= '0';
      wait for c_SYS_CLOCK_PERIOD/2;
      clk_125 <= '1';
      wait for c_SYS_CLOCK_PERIOD/2;
    end process;
	   
    p_serial_clock : process
    begin
      clk_mgtser <= '0';
      wait for c_REFERENCE_PERIOD*(3-DATARATE)/2;
      clk_mgtser <= '1';
      wait for c_REFERENCE_PERIOD*(3-DATARATE)/2;
    end process;

    p_bunch_clock : process
    begin
      for i in 0 to 128*DATARATE/2-1 loop	
        wait until rising_edge(clk_mgtser);
        clk_bunch_clock <= '0';
      end loop;
      for i in 0 to 128*DATARATE/2-1 loop	
        wait until rising_edge(clk_mgtser);	
        clk_bunch_clock <= '1';
      end loop;
    end process;
	
    -- Components declaration
    lpgbtfpga_sim_inst : lpgbtfpga_sim
        generic map (
             FEC      => FEC,
             DATARATE => DATARATE	
        )
        port map(  
          
          --===============--
          -- Clocks scheme --
          --===============--       
          -- MGT(Ideal SerDes) reference clock:
          ----------------------------
          -- Comment: * The MGT reference clock frequency must be 10.24GHz for 10G and 5.12GHz for 5G
    	  -- This is implemented only for simulation purposes, in real-life the SerDes generates this high-speed clock from the reference clock with a PLL
          MGT_SERCLK                                    => clk_mgtser,
    
          -- Fabric clock:
          ----------------     
          BUNCH_CLOCK                                   => clk_bunch_clock,
          USER_CLOCK                                    => clk_125,
          
          --==========--
          -- MGT(GTX) --
          --==========--
          -- Serial lanes:
          ----------------
          SER_TX                                        => downlinkSerial,
          SER_RX                                        => uplinkSerial
    
       ); 

    -- LpGBT Model
    lpgbt_model_wrapper_inst: lpgbt_model_wrapper
        generic map (
             FEC      => FEC,
             DATARATE => DATARATE	
        )	
        port map(
            -- Ref clk
            refclk_i                => clk_bunch_clock,
		
            -- Reset
            rst_lpgbtrstn_i         => lpgbt_rstn_s,

            -- Status
            stat_lpgbtrdy_o         => lpgbt_rdy_s,

            -- MGT
            dat_downLinkSerial_i    => downlinkSerial,
            dat_upLinkSerial_o      => uplinkSerial,

            -- eClocks
            clk_eport0_o            => open,
            clk_eport1_o            => open,
            clk_eport2_o            => open,
            clk_eport3_o            => open,
            clk_eport4_o            => open,
            clk_eport5_o            => open,
            clk_eport6_o            => open,
            clk_eport7_o            => open,
            clk_eport8_o            => open,
            clk_eport9_o            => open,
            clk_eport10_o           => open,
            clk_eport11_o           => open,
            clk_eport12_o           => open,
            clk_eport13_o           => open,
            clk_eport14_o           => open,
            clk_eport15_o           => open,
            clk_eport16_o           => open,
            clk_eport17_o           => open,
            clk_eport18_o           => open,
            clk_eport19_o           => open,
            clk_eport20_o           => open,
            clk_eport21_o           => open,
            clk_eport22_o           => open,
            clk_eport23_o           => open,
            clk_eport24_o           => open,
            clk_eport25_o           => open,
            clk_eport26_o           => open,
            clk_eport27_o           => open,
            clk_eport28_o           => open,

            -- Downstream ePorts
            dat_eport0_o            => dat_eport0_downlink_s,
            dat_eport1_o            => dat_eport1_downlink_s,
            dat_eport2_o            => dat_eport2_downlink_s,
            dat_eport3_o            => dat_eport3_downlink_s,
            dat_eport10_o           => dat_eport10_downlink_s,
            dat_eport11_o           => dat_eport11_downlink_s,
            dat_eport12_o           => dat_eport12_downlink_s,
            dat_eport13_o           => dat_eport13_downlink_s,
            dat_eport20_o           => dat_eport20_downlink_s,
            dat_eport21_o           => dat_eport21_downlink_s,
            dat_eport22_o           => dat_eport22_downlink_s,
            dat_eport23_o           => dat_eport23_downlink_s,
            dat_eport30_o           => dat_eport30_downlink_s,
            dat_eport31_o           => dat_eport31_downlink_s,
            dat_eport32_o           => dat_eport32_downlink_s,
            dat_eport33_o           => dat_eport33_downlink_s,

            -- Upstream ePorts
            dat_eport0_i            => dat_eport0_uplink_s,
            dat_eport1_i            => dat_eport1_uplink_s,
            dat_eport2_i            => dat_eport2_uplink_s,
            dat_eport3_i            => dat_eport3_uplink_s,

            dat_eport10_i           => dat_eport10_uplink_s,
            dat_eport11_i           => dat_eport11_uplink_s,
            dat_eport12_i           => dat_eport12_uplink_s,
            dat_eport13_i           => dat_eport13_uplink_s,

            dat_eport20_i           => dat_eport20_uplink_s,
            dat_eport21_i           => dat_eport21_uplink_s,
            dat_eport22_i           => dat_eport22_uplink_s,
            dat_eport23_i           => dat_eport23_uplink_s,

            dat_eport30_i           => dat_eport30_uplink_s,
            dat_eport31_i           => dat_eport31_uplink_s,
            dat_eport32_i           => dat_eport32_uplink_s,
            dat_eport33_i           => dat_eport33_uplink_s,

            dat_eport40_i           => dat_eport40_uplink_s,
            dat_eport41_i           => dat_eport41_uplink_s,
            dat_eport42_i           => dat_eport42_uplink_s,
            dat_eport43_i           => dat_eport43_uplink_s,

            dat_eport50_i           => dat_eport50_uplink_s,
            dat_eport51_i           => dat_eport51_uplink_s,
            dat_eport52_i           => dat_eport52_uplink_s,
            dat_eport53_i           => dat_eport53_uplink_s,

            dat_eport60_i           => dat_eport60_uplink_s,
            dat_eport61_i           => dat_eport61_uplink_s,
            dat_eport62_i           => dat_eport62_uplink_s,
            dat_eport63_i           => dat_eport63_uplink_s,

            -- EC ePort
            dat_ec_o                => open,
            dat_ec_i                => '1',

            -- Phase shifted clocks
            clk_psclk0_o            => open,
            clk_psclk1_o            => open,
            clk_psclk2_o            => open,
            clk_psclk3_o            => open,

            -- Slow control interfaces (IC)
            dat_i2cm0_sda           => open,
            clk_i2cm0_scl           => open,

            dat_i2cm1_sda           => open,
            clk_i2cm1_scl           => open,

            dat_i2cm2_sda           => open,
            clk_i2cm2_scl           => open,

            dat_gpio0_io            => open,
            dat_gpio1_io            => open,
            dat_gpio2_io            => open,
            dat_gpio3_io            => open,
            dat_gpio4_io            => open,
            dat_gpio5_io            => open,
            dat_gpio6_io            => open,
            dat_gpio7_io            => open,
            dat_gpio8_io            => open,
            dat_gpio9_io            => open,
            dat_gpio10_io           => open,
            dat_gpio11_io           => open,
            dat_gpio12_io           => open,
            dat_gpio13_io           => open,
            dat_gpio14_io           => open,
            dat_gpio15_io           => open
        );

end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--
