#!/bin/sh

TOP_DIR=$(pwd)/../../..
UBOOT_DIR=$TOP_DIR/os/uboot/
OUTPUT_DIR=$TOP_DIR/os/output/ubd
BURNTOOL_DIR=$TOP_DIR/workbench/burntool
# echo "TOPDIR=$TOP_DIR"
# echo "UBOOT_DIR=$UBOOT_DIR"

# 设置默认值为 "build"，如果没有传入第一个参数，则使用默认值
operation=${1:-build}

# 使用case根据传入的参数执行对应操作
case "$operation" in
    "build")
        echo "Starting building uboot..."
        cd $UBOOT_DIR
        make $DEFCONFIG O=$OUTPUT_DIR
        bear make -j8 O=$OUTPUT_DIR
        cp $OUTPUT_DIR/u-boot.imx $BURNTOOL_DIR
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

