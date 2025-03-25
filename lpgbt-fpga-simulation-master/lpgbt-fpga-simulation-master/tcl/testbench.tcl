proc compile_project {} {

	set library_file_list {
		work {	lpgbt_model/rtl/questa/lpGBT.svp	
                hdl/lpGBT_model.v		
                lpgbt-fpga/lpgbtfpga_package.vhd
                lpgbt-fpga/downlink/rs_encoder_N7K5.vhd
                lpgbt-fpga/downlink/lpgbtfpga_txgearbox.vhd
                lpgbt-fpga/downlink/lpgbtfpga_interleaver.vhd
                lpgbt-fpga/downlink/lpgbtfpga_scrambler.vhd
                lpgbt-fpga/downlink/lpgbtfpga_encoder.vhd
                lpgbt-fpga/lpgbtfpga_downlink.vhd
                lpgbt-fpga/uplink/descrambler_51bitOrder49.vhd
                lpgbt-fpga/uplink/descrambler_53bitOrder49.vhd
                lpgbt-fpga/uplink/descrambler_58bitOrder58.vhd
                lpgbt-fpga/uplink/descrambler_60bitOrder58.vhd
                lpgbt-fpga/uplink/fec_rsDecoderN15K13.vhd
                lpgbt-fpga/uplink/fec_rsDecoderN31K29.vhd
                lpgbt-fpga/uplink/lpgbtfpga_decoder.vhd
                lpgbt-fpga/uplink/lpgbtfpga_deinterleaver.vhd
                lpgbt-fpga/uplink/lpgbtfpga_descrambler.vhd
                lpgbt-fpga/uplink/lpgbtfpga_framealigner.vhd
                lpgbt-fpga/uplink/lpgbtfpga_rxgearbox.vhd
                lpgbt-fpga/lpgbtfpga_uplink.vhd
                mgt/serdes_ideal.vhd
                cdc_user/cdc_rx.vhd			
                cdc_user/cdc_tx.vhd
                hdl/bus_multiplexer_pkg.vhd			
                hdl/lpgbtfpga.vhd
                hdl/prbs/prbs7_1b_checker.vhd
                hdl/prbs/prbs7_2b_checker.vhd
                hdl/prbs/prbs7_4b_checker.vhd
                hdl/prbs/prbs7_8b_checker.vhd
                hdl/prbs/prbs7_16b_checker.vhd
                hdl/prbs/prbs7_32b_checker.vhd
                hdl/prbs/prbs7_1b_generator.vhd
                hdl/prbs/prbs7_2b_generator.vhd
                hdl/prbs/prbs7_4b_generator.vhd
                hdl/prbs/prbs7_8b_generator.vhd
                hdl/prbs/prbs7_64b_generator.vhd
                hdl/lpgbtfpga_patternchecker.vhd
                hdl/lpgbtfpga_patterngen.vhd
                hdl/lpgbtfpga_sim.vhd
				hdl/lpgbt_model_wrapper.vhd
                hdl/top_tb.vhd
				}

	}

	foreach {library file_list} $library_file_list {
	  vlib $library
	  vmap work $library

	  foreach file $file_list {
		if [regexp {.vhdl?$} $file] {
			if {[catch {vcom -93 $file} ccode]} {
				return -2
			}
		} else {
			if {[catch {vlog $file} ccode]} {
				return -2
			}
		}
	  }
	}

    return 0
}

proc simulate {fec datarate} {
    eval vsim -voptargs=+acc=lprn work.top_tb -gFEC=$fec -gDATARATE=$datarate -t 1ps -suppress vopt-7063
    reset_waves
}

