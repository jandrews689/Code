transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/jandr/Git/ADSD/My Work/Lab2/files/LED_patterns/scr/one_pulse.vhd}
vcom -93 -work work {C:/Users/jandr/Git/ADSD/My Work/Lab2/files/LED_patterns/scr/button_conditioner.vhd}
vcom -93 -work work {C:/Users/jandr/Git/ADSD/My Work/Lab2/files/LED_patterns/scr/LED_patterns.vhd}

vcom -93 -work work {C:/Users/jandr/Git/ADSD/My Work/Lab2/files/LED_patterns/scr/testbench1.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L cyclonev_hssi -L rtl_work -L work -voptargs="+acc"  testbench1

add wave *
view structure
view signals
run -all
