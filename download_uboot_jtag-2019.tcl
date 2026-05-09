# =============================================================
# download_uboot_jtag.tcl - JTAG으로 U-Boot 로드 (PetaLinux 2019.2)
# 실행: xsdb download_uboot_jtag-2019.tcl
# 주의: SD카드 반드시 뽑고 실행!
# =============================================================

set PS7    vivado/project_new/ebaz4205_zynq.gen/sources_1/bd/design_1/ip/design_1_processing_system7_0_0/ps7_init.tcl
set BIT    vivado/project_new/ebaz4205_zynq.runs/impl_1/design_1_wrapper.bit
set BOOTBIN "Petalinux-2019.2/BOOT.BIN"
set UBOOT  "Petalinux-2019.2/u-boot.bin"

# BOOT.BIN에서 u-boot 추출 (오프셋 0x868c0, 크기 0x22693)
puts "u-boot.bin 추출 중..."
catch {exec dd if=$BOOTBIN of=$UBOOT bs=4 skip=[expr 0x868c0] count=[expr 0x22693] 2>/dev/null}

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
dow -data $UBOOT 0x400000
rwr pc 0x400000
con

puts ""
puts "U-Boot 로드 완료 - J7 또는 DATA2 시리얼(115200)에서 확인하세요"
puts ""