proc reset_waves {} {
	delete wave *

	add wave -noupdate -divider -height 20 "Clock & Reset"
	add wave -label "Bunch Clock"  	        sim:/top_tb/clk_bunch_clock

	add wave -label "FPGA Down rst"             sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_downlinkrst_s
	add wave -label "FPGA Down rdy"             sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_downlinkrdy_s
	add wave -label "FPGA Up rst"               sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_uplinkrst_s
	add wave -label "FPGA Up rdy"               sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_uplinkrdy_s

    add wave -label "ASIC RstN"                 sim:/top_tb/lpgbt_rstn_s
    add wave -label "ASIC Rdy"                  sim:/top_tb/lpgbt_rdy_s

	add wave -noupdate -divider -height 20 "Serial lanes"
	add wave -label "Clock MGT Serial"   sim:/top_tb/clk_mgtser	
	add wave -label "Downlink"  		        sim:/top_tb/downlinkSerial
    add wave -label "Uplink"                    sim:/top_tb/uplinkSerial

	add wave -noupdate -divider -height 20 "LpGBT-FPGA Downlink"
	add wave -label "Downlink user"  	        sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_downlinkUserData_s
	add wave -label "Downlink EC"  	            sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_downlinkEcData_s
	add wave -label "Downlink IC"     	        sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_downlinkIcData_s

	add wave -noupdate -divider -height 20 "LpGBT-FPGA Uplink"
	add wave -label "Uplink user"  	            sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_uplinkUserData_s
	add wave -label "Uplink EC"  	            sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_uplinkEcData_s
	add wave -label "Uplink IC"     	        sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_uplinkIcData_s

    add wave -noupdate -divider -height 20 "LpGBT Downlink"
    add wave -label "ePort 0"                   sim:/top_tb/dat_eport0_downlink_s
    add wave -label "ePort 1"                   sim:/top_tb/dat_eport1_downlink_s
    add wave -label "ePort 2"                   sim:/top_tb/dat_eport2_downlink_s
    add wave -label "ePort 3"                   sim:/top_tb/dat_eport3_downlink_s
    add wave -label "ePort 4"                   sim:/top_tb/dat_eport10_downlink_s
    add wave -label "ePort 5"                   sim:/top_tb/dat_eport11_downlink_s
    add wave -label "ePort 6"                   sim:/top_tb/dat_eport12_downlink_s
    add wave -label "ePort 7"                   sim:/top_tb/dat_eport13_downlink_s
    add wave -label "ePort 8"                   sim:/top_tb/dat_eport20_downlink_s
    add wave -label "ePort 9"                   sim:/top_tb/dat_eport21_downlink_s
    add wave -label "ePort 10"                  sim:/top_tb/dat_eport22_downlink_s
    add wave -label "ePort 11"                  sim:/top_tb/dat_eport23_downlink_s
    add wave -label "ePort 12"                  sim:/top_tb/dat_eport30_downlink_s
    add wave -label "ePort 13"                  sim:/top_tb/dat_eport31_downlink_s
    add wave -label "ePort 14"                  sim:/top_tb/dat_eport32_downlink_s
    add wave -label "ePort 15"                  sim:/top_tb/dat_eport33_downlink_s

    add wave -noupdate -divider -height 20 "LpGBT Uplink"
    add wave -label "ePort 0"                   sim:/top_tb/dat_eport0_uplink_s
    add wave -label "ePort 1"                   sim:/top_tb/dat_eport1_uplink_s
    add wave -label "ePort 2"                   sim:/top_tb/dat_eport2_uplink_s
    add wave -label "ePort 3"                   sim:/top_tb/dat_eport3_uplink_s
    add wave -label "ePort 4"                   sim:/top_tb/dat_eport10_uplink_s
    add wave -label "ePort 5"                   sim:/top_tb/dat_eport11_uplink_s
    add wave -label "ePort 6"                   sim:/top_tb/dat_eport12_uplink_s
    add wave -label "ePort 7"                   sim:/top_tb/dat_eport13_uplink_s
    add wave -label "ePort 8"                   sim:/top_tb/dat_eport20_uplink_s
    add wave -label "ePort 9"                   sim:/top_tb/dat_eport21_uplink_s
    add wave -label "ePort 10"                  sim:/top_tb/dat_eport22_uplink_s
    add wave -label "ePort 11"                  sim:/top_tb/dat_eport23_uplink_s
    add wave -label "ePort 12"                  sim:/top_tb/dat_eport30_uplink_s
    add wave -label "ePort 13"                  sim:/top_tb/dat_eport31_uplink_s
    add wave -label "ePort 14"                  sim:/top_tb/dat_eport32_uplink_s
    add wave -label "ePort 15"                  sim:/top_tb/dat_eport33_uplink_s
    add wave -label "ePort 16"                  sim:/top_tb/dat_eport40_uplink_s
    add wave -label "ePort 17"                  sim:/top_tb/dat_eport41_uplink_s
    add wave -label "ePort 18"                  sim:/top_tb/dat_eport42_uplink_s
    add wave -label "ePort 19"                  sim:/top_tb/dat_eport43_uplink_s
    add wave -label "ePort 20"                  sim:/top_tb/dat_eport50_uplink_s
    add wave -label "ePort 21"                  sim:/top_tb/dat_eport51_uplink_s
    add wave -label "ePort 22"                  sim:/top_tb/dat_eport52_uplink_s
    add wave -label "ePort 23"                  sim:/top_tb/dat_eport53_uplink_s
    add wave -label "ePort 24"                  sim:/top_tb/dat_eport60_uplink_s
    add wave -label "ePort 25"                  sim:/top_tb/dat_eport61_uplink_s
    add wave -label "ePort 26"                  sim:/top_tb/dat_eport62_uplink_s
    add wave -label "ePort 27"                  sim:/top_tb/dat_eport63_uplink_s

    add wave -noupdate -divider -height 20 "LpGBT eClks"
    add wave -label "eClk0"                      sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport0_o
    add wave -label "eClk1"                      sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport1_o
    add wave -label "eClk2"                      sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport2_o
    add wave -label "eClk3"                      sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport3_o
    add wave -label "eClk4"                      sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport4_o
    add wave -label "eClk5"                      sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport5_o
    add wave -label "eClk6"                      sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport6_o
    add wave -label "eClk7"                      sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport7_o
    add wave -label "eClk8"                      sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport8_o
    add wave -label "eClk9"                      sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport9_o
    add wave -label "eClk10"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport10_o
    add wave -label "eClk11"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport11_o
    add wave -label "eClk12"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport12_o
    add wave -label "eClk13"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport13_o
    add wave -label "eClk14"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport14_o
    add wave -label "eClk15"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport15_o
    add wave -label "eClk16"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport16_o
    add wave -label "eClk17"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport17_o
    add wave -label "eClk18"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport18_o
    add wave -label "eClk19"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport19_o
    add wave -label "eClk20"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport20_o
    add wave -label "eClk21"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport21_o
    add wave -label "eClk22"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport22_o
    add wave -label "eClk23"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport23_o
    add wave -label "eClk24"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport24_o
    add wave -label "eClk25"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport25_o
    add wave -label "eClk26"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport26_o
    add wave -label "eClk27"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport27_o
    add wave -label "eClk28"                     sim:/top_tb/lpgbt_model_wrapper_inst/clk_eport28_o
}

