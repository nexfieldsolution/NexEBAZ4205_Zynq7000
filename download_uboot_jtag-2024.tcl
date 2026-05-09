# =============================================================
# download_uboot_jtag-2024.tcl - JTAG으로 U-Boot 로드 (PetaLinux 2024.1)
# 실행: xsdb download_uboot_jtag-2024.tcl
# 주의: SD카드 반드시 뽑고 실행!
# =============================================================

set PS7    vivado/project_new/ebaz4205_zynq.gen/sources_1/bd/design_1/ip/design_1_processing_system7_0_0/ps7_init.tcl
set BIT    vivado/project_new/ebaz4205_zynq.runs/impl_1/design_1_wrapper.bit
set UBOOT  "Petalinux-2024.1/u-boot-dtb.bin"

connect

# PS 리셋 및 초기화
target 2
rst
stop
source $PS7
ps7_init
ps7_post_config

# PL 비트스트림 로드
target 1
fpga $BIT

# U-Boot 로드 및 실행
target 2
dow -data $UBOOT 0x4000000
rwr pc 0x4000000
con

puts ""
puts "U-Boot 로드 완료 - J7 시리얼(115200)에서 확인하세요"
puts ""
