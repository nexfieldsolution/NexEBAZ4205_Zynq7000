# =============================================================
# create_project.tcl - EBAZ4205 Vivado 프로젝트 생성 스크립트
# 실행: vivado -mode batch -source vivado/create_project.tcl
# 출력: vivado/project_new/
# 디바이스: xc7z020clg400-1 (EBAZ4205 Zynq-7020)
# PS_CLK: 33.333MHz, DDR: 16-bit EM6GD16EWKG-12H
# =============================================================

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJ_DIR   [file join $SCRIPT_DIR project_new]
set PROJ_NAME  ebaz4205_zynq
set PART       xc7z020clg400-1
set BD_NAME    design_1

# 기존 프로젝트 삭제
if {[file exists $PROJ_DIR]} {
    puts "기존 프로젝트 삭제: $PROJ_DIR"
    file delete -force $PROJ_DIR
}

# 프로젝트 생성
create_project $PROJ_NAME $PROJ_DIR -part $PART
set_property target_language VHDL [current_project]

# =============================================================
# 블록 디자인 생성
# =============================================================
create_bd_design $BD_NAME

# PS7 추가
set ps7 [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0]

# PS7 설정 - EBAZ4205 33.333MHz, DDR3 16-bit
set_property -dict [list \
    CONFIG.PCW_PRESET_BANK0_VOLTAGE     {LVCMOS 3.3V} \
    CONFIG.PCW_PRESET_BANK1_VOLTAGE     {LVCMOS 3.3V} \
    CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
    CONFIG.PCW_APU_PERIPHERAL_FREQMHZ   {667} \
    CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
    CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {25} \
    CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {25} \
    CONFIG.PCW_USE_M_AXI_GP0            {1} \
    CONFIG.PCW_EN_CLK0_PORT             {1} \
    CONFIG.PCW_EN_CLK3_PORT             {1} \
    CONFIG.PCW_EN_RST0_PORT             {1} \
    CONFIG.PCW_USE_FABRIC_INTERRUPT     {1} \
    CONFIG.PCW_IRQ_F2P_INTR             {1} \
    CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE  {DDR 3} \
    CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH    {16 Bit} \
    CONFIG.PCW_UIPARAM_DDR_PARTNO       {Custom} \
    CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ     {533.333} \
    CONFIG.PCW_UIPARAM_DDR_SPEED_BIN    {DDR3_1066F} \
    CONFIG.PCW_UIPARAM_DDR_CL           {7} \
    CONFIG.PCW_UIPARAM_DDR_CWL          {6} \
    CONFIG.PCW_UIPARAM_DDR_T_RCD        {7} \
    CONFIG.PCW_UIPARAM_DDR_T_RP         {7} \
    CONFIG.PCW_UIPARAM_DDR_T_RC         {49375} \
    CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN    {36000} \
    CONFIG.PCW_UIPARAM_DDR_T_FAW        {40000} \
    CONFIG.PCW_UIPARAM_DDR_AL           {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.040} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.040} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.521} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.521} \
    CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM  {0} \
    CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM  {0} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT   {14} \
    CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT  {3} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE  {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE   {1} \
    CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
    CONFIG.PCW_DDR_PORT0_HPR_ENABLE         {0} \
    CONFIG.PCW_DDR_PORT1_HPR_ENABLE         {0} \
    CONFIG.PCW_DDR_PORT2_HPR_ENABLE         {0} \
    CONFIG.PCW_DDR_PORT3_HPR_ENABLE         {0} \
    CONFIG.PCW_UART1_PERIPHERAL_ENABLE  {1} \
    CONFIG.PCW_UART1_UART1_IO           {MIO 24 .. 25} \
    CONFIG.PCW_UART0_PERIPHERAL_ENABLE  {0} \
    CONFIG.PCW_ENET0_PERIPHERAL_ENABLE  {1} \
    CONFIG.PCW_ENET0_ENET0_IO           {EMIO} \
    CONFIG.PCW_ENET0_GRP_MDIO_ENABLE    {1} \
    CONFIG.PCW_ENET0_GRP_MDIO_IO        {EMIO} \
    CONFIG.PCW_ENET1_PERIPHERAL_ENABLE  {0} \
    CONFIG.PCW_SD0_PERIPHERAL_ENABLE    {1} \
    CONFIG.PCW_SD0_SD0_IO               {MIO 40 .. 45} \
    CONFIG.PCW_SD1_PERIPHERAL_ENABLE    {0} \
    CONFIG.PCW_NAND_PERIPHERAL_ENABLE   {0} \
    CONFIG.PCW_I2C0_PERIPHERAL_ENABLE   {0} \
    CONFIG.PCW_I2C1_PERIPHERAL_ENABLE   {0} \
    CONFIG.PCW_SPI0_PERIPHERAL_ENABLE   {0} \
    CONFIG.PCW_SPI1_PERIPHERAL_ENABLE   {0} \
    CONFIG.PCW_CAN0_PERIPHERAL_ENABLE   {0} \
    CONFIG.PCW_CAN1_PERIPHERAL_ENABLE   {0} \
    CONFIG.PCW_USB0_PERIPHERAL_ENABLE   {0} \
    CONFIG.PCW_USB1_PERIPHERAL_ENABLE   {0} \
    CONFIG.PCW_GPIO_MIO_GPIO_ENABLE     {1} \
    CONFIG.PCW_GPIO_MIO_GPIO_IO         {MIO} \
    CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE    {0} \
    CONFIG.PCW_MIO_16_PULLUP            {enabled} \
    CONFIG.PCW_MIO_17_PULLUP            {enabled} \
    CONFIG.PCW_MIO_18_PULLUP            {enabled} \
    CONFIG.PCW_MIO_19_PULLUP            {enabled} \
    CONFIG.PCW_MIO_20_PULLUP            {enabled} \
    CONFIG.PCW_MIO_21_PULLUP            {enabled} \
    CONFIG.PCW_MIO_22_PULLUP            {enabled} \
    CONFIG.PCW_MIO_23_PULLUP            {enabled} \
    CONFIG.PCW_MIO_24_PULLUP            {enabled} \
    CONFIG.PCW_MIO_25_PULLUP            {enabled} \
] $ps7

