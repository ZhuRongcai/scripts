#!/bin/sh

TOP_DIR=$(pwd)/../../..
KERNEL_DIR=$TOP_DIR/os/kernel
OUTPUT_DIR=$TOP_DIR/os/output/kbd
BURNTOOL_DIR=$TOP_DIR/workbench/burntool
# echo "TOPDIR=$TOP_DIR"
# echo "KERNEL_DIR=$KERNEL_DIR"

# 设置默认值为 "build"，如果没有传入第一个参数，则使用默认值
operation=${1:-build}

# 使用case根据传入的参数执行对应操作
case "$operation" in
    "build")
        echo "Starting building kernel..."
        cd $KERNEL_DIR
        make $DEFCONFIG O=$OUTPUT_DIR
        make -j8 O=$OUTPUT_DIR
        ;;
    "clean")
        echo "remove $OUTPUT_DIR"
        rm -rf $OUTPUT_DIR
        ;;
    *)
        echo "Invalid operation. Usage: $0 {build|clean}"
        exit 1
        ;;
esac

cp $OUTPUT_DIR/arch/arm/boot/dts/imxplore.dtb $BURNTOOL_DIR
cp $OUTPUT_DIR/arch/arm/boot/zImage $BURNTOOL_DIR
# cp ${OUTPUT_DIR}/arch/arm/boot/dts/dfos.dtb ~/nfs/update/kernel4.14
# cp ${OUTPUT_DIR}/arch/arm/boot/zImage ~/nfs/update/kernel4.14