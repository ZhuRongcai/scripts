#!/bin/sh

# 配置文件 ----------------------------------------------
DEFCONFIG="imxplore_defconfig"
export DEFCONFIG
#-------------------------------------------------------

# 获取当前执行脚本的绝对路径
SCRIPT_PATH=$(readlink -f "$0")
# 获取当前执行脚本所在的目录
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
#echo "SCRIPT_PATH=$SCRIPT_PATH"
#echo "SCRIPT_DIR=$SCRIPT_DIR"
cd $SCRIPT_DIR


CURRENT_DIR=$(pwd)
operation1=${1:-build}
operation2=${2:-all}

build_kernel() {
    echo "Hello, $1 $2!"
    $CURRENT_DIR/build_kernel.sh $1
}

build_uboot() {
    echo "Hello, $1 $2!"
    $CURRENT_DIR/build_uboot.sh $1
}

# 使用case根据传入的参数执行对应操作
case "$operation2" in
    "kernel")
        echo "Starting building kernel..."
        build_kernel $1
        ;;
    "uboot")
        echo "Starting building uboot..."
        build_uboot $1
        ;;
    "all")
        echo "Starting building all..."
        build_uboot $1
        build_kernel $1
        ;;
    "clean")
        build_uboot $1
        build_kernel $1
        ;;
    *)
        echo "Invalid operation. Usage: $0 $1 {kernel|uboot|clean}"
        exit 1
        ;;
esac