#!/bin/bash
# EBAZ4205 PetaLinux SD카드 준비 스크립트
# Usage:
#   ./make-sd.sh          # 포맷 없이 파일만 복사
#   ./make-sd.sh --format # 파티션 포맷 후 복사

set -e

DEVICE=${SD_DEVICE:-}
BOOT_SRC="Petalinux-2024.1"

MNT_FAT=/mnt/ebaz_fat
MNT_EXT4=/mnt/ebaz_ext4

# ============================================================
# 파티션 포맷
# ============================================================
do_format() {
    echo "=== 파티션 생성 및 포맷: $DEVICE ==="

    # 언마운트
    sudo umount ${DEVICE}* 2>/dev/null || true

    # 파티션 테이블 새로 작성
    sudo parted -s $DEVICE mklabel msdos
    sudo parted -s $DEVICE mkpart primary fat32 4MiB 104MiB
    sudo parted -s $DEVICE set 1 boot on
    sudo parted -s $DEVICE mkpart primary ext4 104MiB 100%

    sleep 1

    # 포맷
    sudo mkfs.vfat -F 32 -n BOOT ${FAT_PART}
    sudo mkfs.ext4 -L rootfs ${EXT4_PART}

    echo "=== 포맷 완료 ==="
}

# ============================================================
# 파일 복사
# ============================================================
do_copy() {
    echo "=== 파일 복사 시작 ==="

    # 마운트 포인트 생성
    sudo mkdir -p $MNT_FAT $MNT_EXT4

    # 마운트
    sudo mount ${FAT_PART} $MNT_FAT
    sudo mount ${EXT4_PART} $MNT_EXT4

    # FAT32: BOOT.BIN, image.ub
    echo "→ BOOT.BIN, image.ub 복사 중..."
    sudo cp "${BOOT_SRC}/BOOT.BIN" $MNT_FAT/
    sudo cp "${BOOT_SRC}/image.ub" $MNT_FAT/

    # ext4: rootfs
    echo "→ rootfs 압축 해제 중... (시간이 걸릴 수 있어요)"
    sudo tar xf "${BOOT_SRC}/rootfs.tar.gz" -C $MNT_EXT4/

    sync
    echo "=== sync 완료 ==="

    # 언마운트
    sudo umount $MNT_FAT
    sudo umount $MNT_EXT4

    echo "=== 완료! SD카드 뽑아도 됩니다 ==="
}

# ============================================================
# 메인
# ============================================================
cd "$(dirname "$0")"

# 디바이스 확인
if [ -z "$DEVICE" ]; then
    echo "현재 연결된 디스크:"
    lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT | grep -v loop
    echo ""
    read -p "SD카드 디바이스를 입력하세요 (예: /dev/sdd): " DEVICE
fi

if [ ! -b "$DEVICE" ]; then
    echo "오류: $DEVICE 는 블록 디바이스가 아닙니다"
    exit 1
fi

echo "대상 디바이스: $DEVICE ($(lsblk -dno SIZE $DEVICE))"
read -p "맞나요? (yes 입력): " confirm
if [ "$confirm" != "yes" ]; then
    echo "취소"
    exit 1
fi

FAT_PART="${DEVICE}1"
EXT4_PART="${DEVICE}2"

if [ "$1" = "--format" ]; then
    do_format
    do_copy
else
    do_copy
fi