#lpGBT Functions
proc lpgbt_waitForLock {{timeout 1000}} {

    for {set i 0} {$i < $timeout} {incr i} {
        run 1us

        if {[lpgbt_isLocked] == 1} {
            return 0
        }
    }

    return -1
}

proc lpgbt_isLocked {} {
    return [exa sim:/top_tb/lpgbt_rdy_s]
}

proc lpgbt_reset {} {

	force -freeze sim:/top_tb/lpgbt_rstn_s 1 0
	force -freeze sim:/top_tb/lpgbt_rstn_s 0 50 ns
	force -freeze sim:/top_tb/lpgbt_rstn_s 1 100 ns

	run 100ns

	return 0
}

#DOWNLINK Functions
proc downlink_reset {} {

	force -freeze sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_downlinkrst_s 0 0
	force -freeze sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_downlinkrst_s 1 50 ns
	force -freeze sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_downlinkrst_s 0 100 ns

	run 100ns

	return 0
}



proc setDownlinkELinks {} {
    force -freeze sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_downlinkUserData_s 32'hFFFFFFFF 0
}

proc clearDownlinkELinks {} {
    force -freeze sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_downlinkUserData_s 32'h00000000 0
}


#UPLINK functions
proc uplink_reset {} {

	force -freeze sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_uplinkrst_s 0 0
	force -freeze sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_uplinkrst_s 1 50 ns
	force -freeze sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_uplinkrst_s 0 100 ns

	run 100ns

	return 0
}

proc uplink_waitForLock {{timeout 100}} {

    for {set i 0} {$i < $timeout} {incr i} {
        run 1us

        if {[uplink_isLocked] == 1} {
            return 0
        }
    }

    return -1
}

proc uplink_waitForUnLock {{timeout 30}} {

    for {set i 0} {$i < $timeout} {incr i} {
        run 1us

        if {[uplink_isLocked] == 0} {
            return 0
        }
    }

    return -1
}

proc uplink_isLocked {} {
    return [exa sim:/top_tb/lpgbtfpga_sim_inst/lpgbtfpga_uplinkrdy_s]
}


proc setUplinkELinks {} {
    force -freeze sim:/top_tb/dat_eport0_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport1_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport2_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport3_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport10_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport11_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport12_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport13_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport20_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport21_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport22_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport23_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport30_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport31_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport32_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport33_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport40_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport41_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport42_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport43_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport50_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport51_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport52_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport53_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport60_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport61_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport62_uplink_s 1 0
    force -freeze sim:/top_tb/dat_eport63_uplink_s 1 0

}

proc clearUplinkELinks {} {
    force -freeze sim:/top_tb/dat_eport0_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport1_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport2_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport3_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport10_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport11_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport12_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport13_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport20_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport21_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport22_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport23_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport30_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport31_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport32_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport33_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport40_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport41_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport42_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport43_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport50_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport51_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport52_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport53_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport60_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport61_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport62_uplink_s 0 0
    force -freeze sim:/top_tb/dat_eport63_uplink_s 0 0
}