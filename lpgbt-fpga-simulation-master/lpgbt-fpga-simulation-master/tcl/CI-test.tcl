source TCL/testbench.tcl

simulate 1 2

#Disable NUMERIC_STD.TO_UNSIGNED warnings (known warning from the data pattern generator)
set StdArithNoWarnings 1
set StdNumNoWarnings 1
set NumericStdNoWarnings 1

downlink_reset
lpgbt_reset
uplink_reset
run 150 us

if {[lpgbt_waitForLock] != 0} {
  puts "Error: lpGBT is not locked"
  #quit -code -1
} else {
  puts "Ok"
}

if {[uplink_waitForLock] != 0} {
  puts "Error: uplink is not locked"
  #quit -code -1
} else {
  puts "Ok"
}