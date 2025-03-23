-------------------------------------------------------
--! @file
--! @author Julian Mendez <julian.mendez@cern.ch> (CERN - EP-ESE-BE)
--! @version 2.0
--! @brief 58bit Order 60 descrambler
-------------------------------------------------------

--! Include the IEEE VHDL standard LIBRARY
LIBRARY ieee;
USE ieee.std_logic_1164.all;

--! Include the lpGBT-FPGA specific package
USE work.lpgbtfpga_package.all;

--! @brief descrambler60bitOrder58 - 58bit Order 60 descrambler
ENTITY descrambler60bitOrder58 IS
   PORT (
        -- Clocks & reset
        clk_i                             : in  std_logic;
        clkEn_i                           : in  std_logic;

        reset_i                           : in  std_logic;

        -- Data
        data_i                            : in  std_logic_vector(59 downto 0);
        data_o                            : out std_logic_vector(59 downto 0);

        -- Control
        bypass                            : in  std_logic
   );
END descrambler60bitOrder58;

--! @brief descrambler60bitOrder58 ARCHITECTURE - 58bit Order 60 descrambler
ARCHITECTURE behavioral OF descrambler60bitOrder58 IS

    SIGNAL memory_register        : std_logic_vector(59 downto 0);
    SIGNAL descrambledData        : std_logic_vector(59 downto 0);

    attribute keep : string;
    attribute keep of descrambledData : signal is "true";
    attribute keep of memory_register : signal is "true"; 
	
BEGIN                 --========####   Architecture Body   ####========--

    -- Scrambler output register
    reg_proc: PROCESS(clk_i)
    BEGIN

        IF rising_edge(clk_i) THEN
            IF reset_i = '1' THEN
                descrambledData  <= (OTHERS => '0');
                memory_register  <= (OTHERS => '0');

            ELSIF clkEn_i = '1' THEN
                memory_register               <=  data_i;

                if bypass = '1' then
                  descrambledData <= data_i;
				else
                  descrambledData(59 downto 58) <=  data_i(59 downto 58) xnor data_i(20 downto 19) xnor data_i(1 downto 0);
                  descrambledData(57 downto 39) <=  data_i(57 downto 39) xnor data_i(18 downto 0) xnor memory_register(57 downto 39);
                  descrambledData(38 downto 0)  <=  data_i(38 downto 0)  xnor memory_register(57 downto 19) xnor memory_register(38 downto 0);
                end if;

            END IF;

        END IF;

    END PROCESS;

    data_o    <= descrambledData;

END behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--