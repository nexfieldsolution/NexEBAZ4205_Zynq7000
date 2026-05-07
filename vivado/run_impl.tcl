# =============================================================
# run_impl.tcl - synthesis/impl/bitstream + XSA 생성
# 실행: vivado -mode batch -source vivado/run_impl.tcl
# 주의: create_project.tcl 먼저 실행 필요
# =============================================================

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJ_DIR   [file join $SCRIPT_DIR project_new]
set PROJ_FILE  [file join $PROJ_DIR ebaz4205_zynq.xpr]

open_project $PROJ_FILE

# Synthesis
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    error "Synthesis failed"
}

# Implementation
launch_runs impl_1 -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    error "Implementation failed"
}

# Bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

# XSA export (bitstream 포함)
set bit_file [file join $PROJ_DIR ebaz4205_zynq.runs/impl_1/design_1_wrapper.bit]
write_hw_platform -fixed -force -include_bit -file [file join $PROJ_DIR ebaz4205_zynq.xsa]

# ps7_init.tcl 복사 (JTAG용)
set psinit_src [file join $PROJ_DIR ebaz4205_zynq.runs/impl_1/design_1_wrapper.tcl]
if {![file exists $psinit_src]} {
    set psinit_src [glob -nocomplain $PROJ_DIR/ebaz4205_zynq.gen/sources_1/bd/design_1/ip/*/ps7_init*.tcl]
    if {[llength $psinit_src] > 0} { set psinit_src [lindex $psinit_src 0] }
}

set ide_dir [file join $PROJ_DIR ebaz4205_zynq.runs/impl_1/_ide/psinit]
file mkdir $ide_dir
catch {
    foreach f [glob -nocomplain $PROJ_DIR/ebaz4205_zynq.gen/sources_1/bd/design_1/ip/*/ps7_init*] {
        file copy -force $f $ide_dir
    }
}

puts ""
puts "빌드 완료!"
puts "  비트스트림: $bit_file"
puts "  XSA: $PROJ_DIR/ebaz4205_zynq.xsa"
puts "  ps7_init.tcl 위치: $ide_dir"
puts ""
puts "download_uboot_jtag-2024.tcl의 PS7 경로를 확인하세요:"
puts "  set PS7 vivado/project_new/ebaz4205_zynq.runs/impl_1/_ide/psinit/ps7_init.tcl"
puts ""
