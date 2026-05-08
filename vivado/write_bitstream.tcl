# =============================================================
# write_bitstream.tcl - 라우팅 완료 체크포인트에서 비트스트림 생성
# 실행: vivado -mode batch -source vivado/write_bitstream.tcl
# 전제: run_impl.tcl로 라우팅까지 완료된 상태
# =============================================================

set PROJ_DIR  [file join [file dirname [file normalize [info script]]] project_new]
set DCP       [file join $PROJ_DIR ebaz4205_zynq.runs/impl_1/design_1_wrapper_routed.dcp]
set BIT       [file join $PROJ_DIR ebaz4205_zynq.runs/impl_1/design_1_wrapper.bit]
set XSA       [file join $PROJ_DIR ebaz4205_zynq.xsa]

if {![file exists $DCP]} {
    error "routed.dcp 없음: $DCP"
}

open_checkpoint $DCP
write_bitstream -force $BIT
write_hw_platform -fixed -force -include_bit -file $XSA

puts ""
puts "완료!"
puts "  비트스트림: $BIT"
puts "  XSA: $XSA"
puts ""
