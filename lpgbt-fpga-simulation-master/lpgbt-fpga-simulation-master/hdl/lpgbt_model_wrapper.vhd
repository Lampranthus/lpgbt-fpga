-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.lpgbtfpga_package.all;
--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity lpgbt_model_wrapper is
    GENERIC (
         FEC                              : integer range 0 to 2;                  --! FEC selection can be: FEC5 or FEC12
         DATARATE                         : integer range 0 to 2 := DATARATE_5G12  --! Datarate selection can be: DATARATE_10G24 or DATARATE_5G12  		
    );	
    port(
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
end lpgbt_model_wrapper;

--=================================================================================================--
--####################################   Architecture   ###########################################--
--=================================================================================================--

architecture behabioral of lpgbt_model_wrapper is

    COMPONENT lpGBT_model
        PORT (
            -- CORE and IO power supply
            GND                  : in  std_logic;
            VDD1V2               : in  std_logic;

            -- Transmitter power supply
            GNDTX                : in  std_logic;
            VDDTX1V2             : in  std_logic;

            -- Receiver power supply
            GNDRX                : in  std_logic;
            VDDRX1V2             : in  std_logic;

            -- Analog power supply
            GNDA                 : in  std_logic;
            VDDA1V2              : in  std_logic;

            -- Fuses power supply (uses GND for return currents)
            VDDF2V5              : in  std_logic;

            -- High speed serializer outputs
            HSOUTP               : out std_logic;
            HSOUTN               : out std_logic;

            -- High speed deserializer inputs
            HSINP                : in  std_logic;
            HSINN                : in  std_logic;

            -- ePort clock differential outputs
            ECLK0P               : out std_logic;
            ECLK0N               : out std_logic;

            ECLK1P               : out std_logic;
            ECLK1N               : out std_logic;

            ECLK2P               : out std_logic;
            ECLK2N               : out std_logic;

            ECLK3P               : out std_logic;
            ECLK3N               : out std_logic;

            ECLK4P               : out std_logic;
            ECLK4N               : out std_logic;

            ECLK5P               : out std_logic;
            ECLK5N               : out std_logic;

            ECLK6P               : out std_logic;
            ECLK6N               : out std_logic;

            ECLK7P               : out std_logic;
            ECLK7N               : out std_logic;

            ECLK8P               : out std_logic;
            ECLK8N               : out std_logic;

            ECLK9P               : out std_logic;
            ECLK9N               : out std_logic;

            ECLK10P              : out std_logic;
            ECLK10N              : out std_logic;

            ECLK11P              : out std_logic;
            ECLK11N              : out std_logic;

            ECLK12P              : out std_logic;
            ECLK12N              : out std_logic;

            ECLK13P              : out std_logic;
            ECLK13N              : out std_logic;

            ECLK14P              : out std_logic;
            ECLK14N              : out std_logic;

            ECLK15P              : out std_logic;
            ECLK15N              : out std_logic;

            ECLK16P              : out std_logic;
            ECLK16N              : out std_logic;

            ECLK17P              : out std_logic;
            ECLK17N              : out std_logic;

            ECLK18P              : out std_logic;
            ECLK18N              : out std_logic;

            ECLK19P              : out std_logic;
            ECLK19N              : out std_logic;

            ECLK20P              : out std_logic;
            ECLK20N              : out std_logic;

            ECLK21P              : out std_logic;
            ECLK21N              : out std_logic;

            ECLK22P              : out std_logic;
            ECLK22N              : out std_logic;

            ECLK23P              : out std_logic;
            ECLK23N              : out std_logic;

            ECLK24P              : out std_logic;
            ECLK24N              : out std_logic;

            ECLK25P              : out std_logic;
            ECLK25N              : out std_logic;

            ECLK26P              : out std_logic;
            ECLK26N              : out std_logic;

            ECLK27P              : out std_logic;
            ECLK27N              : out std_logic;

            ECLK28P              : out std_logic;
            ECLK28N              : out std_logic;

            -- ePortTX group 0 differential data outputs (downlink)
            EDOUT00P             : out std_logic;
            EDOUT00N             : out std_logic;
            EDOUT01P             : out std_logic;
            EDOUT01N             : out std_logic;
            EDOUT02P             : out std_logic;
            EDOUT02N             : out std_logic;
            EDOUT03P             : out std_logic;
            EDOUT03N             : out std_logic;

            -- ePortTX group 1 differential data outputs (downlink)
            EDOUT10P             : out std_logic;
            EDOUT10N             : out std_logic;
            EDOUT11P             : out std_logic;
            EDOUT11N             : out std_logic;
            EDOUT12P             : out std_logic;
            EDOUT12N             : out std_logic;
            EDOUT13P             : out std_logic;
            EDOUT13N             : out std_logic;

            -- ePortTX group 2 differential data outputs (downlink)
            EDOUT20P             : out std_logic;
            EDOUT20N             : out std_logic;
            EDOUT21P             : out std_logic;
            EDOUT21N             : out std_logic;
            EDOUT22P             : out std_logic;
            EDOUT22N             : out std_logic;
            EDOUT23P             : out std_logic;
            EDOUT23N             : out std_logic;

            -- ePortTX group 3 differential data outputs (downlink)
            EDOUT30P             : out std_logic;
            EDOUT30N             : out std_logic;
            EDOUT31P             : out std_logic;
            EDOUT31N             : out std_logic;
            EDOUT32P             : out std_logic;
            EDOUT32N             : out std_logic;
            EDOUT33P             : out std_logic;
            EDOUT33N             : out std_logic;

            -- ePortTX EC differential data outputs
            EDOUTECP             : out std_logic;
            EDOUTECN             : out std_logic;

            -- ePortRX group 0 differential data inputs (uplink)
            EDIN00P              : in  std_logic;
            EDIN00N              : in  std_logic;
            EDIN01P              : in  std_logic;
            EDIN01N              : in  std_logic;
            EDIN02P              : in  std_logic;
            EDIN02N              : in  std_logic;
            EDIN03P              : in  std_logic;
            EDIN03N              : in  std_logic;

            -- ePortRX group 1 differential data inputs (uplink)
            EDIN10P              : in  std_logic;
            EDIN10N              : in  std_logic;
            EDIN11P              : in  std_logic;
            EDIN11N              : in  std_logic;
            EDIN12P              : in  std_logic;
            EDIN12N              : in  std_logic;
            EDIN13P              : in  std_logic;
            EDIN13N              : in  std_logic;

            -- ePortRX group 2 differential data inputs (uplink)
            EDIN20P              : in  std_logic;
            EDIN20N              : in  std_logic;
            EDIN21P              : in  std_logic;
            EDIN21N              : in  std_logic;
            EDIN22P              : in  std_logic;
            EDIN22N              : in  std_logic;
            EDIN23P              : in  std_logic;
            EDIN23N              : in  std_logic;

            -- ePortRX group 3 differential data inputs (uplink)
            EDIN30P              : in  std_logic;
            EDIN30N              : in  std_logic;
            EDIN31P              : in  std_logic;
            EDIN31N              : in  std_logic;
            EDIN32P              : in  std_logic;
            EDIN32N              : in  std_logic;
            EDIN33P              : in  std_logic;
            EDIN33N              : in  std_logic;

            -- ePortRX group 4 differential data inputs (uplink)
            EDIN40P              : in  std_logic;
            EDIN40N              : in  std_logic;
            EDIN41P              : in  std_logic;
            EDIN41N              : in  std_logic;
            EDIN42P              : in  std_logic;
            EDIN42N              : in  std_logic;
            EDIN43P              : in  std_logic;
            EDIN43N              : in  std_logic;

            -- ePortRX group 5 differential data inputs (uplink)
            EDIN50P              : in  std_logic;
            EDIN50N              : in  std_logic;
            EDIN51P              : in  std_logic;
            EDIN51N              : in  std_logic;
            EDIN52P              : in  std_logic;
            EDIN52N              : in  std_logic;
            EDIN53P              : in  std_logic;
            EDIN53N              : in  std_logic;

            -- ePortRX group 6 differential data inputs (uplink)
            EDIN60P              : in  std_logic;
            EDIN60N              : in  std_logic;
            EDIN61P              : in  std_logic;
            EDIN61N              : in  std_logic;
            EDIN62P              : in  std_logic;
            EDIN62N              : in  std_logic;
            EDIN63P              : in  std_logic;
            EDIN63N              : in  std_logic;

            -- ePortRX EC differential data inputs
            EDINECP              : in  std_logic;
            EDINECN              : in  std_logic;

            -- Phase shifted clocks
            PSCLK0P              : out std_logic;
            PSCLK0N              : out std_logic;
            PSCLK1P              : out std_logic;
            PSCLK1N              : out std_logic;
            PSCLK2P              : out std_logic;
            PSCLK2N              : out std_logic;
            PSCLK3P              : out std_logic;
            PSCLK3N              : out std_logic;

            -- I2C slave for ASIC control
            SLSDA                : inout std_logic;
            SLSCL                : inout std_logic;

            -- Address
            ADR0                 : in  std_logic;
            ADR1                 : in  std_logic;
            ADR2                 : in  std_logic;
            ADR3                 : in  std_logic;

            -- lock mode
            LOCKMODE             : in  std_logic;

            -- reset (active low)
            RSTB                 : in  std_logic;

            -- reset signal
            RSTOUTB              : out std_logic;

            -- mode of operation
            MODE0                : in  std_logic;
            MODE1                : in  std_logic;
            MODE2                : in  std_logic;
            MODE3                : in  std_logic;

            -- lpGBT Ready signal
            READY                : out std_logic;

            -- Power On Reset Disable
            PORDIS               : in  std_logic;

            -- reference clock
            REFCLKP              : in  std_logic;
            REFCLKN              : in  std_logic;

            -- Test clock (used only for debugging)
            --TSTCLKINP            : in  std_logic;
            --TSTCLKINN            : in  std_logic;

            -- Bypass VCO and use test clock (TSTCLKIN) instead
            --VCOBYPASS            : in  std_logic;

            -- State override for the power up state machine
            --STATEOVRD            : in  std_logic;

            -- Selects configuration interface (0=SerialControll1=Slave I2C)
            --SC_I2C               : in  std_logic;

            -- Test outputs (0-3 CMOS 4-5 differential)
            TSTOUT0              : out std_logic;
            TSTOUT1              : out std_logic;
            TSTOUT2              : out std_logic;
            TSTOUT3              : out std_logic;
            TSTOUT4P             : out std_logic;
            TSTOUT4N             : out std_logic;
            TSTOUT5P             : out std_logic;
            TSTOUT5N             : out std_logic;

            -- I2C Master 0 signals
            M0SDA                : inout std_logic;
            M0SCL                : inout std_logic;

            -- I2C Master 1 signals
            M1SDA                : inout std_logic;
            M1SCL                : inout std_logic;

            -- I2C Master 2 signals
            M2SDA                : inout std_logic;
            M2SCL                : inout std_logic;

            -- Parallel I/O
            GPIO0                : inout std_logic;
            GPIO1                : inout std_logic;
            GPIO2                : inout std_logic;
            GPIO3                : inout std_logic;
            GPIO4                : inout std_logic;
            GPIO5                : inout std_logic;
            GPIO6                : inout std_logic;
            GPIO7                : inout std_logic;
            GPIO8                : inout std_logic;
            GPIO9                : inout std_logic;
            GPIO10               : inout std_logic;
            GPIO11               : inout std_logic;
            GPIO12               : inout std_logic;
            GPIO13               : inout std_logic;
            GPIO14               : inout std_logic;
            GPIO15               : inout std_logic;

            -- ADC (and current source output)
            ADC0                 : inout std_logic;
            ADC1                 : inout std_logic;
            ADC2                 : inout std_logic;
            ADC3                 : inout std_logic;
            ADC4                 : inout std_logic;
            ADC5                 : inout std_logic;
            ADC6                 : inout std_logic;
            ADC7                 : inout std_logic;

            -- Voltage DAC output
            VDAC                 : out std_logic;

            -- reference voltage
            VREF                 : inout std_logic;

            -- debug signals (not present on the chip package)
            debug_registers     : out std_logic_vector(463*8-1 downto 0);
            debug_testOutputs   : out std_logic_vector(127 downto 0)
        );
    END COMPONENT;

    -- lpGBT modes of operation
    constant LPGBT_5G_FEC5_OFF      : std_logic_vector(3 downto 0) := "0000";
    constant LPGBT_5G_FEC5_TX       : std_logic_vector(3 downto 0) := "0001";
    constant LPGBT_5G_FEC5_RX       : std_logic_vector(3 downto 0) := "0010";
    constant LPGBT_5G_FEC5_TRX      : std_logic_vector(3 downto 0) := "0011";

    constant LPGBT_5G_FEC12_OFF     : std_logic_vector(3 downto 0) := "0100";
    constant LPGBT_5G_FEC12_TX      : std_logic_vector(3 downto 0) := "0101";
    constant LPGBT_5G_FEC12_RX      : std_logic_vector(3 downto 0) := "0110";
    constant LPGBT_5G_FEC12_TRX     : std_logic_vector(3 downto 0) := "0111";

    constant LPGBT_10G_FEC5_OFF     : std_logic_vector(3 downto 0) := "1000";
    constant LPGBT_10G_FEC5_TX      : std_logic_vector(3 downto 0) := "1001";
    constant LPGBT_10G_FEC5_RX      : std_logic_vector(3 downto 0) := "1010";
    constant LPGBT_10G_FEC5_TRX     : std_logic_vector(3 downto 0) := "1011";

    constant LPGBT_10G_FEC12_OFF    : std_logic_vector(3 downto 0) := "1100";
    constant LPGBT_10G_FEC12_TX     : std_logic_vector(3 downto 0) := "1101";
    constant LPGBT_10G_FEC12_RX     : std_logic_vector(3 downto 0) := "1110";
    constant LPGBT_10G_FEC12_TRX    : std_logic_vector(3 downto 0) := "1111";

    -- Signals
    signal refclk_n                 : std_logic;	
    signal dat_downLinkSerial_n_s   : std_logic;

    signal dat_eport0_n_s           : std_logic;
    signal dat_eport1_n_s           : std_logic;
    signal dat_eport2_n_s           : std_logic;
    signal dat_eport3_n_s           : std_logic;

    signal dat_eport10_n_s          : std_logic;
    signal dat_eport11_n_s          : std_logic;
    signal dat_eport12_n_s          : std_logic;
    signal dat_eport13_n_s          : std_logic;

    signal dat_eport20_n_s          : std_logic;
    signal dat_eport21_n_s          : std_logic;
    signal dat_eport22_n_s          : std_logic;
    signal dat_eport23_n_s          : std_logic;

    signal dat_eport30_n_s          : std_logic;
    signal dat_eport31_n_s          : std_logic;
    signal dat_eport32_n_s          : std_logic;
    signal dat_eport33_n_s          : std_logic;

    signal dat_eport40_n_s          : std_logic;
    signal dat_eport41_n_s          : std_logic;
    signal dat_eport42_n_s          : std_logic;
    signal dat_eport43_n_s          : std_logic;

    signal dat_eport50_n_s          : std_logic;
    signal dat_eport51_n_s          : std_logic;
    signal dat_eport52_n_s          : std_logic;
    signal dat_eport53_n_s          : std_logic;

    signal dat_eport60_n_s          : std_logic;
    signal dat_eport61_n_s          : std_logic;
    signal dat_eport62_n_s          : std_logic;
    signal dat_eport63_n_s          : std_logic;

    signal dat_ec_n_s               : std_logic;

    signal conf_mode_s              : std_logic_vector(3 downto 0);

    signal SLSDA_s                  : std_logic;
    signal SLSCL_s                  : std_logic;

    signal dat_ec_tosca_s           : std_logic;
    signal dat_ec_fromsca_s         : std_logic;

    signal clk_eport28_s            : std_logic;

begin                 --========####   Architecture Body   ####========--

    -- Mode configuration
    conf_mode_s              <= LPGBT_5G_FEC12_TRX  when DATARATE = DATARATE_5G12 and FEC = FEC12 else
                                LPGBT_5G_FEC5_TRX   when DATARATE = DATARATE_5G12 and FEC = FEC5 else
                                LPGBT_10G_FEC5_TRX  when DATARATE = DATARATE_10G24 and FEC = FEC5 else
                                LPGBT_10G_FEC12_TRX;

    SLSDA_s <= '1';
    SLSCL_s <= '1';

    -- Negative signals association
    dat_downLinkSerial_n_s   <= not(dat_downLinkSerial_i);

    dat_eport0_n_s           <= not (dat_eport0_i);
    dat_eport1_n_s           <= not (dat_eport1_i);
    dat_eport2_n_s           <= not (dat_eport2_i);
    dat_eport3_n_s           <= not (dat_eport3_i);

    dat_eport10_n_s          <= not (dat_eport10_i);
    dat_eport11_n_s          <= not (dat_eport11_i);
    dat_eport12_n_s          <= not (dat_eport12_i);
    dat_eport13_n_s          <= not (dat_eport13_i);

    dat_eport20_n_s          <= not (dat_eport20_i);
    dat_eport21_n_s          <= not (dat_eport21_i);
    dat_eport22_n_s          <= not (dat_eport22_i);
    dat_eport23_n_s          <= not (dat_eport23_i);

    dat_eport30_n_s          <= not (dat_eport30_i);
    dat_eport31_n_s          <= not (dat_eport31_i);
    dat_eport32_n_s          <= not (dat_eport32_i);
    dat_eport33_n_s          <= not (dat_eport33_i);

    dat_eport40_n_s          <= not (dat_eport40_i);
    dat_eport41_n_s          <= not (dat_eport41_i);
    dat_eport42_n_s          <= not (dat_eport42_i);
    dat_eport43_n_s          <= not (dat_eport43_i);

    dat_eport50_n_s          <= not (dat_eport50_i);
    dat_eport51_n_s          <= not (dat_eport51_i);
    dat_eport52_n_s          <= not (dat_eport52_i);
    dat_eport53_n_s          <= not (dat_eport53_i);

    dat_eport60_n_s          <= not (dat_eport60_i);
    dat_eport61_n_s          <= not (dat_eport61_i);
    dat_eport62_n_s          <= not (dat_eport62_i);
    dat_eport63_n_s          <= not (dat_eport63_i);

    dat_ec_n_s               <= not (dat_ec_fromsca_s);

    clk_eport28_o            <= clk_eport28_s;

refclk_n <= not refclk_i;

    LpGBT_Model_inst: lpGBT_model
        PORT MAP(
            -- CORE and IO power supply
            GND                  => '0',
            VDD1V2               => '1',

            -- Transmitter power supply
            GNDTX                => '0',
            VDDTX1V2             => '1',

            -- Receiver power supply
            GNDRX                => '0',
            VDDRX1V2             => '1',

            -- Analog power supply
            GNDA                 => '0',
            VDDA1V2              => '1',

            -- Fuses power supply (uses GND for return currents)
            VDDF2V5              => '0',

            -- High speed serializer outputs
            HSOUTP               => dat_upLinkSerial_o,
            HSOUTN               => open,

            -- High speed deserializer inputs
            HSINP                => dat_downLinkSerial_i,
            HSINN                => dat_downLinkSerial_n_s,

            -- ePort clock differential outputs
            ECLK0P               => clk_eport0_o,
            ECLK0N               => open,

            ECLK1P               => clk_eport1_o,
            ECLK1N               => open,

            ECLK2P               => clk_eport2_o,
            ECLK2N               => open,

            ECLK3P               => clk_eport3_o,
            ECLK3N               => open,

            ECLK4P               => clk_eport4_o,
            ECLK4N               => open,

            ECLK5P               => clk_eport5_o,
            ECLK5N               => open,

            ECLK6P               => clk_eport6_o,
            ECLK6N               => open,

            ECLK7P               => clk_eport7_o,
            ECLK7N               => open,

            ECLK8P               => clk_eport8_o,
            ECLK8N               => open,

            ECLK9P               => clk_eport9_o,
            ECLK9N               => open,

            ECLK10P              => clk_eport10_o,
            ECLK10N              => open,

            ECLK11P              => clk_eport11_o,
            ECLK11N              => open,

            ECLK12P              => clk_eport12_o,
            ECLK12N              => open,

            ECLK13P              => clk_eport13_o,
            ECLK13N              => open,

            ECLK14P              => clk_eport14_o,
            ECLK14N              => open,

            ECLK15P              => clk_eport15_o,
            ECLK15N              => open,

            ECLK16P              => clk_eport16_o,
            ECLK16N              => open,

            ECLK17P              => clk_eport17_o,
            ECLK17N              => open,

            ECLK18P              => clk_eport18_o,
            ECLK18N              => open,

            ECLK19P              => clk_eport19_o,
            ECLK19N              => open,

            ECLK20P              => clk_eport20_o,
            ECLK20N              => open,

            ECLK21P              => clk_eport21_o,
            ECLK21N              => open,

            ECLK22P              => clk_eport22_o,
            ECLK22N              => open,

            ECLK23P              => clk_eport23_o,
            ECLK23N              => open,

            ECLK24P              => clk_eport24_o,
            ECLK24N              => open,

            ECLK25P              => clk_eport25_o,
            ECLK25N              => open,

            ECLK26P              => clk_eport26_o,
            ECLK26N              => open,

            ECLK27P              => clk_eport27_o,
            ECLK27N              => open,

            ECLK28P              => clk_eport28_s,
            ECLK28N              => open,

            -- ePortTX group 0 differential data outputs (downlink)
            EDOUT00P             => dat_eport0_o,
            EDOUT00N             => open,
            EDOUT01P             => dat_eport1_o,
            EDOUT01N             => open,
            EDOUT02P             => dat_eport2_o,
            EDOUT02N             => open,
            EDOUT03P             => dat_eport3_o,
            EDOUT03N             => open,

            -- ePortTX group 1 differential data outputs (downlink)
            EDOUT10P             => dat_eport10_o,
            EDOUT10N             => open,
            EDOUT11P             => dat_eport11_o,
            EDOUT11N             => open,
            EDOUT12P             => dat_eport12_o,
            EDOUT12N             => open,
            EDOUT13P             => dat_eport13_o,
            EDOUT13N             => open,

            -- ePortTX group 2 differential data outputs (downlink)
            EDOUT20P             => dat_eport20_o,
            EDOUT20N             => open,
            EDOUT21P             => dat_eport21_o,
            EDOUT21N             => open,
            EDOUT22P             => dat_eport22_o,
            EDOUT22N             => open,
            EDOUT23P             => dat_eport23_o,
            EDOUT23N             => open,

            -- ePortTX group 3 differential data outputs (downlink)
            EDOUT30P             => dat_eport30_o,
            EDOUT30N             => open,
            EDOUT31P             => dat_eport31_o,
            EDOUT31N             => open,
            EDOUT32P             => dat_eport32_o,
            EDOUT32N             => open,
            EDOUT33P             => dat_eport33_o,
            EDOUT33N             => open,

            -- ePortTX EC differential data outputs
            EDOUTECP             => dat_ec_tosca_s,
            EDOUTECN             => open,

            -- ePortRX group 0 differential data inputs (uplink)
            EDIN00P              => dat_eport0_i,
            EDIN00N              => dat_eport0_n_s,
            EDIN01P              => dat_eport1_i,
            EDIN01N              => dat_eport1_n_s,
            EDIN02P              => dat_eport2_i,
            EDIN02N              => dat_eport2_n_s,
            EDIN03P              => dat_eport3_i,
            EDIN03N              => dat_eport3_n_s,

            -- ePortRX group 1 differential data inputs (uplink)
            EDIN10P              => dat_eport10_i,
            EDIN10N              => dat_eport10_n_s,
            EDIN11P              => dat_eport11_i,
            EDIN11N              => dat_eport11_n_s,
            EDIN12P              => dat_eport12_i,
            EDIN12N              => dat_eport12_n_s,
            EDIN13P              => dat_eport13_i,
            EDIN13N              => dat_eport13_n_s,

            -- ePortRX group 2 differential data inputs (uplink)
            EDIN20P              => dat_eport20_i,
            EDIN20N              => dat_eport20_n_s,
            EDIN21P              => dat_eport21_i,
            EDIN21N              => dat_eport21_n_s,
            EDIN22P              => dat_eport22_i,
            EDIN22N              => dat_eport22_n_s,
            EDIN23P              => dat_eport23_i,
            EDIN23N              => dat_eport23_n_s,

            -- ePortRX group 3 differential data inputs (uplink)
            EDIN30P              => dat_eport30_i,
            EDIN30N              => dat_eport30_n_s,
            EDIN31P              => dat_eport31_i,
            EDIN31N              => dat_eport31_n_s,
            EDIN32P              => dat_eport32_i,
            EDIN32N              => dat_eport32_n_s,
            EDIN33P              => dat_eport33_i,
            EDIN33N              => dat_eport33_n_s,

            -- ePortRX group 4 differential data inputs (uplink)
            EDIN40P              => dat_eport40_i,
            EDIN40N              => dat_eport40_n_s,
            EDIN41P              => dat_eport41_i,
            EDIN41N              => dat_eport41_n_s,
            EDIN42P              => dat_eport42_i,
            EDIN42N              => dat_eport42_n_s,
            EDIN43P              => dat_eport43_i,
            EDIN43N              => dat_eport43_n_s,

            -- ePortRX group 5 differential data inputs (uplink)
            EDIN50P              => dat_eport50_i,
            EDIN50N              => dat_eport50_n_s,
            EDIN51P              => dat_eport51_i,
            EDIN51N              => dat_eport51_n_s,
            EDIN52P              => dat_eport52_i,
            EDIN52N              => dat_eport52_n_s,
            EDIN53P              => dat_eport53_i,
            EDIN53N              => dat_eport53_n_s,

            -- ePortRX group 6 differential data inputs (uplink)
            EDIN60P              => dat_eport60_i,
            EDIN60N              => dat_eport60_n_s,
            EDIN61P              => dat_eport61_i,
            EDIN61N              => dat_eport61_n_s,
            EDIN62P              => dat_eport62_i,
            EDIN62N              => dat_eport62_n_s,
            EDIN63P              => dat_eport63_i,
            EDIN63N              => dat_eport63_n_s,

            -- ePortRX EC differential data inputs
            EDINECP              => dat_ec_fromsca_s,
            EDINECN              => dat_ec_n_s,

            -- Phase shifted clocks
            PSCLK0P              => clk_psclk0_o,
            PSCLK0N              => open,
            PSCLK1P              => clk_psclk1_o,
            PSCLK1N              => open,
            PSCLK2P              => clk_psclk2_o,
            PSCLK2N              => open,
            PSCLK3P              => clk_psclk3_o,
            PSCLK3N              => open,

            -- I2C slave for ASIC control
            SLSDA                => SLSDA_s,       -- JM: Unused (future implementation)
            SLSCL                => SLSCL_s,       -- JM: Unused (future implementation)

            -- Address                          -- JM: Fixed (future implementation)
            ADR0                 => '0',
            ADR1                 => '0',
            ADR2                 => '0',
            ADR3                 => '0',

            -- lock mode
            LOCKMODE             => '1', -- 0 for PLL mode, 1 for CDR

            -- reset (active low)
            RSTB                 => '1', 

            -- reset signal
            RSTOUTB              => open,

            -- mode of operation
            MODE0                => conf_mode_s(0),
            MODE1                => conf_mode_s(1),
            MODE2                => conf_mode_s(2),
            MODE3                => conf_mode_s(3),

            -- lpGBT Ready signal
            READY                => stat_lpgbtrdy_o,

            -- Power On Reset Disable
            PORDIS               => '0',

            -- reference clock
            REFCLKP              => '0', -- refclk_i,--
            REFCLKN              => '0', -- refclk_n,--

            -- Test clock (used only for debugging)
            --TSTCLKINP            => '1',
            --TSTCLKINN            => '0',

            -- Bypass VCO and use test clock (TSTCLKIN) instead
            --VCOBYPASS            => '0',

            -- State override for the power up state machine
            --STATEOVRD            => '0',

            -- Selects configuration interface (0=SerialControll1=Slave I2C)
            --SC_I2C               => '0',    -- JM: Enable IC interface

            -- Test outputs (0-3 CMOS 4-5 differential)
            TSTOUT0              => open,
            TSTOUT1              => open,
            TSTOUT2              => open,
            TSTOUT3              => open,
            TSTOUT4P             => open,
            TSTOUT4N             => open,
            TSTOUT5P             => open,
            TSTOUT5N             => open,

            -- I2C Master 0 signals
            M0SDA                => dat_i2cm0_sda,
            M0SCL                => clk_i2cm0_scl,

            -- I2C Master 1 signals
            M1SDA                => dat_i2cm1_sda,
            M1SCL                => clk_i2cm1_scl,

            -- I2C Master 2 signals
            M2SDA                => dat_i2cm2_sda,
            M2SCL                => clk_i2cm2_scl,

            -- Parallel I/O
            GPIO0                => dat_gpio0_io,
            GPIO1                => dat_gpio1_io,
            GPIO2                => dat_gpio2_io,
            GPIO3                => dat_gpio3_io,
            GPIO4                => dat_gpio4_io,
            GPIO5                => dat_gpio5_io,
            GPIO6                => dat_gpio6_io,
            GPIO7                => dat_gpio7_io,
            GPIO8                => dat_gpio8_io,
            GPIO9                => dat_gpio9_io,
            GPIO10               => dat_gpio10_io,
            GPIO11               => dat_gpio11_io,
            GPIO12               => dat_gpio12_io,
            GPIO13               => dat_gpio13_io,
            GPIO14               => dat_gpio14_io,
            GPIO15               => dat_gpio15_io,

            -- ADC (and current source output)
            ADC0                 => open,
            ADC1                 => open,
            ADC2                 => open,
            ADC3                 => open,
            ADC4                 => open,
            ADC5                 => open,
            ADC6                 => open,
            ADC7                 => open,

            -- Voltage DAC output
            VDAC                 => open,

            -- reference voltage
            VREF                 => open,

            -- debug signals (not present on the chip package)
            debug_registers     => open,
            debug_testOutputs   => open
        );

    --clk_eport28_s
    dat_ec_fromsca_s <= '0';

end behabioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--
