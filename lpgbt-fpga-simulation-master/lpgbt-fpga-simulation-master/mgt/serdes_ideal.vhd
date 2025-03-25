-------------------------------------------------------
--! @file
--! @author Eduardo Mendes <eduardo.brandao.de.souza.mendes@cern.ch> (CERN - EP-ESE-BE)
--! @version 2.0
--! @brief Ideal serdes for simulation
--! This module assumes an ideal transmitted serial stream and received serial stream
--! For simulation purposes, keep the uplink in reset state until the received stream is stable
-------------------------------------------------------

--! Include the IEEE VHDL standard library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Include the LpGBT-FPGA specific package
use work.lpgbtfpga_package.all;

entity serdes_ideal is 
       generic(
            DATARATE                     : integer range 0 to 2 := DATARATE_5G12  --! Datarate selection can be: DATARATE_10G24 or DATARATE_5G12   
	   );	
       port (
            --=============--
            -- Clocks      --
            --=============--
            MGT_SERCLK_i                 : in  std_logic;
            MGT_FREEDRPCLK_i             : in  std_logic;

            MGT_RXUSRCLK_o               : out std_logic;
            MGT_TXUSRCLK_o               : out std_logic;
            
            --=============--
            -- Resets      --
            --=============--
            MGT_TXRESET_i                : in  std_logic;
            MGT_RXRESET_i                : in  std_logic;
            
            --=============--
            -- Control     --
            --=============--
            MGT_TXPolarity_i             : in  std_logic;	   
            MGT_RXPolarity_i             : in  std_logic;	   
            MGT_RXSlide_i                : in  std_logic;
            
            --=============--
            -- Status      --
            --=============--
            MGT_TXREADY_o                : out std_logic;
            MGT_RXREADY_o                : out std_logic;

            --==============--
            -- Data         --
            --==============--
            MGT_USRWORD_i                : in  std_logic_vector(16*DATARATE-1 downto 0);
            MGT_USRWORD_o                : out std_logic_vector(16*DATARATE-1 downto 0);
            
            --===============--
            -- Serial intf.  --
            --===============--
            RX_i                        : in  std_logic;
            TX_o                        : out std_logic
       );
end serdes_ideal;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture high_level of serdes_ideal is

  -- clocks
  signal mgt_txusrclk    : std_logic := '0';  -- low-speed parallel clock
  signal mgt_txhsclk     : std_logic := '0' ; -- high-speed clock	
  signal mgt_rxusrclk    : std_logic := '0';  -- low-speed parallel clock	 
  signal mgt_rxhsclk     : std_logic := '0';  -- high-speed clock	
  
  -- serdes
  signal mgt_tx_parallel    : std_logic_vector(16*DATARATE-1 downto 0);
  signal mgt_rx_parallel    : std_logic_vector(16*DATARATE-1 downto 0);
  signal mgt_rx_parallel_r  : std_logic_vector(16*DATARATE-1 downto 0);
  signal mgt_rx_data        : std_logic_vector(2*16*DATARATE-1 downto 0);  
  signal mgt_rx_bitslide    : integer range 0 to 16*DATARATE-1 := 0;
  
begin                 --========####   Architecture Body   ####========--



  -- Tx
  MGT_TXUSRCLK_o <= mgt_txusrclk;
  p_mgt_tx_user_clock : process
  begin
      if(MGT_TXRESET_i/='0') then
        mgt_txusrclk  <= '0';
        MGT_TXREADY_o <= '0';
        wait until rising_edge(MGT_SERCLK_i);	  		
      else
        for i in 0 to 16*DATARATE/2-1 loop
            wait until rising_edge(MGT_SERCLK_i);	 		
            mgt_txusrclk <= '0';
        end loop;
        for i in 0 to 16*DATARATE/2-1 loop
            wait until rising_edge(MGT_SERCLK_i);	 		
            mgt_txusrclk <= '1';
        end loop;
        MGT_TXREADY_o <= '1';		
      end if;
  end process;

  p_mgt_tx_ser : process
  begin
      if(MGT_TXRESET_i/='0') then
        Tx_o  <= 'X';
        mgt_tx_parallel <= (others => 'X');		
        wait until rising_edge(MGT_SERCLK_i);	  
      else
        wait until rising_edge(mgt_txusrclk);	
        mgt_tx_parallel <= MGT_USRWORD_i;
        for i in 0 to 16*DATARATE-1 loop
          wait until falling_edge(MGT_SERCLK_i);
          mgt_tx_parallel(mgt_tx_parallel'left downto 0) <= '0'&mgt_tx_parallel(mgt_tx_parallel'left downto 1);
		  Tx_o <= mgt_tx_parallel(0) xor MGT_TXPolarity_i; 
		end loop;
      end if;
  end process;

  -- Rx
  -- Clock recovery is not implemented
  -- Assumes the incoming serial stream is sync to the high-speed transmitter clock (generally true)
  
  MGT_RXUSRCLK_o <= mgt_rxusrclk;
  p_mgt_rx_user_clock : process
  begin
      if(MGT_RXRESET_i/='0') then
        mgt_rxusrclk   <= '0';
        MGT_RXREADY_o  <= '0';		
        wait until rising_edge(MGT_SERCLK_i);	  		
      else
        for i in 0 to 16*DATARATE/2-1 loop
            wait until rising_edge(MGT_SERCLK_i);	 		
            mgt_rxusrclk <= '0';
        end loop;
        for i in 0 to 16*DATARATE/2-1 loop
            wait until rising_edge(MGT_SERCLK_i);	 		
            mgt_rxusrclk <= '1';
        end loop;
        MGT_RXREADY_o  <= '1';			
      end if;
  end process;
  
  p_mgt_rx_des : process
  begin  
      if(MGT_RXRESET_i/='0') then
        mgt_rx_parallel  <= (others => 'X');
        wait until rising_edge(MGT_SERCLK_i);	  		
      else
        wait until falling_edge(MGT_SERCLK_i);	
        mgt_rx_parallel(mgt_rx_parallel'left)            <= (RX_i xor MGT_RXPolarity_i);
        mgt_rx_parallel(mgt_rx_parallel'left-1 downto 0) <= mgt_rx_parallel(mgt_rx_parallel'left downto 1);
      end if;
  end process;  
  
  mgt_rx_parallel_r   <= mgt_rx_parallel                                                                  when rising_edge(mgt_rxusrclk);
  mgt_rx_data         <= mgt_rx_parallel_r&mgt_rx_data(mgt_rx_data'length-1 downto mgt_rx_data'length/2)  when rising_edge(mgt_rxusrclk);
  MGT_USRWORD_o       <= mgt_rx_data(16*DATARATE+mgt_rx_bitslide-1 downto mgt_rx_bitslide)                when rising_edge(mgt_rxusrclk);

  p_mgt_bitslide : process
  begin
      if(MGT_RXRESET_i/='0') then
        mgt_rx_bitslide <= 0;
        wait until rising_edge(MGT_SERCLK_i);	    		
      else
        wait until rising_edge(MGT_RXSlide_i);	
        wait until rising_edge(mgt_rxusrclk);			
        if(mgt_rx_bitslide=16*DATARATE-1) then
            mgt_rx_bitslide <= 0;
		else
            mgt_rx_bitslide <= mgt_rx_bitslide+1;
		end if;
      end if;
  end process;  
  
end high_level;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--