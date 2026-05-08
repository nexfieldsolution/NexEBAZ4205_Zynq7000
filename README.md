# Zynq-7000 Tutorial

This tutorial provides comprehensive examples for Zynq-7000 development, covering both hardware design in Vivado and software development in Vitis.

## Overview

The 05_Zynq7000 tutorial includes:

### Hardware Design (Vivado)
- **Block Design**: Complete Zynq PS configuration with peripherals
- **GPIO Configuration**: External GPIO and EMIO setup
- **Peripheral Integration**: UART, Ethernet, Timer, and other peripherals
- **Bitstream Generation**: FPGA programming files

### Software Applications (Vitis)
- **LED External Test 1**: Direct GPIO register access for LED control
- **LED External Test 2**: Xilinx GPIO driver-based LED control  
- **lwIP Echo Server**: Network echo server using lwIP stack
- **Memory Test**: Comprehensive memory validation
- **Peripheral Test**: Multi-peripheral functionality testing
- **PS LCD**: LCD display control via PS GPIO

## Hardware Requirements

- Zynq-7000 based development board (EBAZ4205)
- LEDs for testing applications
- Ethernet connection for network applications
- LCD display for PS LCD application
  - [Adapter with LCD](https://ja.aliexpress.com/item/1005006074065888.html) (recommended)
- JTAG or UART connection for programming/debugging

## Software Requirements

- Xilinx Vivado Design Suite
- Xilinx Vitis IDE
- Zynq-7000 BSP (Board Support Package)
- Required Xilinx driver libraries

## Getting Started

### Vivado 프로젝트 재생성

`vivado/project_new/`는 git에서 제외됩니다. 아래 스크립트로 재생성하세요.

```bash
cd /path/to/NexEBAZ4205_Zynq7000

# 1. 프로젝트 생성 (PS7 설정 + AXI GPIO 블록 디자인)
vivado -mode batch -source vivado/create_project.tcl

# 2. 합성 → 구현 → 비트스트림 → XSA 생성
vivado -mode batch -source vivado/run_impl.tcl
```

완료 후 생성되는 파일:
- `vivado/project_new/ebaz4205_zynq.runs/impl_1/design_1_wrapper.bit` — 비트스트림
- `vivado/project_new/ebaz4205_zynq.xsa` — Hardware Platform (PetaLinux용)
- `vivado/project_new/ebaz4205_zynq.gen/.../ps7_init.tcl` — JTAG 부트용 PS 초기화

**보드 설정**: xc7z020clg400-1, PS_CLK 33.333MHz, DDR3 16-bit

### JTAG으로 U-Boot 로드

SD카드를 뽑고 JTAG 연결 후:

```bash
# PetaLinux 2024.1
xsdb download_uboot_jtag-2024.tcl

# PetaLinux 2019.2
xsdb download_uboot_jtag-2019.tcl
```

시리얼 포트: J7 커넥터 (UART1, 115200bps)

### 하드웨어 연결
![EBAZ4205 Board](./ebaz4205+io.png)

### JTAG U-Boot 부팅 성공
![U-Boot OK](./petalinux-uboot-ok-20260508.png)

### SD카드 준비

```bash
./make-sd.sh /dev/sdX
```

1. **Hardware Setup**
   - Open Vivado project in `vivado/` directory
   - Review block design configuration
   - Generate bitstream and export to Vitis

2. **Software Development**
   - Import Vitis workspace from `vitis/` directory
   - Build desired application projects
   - Program FPGA and run applications

3. **Testing**
   - Monitor UART output for debugging
   - Verify hardware functionality
   - Test application-specific features

## Directory Structure

```
05_Zynq7000/
├── vivado/                 # Vivado hardware design
│   ├── block_design.png    # Block design overview
│   └── project files       # Vivado project files
├── vitis/                  # Vitis software applications
│   ├── README.md           # Detailed software documentation
│   ├── README_JP.md        # Japanese documentation
│   └── application folders # Individual application projects
└── README.md               # This file
```

## Applications Summary

| Application | Purpose | Key Features |
|-------------|---------|--------------|
| LED External Test 1 | Basic GPIO control | Direct register access, 8-state pattern |
| LED External Test 2 | Driver-based GPIO | XGpio driver, error handling |
| lwIP Echo Server | Network testing | TCP/UDP echo, IPv4/IPv6 support |
| Memory Test | Memory validation | Comprehensive testing, error reporting |
| Peripheral Test | Multi-peripheral testing | GPIO, UART, I2C, SPI, Timer, DMA |
| PS LCD | Display control | EMIO GPIO, color rendering |

## Common Development Workflow

1. **Hardware Design**: Configure FPGA in Vivado
2. **Software Development**: Create applications in Vitis
3. **Testing**: Program and validate functionality
4. **Debugging**: Monitor UART and verify operation

## Support

- **Vivado Documentation**: See `vivado/` directory
- **Vitis Documentation**: See `vitis/README.md`
- **Hardware Reference**: EBAZ4205 documentation
- **Xilinx Documentation**: https://docs.xilinx.com/

---

**Last Updated**: February 2026  
**Platform**: Xilinx Zynq-7000  
**Target Board**: EBAZ4205
