#Compile script
source TCL/testbench.tcl

puts "Start compilation ..."
if { [compile_project] == 0 } {
	quit -code 0
} else {
	quit -code -1
}