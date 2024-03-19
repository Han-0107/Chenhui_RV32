vlog *.v ../rtl/*.v

vsim -voptargs="+acc" tbtop
add wave /*
add wave /tbtop/U_CHIP_TOP/u_riscv_core/*
run -all