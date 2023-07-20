#!/bin/sh
#execute执行语句成功与否打印
execute ()
{
    $* >/dev/null
    if [ $? -ne 0 ]; then
        echo
        echo "错误: 执行 $*"
        echo
        exit 1
    fi
}

device=$1
dfos_dtb=imx6ull-14x14-evk.dtb

#执行格式化$device
execute "dd if=/dev/zero of=$device bs=1024 count=1024"

#cat << END | fdisk -H 255 -S 63 $device
cat << END | fdisk $device
n
p
1
32
+63M
n
p
2
1956
486192
t
1
c
a
1
w
END

#第一个分区创建为Fat32格式
echo "格式化${device}p1 ..."
if [ -b ${PARTITION1} ]; then
	mkfs.vfat -F 32 -n "boot" /dev/mmcblk0p1
else
	echo "error: no ${PARTITION1}"
fi
#第二个分区创建为ext4格式
echo "格式化${device}p2 ..."
if [ -b ${PARITION2} ]; then
	/mnt/mke2fs -F -L "rootfs" /dev/mmcblk0p2
else
	echo "错误: /dev下找不到 SD卡 rootfs分区"
fi

echo "正在烧写${Uboot}到${device}"
execute "dd if=/mnt/u-boot.imx of=$device bs=1024 seek=1 conv=fsync"
sync
echo "烧写${Uboot}到${device}完成！"

echo "正在准备复制..."
echo "正在复制设备树与内核到${device}p1，请稍候..."
execute "mkdir -p /tmp/kernel"
execute "mount /dev/mmcblk0p1 /tmp/kernel"
execute "cp -r /mnt/${dfos_dtb} /tmp/kernel"
execute "cp -r /mnt/zImage /tmp/kernel"
sync
echo "复制设备树与内核到${device}p1完成！"

if [ "$copy" != "" ]; then
  echo "Copying additional file(s) on ${device}p1"
  execute "cp -r $copy /tmp/sdk/$$"
fi

echo "卸载${device}p1"
execute "umount /tmp/kernel"
sleep 1

#解压文件系统到文件系统分区
#挂载文件系统分区
execute "mkdir -p /tmp/sdk/$$"
execute "mount ${device}p2 /tmp/sdk/$$"

echo "正在解压文件系统到${device}p2 ，请稍候..."
execute "tar vxzf /mnt/rootfs.tar.gz -C /tmp/sdk/$$"
sync
echo "解压文件系统到${device}p2完成！"

echo "卸载${device}p2"
execute "umount /tmp/sdk/$$"

execute "rm -rf /tmp/sdk/$$"
sync
echo "SD卡启动系统烧写完成！"



