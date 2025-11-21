#!/system/bin/sh
export PATH="/data/docker/bin:$PATH"
export LD_LIBRARY_PATH=/data/docker/lib:$LD_LIBRARY_PATH
cd /data/docker/tmp

#手动启用容器检测脚本，这是非常关键的，如果在没导入容器时直接开机自启动，会导致docker_demaon无法开机启动
mv /data/adb/modules/docker/cron/script/check-container0.sh /data/adb/modules/docker/cron/script/check-container.sh

#镜像标签信息
REPOSITORY=docker-systemd       
TAG=Ubuntu-24.04
#运行docker镜像时的附加参数
CMD="   "
CMD2="-p 9924:8824"

#运行的镜像时起的容器名称
NAME=systemd-ubuntu24

#docker镜像的路径
PH=/data/docker/tmp

#解压
busybox unzip $PH/$REPOSITORY-$TAG.zip -d $PH
rm $PH/$REPOSITORY-$TAG.zip

#导入镜像
echo "正在导入$REPOSITORY-$TAG.tar"
docker load -i $PH/$REPOSITORY-$TAG.tar 
rm $PH/$REPOSITORY-$TAG.tar 

#默认使用用主机网络
#使用主机网络，开机自启动的，挂载安卓usb/usb串口，挂载安卓/sdcard:/mnt/sdcar
 docker run -d --net host --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /sdcard:/mnt/sdcard -v /data:/mnt/data -v /dev/bus/usb:/dev/bus/usb $CMD --device=/dev/ttyUSB0 --name $NAME $REPOSITORY:$TAG 
 
 echo "//////////////////////////////////////////////////////////////////////////////////////////////////"
 echo "运行一个名为$NAME的容器，并使用主机网络，开机自启动的，挂载安卓usb/usb串口，挂载安卓/sdcardt到容器/mnt/sdcard的，基础镜像信息$REPOSITORY:$TAG，附加参数为$CMD，连接方式ssh root@localhost -p 2404，密码为root"
 echo "//////////////////////////////////////////////////////////////////////////////////////////////////"
 
#使用桥接网络，端口映射，容器内的8812端口映射到安卓的9912端口，开机自启动的，挂载安卓usb/usb串口，挂载安卓/mnt:/mnt，
 #docker run -d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /mnt:/mnt -v /dev/bus/usb:/dev/bus/usb $CMD2 --device=/dev/ttyUSB0 --name $NAME $REPOSITORY:$TAG 
 
# echo "运行一个名为$NAME的容器，并使用桥接网络，开机自启动的，挂载安卓usb/usb串口，挂载安卓/mnt到容器/mnt的，基础镜像信息$REPOSITORY-$TAG，附加参数为$CMD2,连接方式ssh root@localhost -p 9924，密码为root"
 