# PS7 자동 연결 (DDR, Fixed IO)
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 \
    -config {make_external "FIXED_IO, DDR" apply_board_preset "0" Master "Disable" Slave "Disable"} \
    $ps7

# AXI GPIO 추가 (LED/BTN/DATA 핀용)
set axi_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0]
set_property -dict [list \
    CONFIG.C_GPIO_WIDTH  {5} \
    CONFIG.C_ALL_INPUTS  {0} \
    CONFIG.C_ALL_OUTPUTS {0} \
] $axi_gpio

# AXI GPIO 자동 연결
apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
    -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto"} \
    [get_bd_intf_pins $axi_gpio/S_AXI]

# GPIO 외부 포트
make_bd_intf_pins_external [get_bd_intf_pins $axi_gpio/GPIO]

# FCLK_CLK3 외부 포트 (25MHz 출력 - U18)
set fclk3 [create_bd_port -dir O -type clk FCLK_CLK3]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK3] [get_bd_ports FCLK_CLK3]

# 블록 디자인 검증 및 저장
validate_bd_design
save_bd_design

# =============================================================
# HDL Wrapper 생성
# =============================================================
set bd_file [get_files ${BD_NAME}.bd]
make_wrapper -files $bd_file -top
# Vivado 2019+: wrapper는 .gen/ 에 생성됨
set wrapper [glob -nocomplain $PROJ_DIR/${PROJ_NAME}.gen/sources_1/bd/${BD_NAME}/hdl/*.vhd]
if {[llength $wrapper] == 0} {
    set wrapper [glob -nocomplain $PROJ_DIR/${PROJ_NAME}.gen/sources_1/bd/${BD_NAME}/hdl/*.v]
}
if {[llength $wrapper] > 0} {
    add_files -norecurse $wrapper
}
set_property top ${BD_NAME}_wrapper [current_fileset]

# XDC 제약 파일 추가
set xdc_file [file join $SCRIPT_DIR EBAZ4205.xdc]
if {[file exists $xdc_file]} {
    add_files -fileset constrs_1 -norecurse $xdc_file
    puts "XDC 추가: $xdc_file"
} else {
    puts "경고: XDC 파일 없음 - $xdc_file"
}

puts ""
puts "프로젝트 생성 완료: $PROJ_DIR"
puts "다음 단계: vivado -mode batch -source vivado/run_impl.tcl"
puts ""
