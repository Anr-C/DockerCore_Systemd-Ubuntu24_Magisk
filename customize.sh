#
# Magisk模块安装脚本
#
# 使用说明:
#
# 1. 将文件放入系统文件夹(删除placeholder文件)
# 2. 在module.prop中填写您的模块信息
# 3. 在此文件中配置和调整
# 4. 如果需要开机执行脚本，请将其添加到post-fs-data.sh或service.sh
# 5. 将其他或修改的系统属性添加到system.prop
#
######################################
#
# 安装框架将导出一些变量和函数。
# 您应该使用这些变量和函数来进行安装。
#
# !请不要使用任何Magisk的内部路径，因为它们不是公共API。
# !请不要在util_functions.sh中使用其他函数，因为它们也不是公共API。
# !不能保证非公共API在版本之间保持兼容性。
#
# 可用变量:
#
# MAGISK_VER (string):当前已安装Magisk的版本的字符串(字符串形式的Magisk版本)
# MAGISK_VER_CODE (int):当前已安装Magisk的版本的代码(整型变量形式的Magisk版本)
# BOOTMODE (bool):如果模块当前安装在Magisk Manager中，则为true。
# MODPATH (path):你的模块应该被安装到的路径
# TMPDIR (path):一个你可以临时存储文件的路径
# ZIPFILE (path):模块的安装包（zip）的路径
# ARCH (string): 设备的体系结构。其值为arm、arm64、x86、x64之一
# IS64BIT (bool):如果$ARCH(上方的ARCH变量)为arm64或x64，则为true。
# API (int):设备的API级别（Android版本）
#
# 可用函数:
#
# ui_print <msg>
#     打印(print)<msg>到控制台
#     避免使用'echo'，因为它不会显示在第三方recovery的控制台中。
#
# abort <msg>
#     打印错误信息<msg>到控制台并终止安装
#     避免使用'exit'，因为它会跳过终止的清理步骤
#
##################################
#
# 如果您需要更多的自定义，并且希望自己做所有事情
# 请在custom.sh中标注SKIPUNZIP=1
# 以跳过提取操作并应用默认权限/上下文上下文步骤。
# 请注意，这样做后，您的custom.sh将负责自行安装所有内容。
SKIPUNZIP=0

# 如果您需要调用Magisk内部的busybox
# 请在custom.sh中标注ASH_STANDALONE=1
ASH_STANDALONE=1

######################################
# 安装设置
#
# 如果SKIPUNZIP=1你将可能会需要使用以下代码
# 当然，你也可以自定义安装脚本，需要时请删除#
# 将 $ZIPFILE 提取到 $MODPATH
#  ui_print "- 解压模块文件"
#  unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >&2
# 删除多余文件
# rm -rf \
# $MODPATH/system/placeholder $MODPATH/customize.sh \
# $MODPATH/*.md $MODPATH/.git* $MODPATH/LICENSE 2>/dev/null

ui_print " ";
ui_print " 此 Magisk/KernelSU/Apatch 模块需要内核支持";
ui_print " 需对内核进行补丁编译内核开启运行 LXC/Docker 的必要依赖";
ui_print " 可参考如下：
 https://gist.github.com/FreddieOliveira/efe850df7ff3951cb62d74bd770dce27
  或 GithubAction 自动化构建：
 1、https://github.com/tomxi1997/LXC_KernelSU_Action
 2、https://github.com/wu17481748/LXC-DOCKER-KernelSU_Action
  或手动：
 https://github.com/tomxi1997/lxc-docker-support-for-android
  对于 GKI 内核除上述配置/补丁外还需要如下补丁，不然会导致无限重启。
 https://github.com/tomxi1997/Enable-LXC-Dockers-for-Android-GKI-kernel
";

ui_print " ";
ui_print " 正在解压 Docker 压缩文档,请耐心等待";
tar -C /data/ -xf $MODPATH/docker.tar.xz
mkdir -p /data/docker/tmp/
mv $MODPATH/*.zip /data/docker/tmp/
cp $MODPATH/load-*.sh /data/docker/tmp/

ui_print " ";
ui_print " 设置 Docker 权限 ";
set_perm_recursive /data/docker 0 0 0755 0755
set_perm_recursive /data/docker/tmp 0 0 0755 0755

ui_print " ";
ui_print " 正在删除多余文件";
rm $MODPATH/docker.tar.xz 

ui_print " ";
ui_print " Docker 使用方式：";
ui_print " 推荐直接用 Nethunter Terminal，Termux 使用方式：";
ui_print " 首先重启开机后查看 /sdcard/docker-deamon.log 确保已经启动";
ui_print " 打开 Termux，在终端执行 su 然后即可执行 docker 命令";
ui_print " 如不行则：在终端执行 su，执行 cd /data/docker，再执行 source env.sh";
ui_print " 继而就可以执行各种 Docker 命令，创建各种 Docker 容器并管理。";

ui_print " ";
ui_print " Systemd 容器使用方式：";
ui_print " 前提：Docker 运行正常，不行的话，参考 Docker core for Android 的内核编译说明。";
ui_print " 1、Nethunter Terminal：";
ui_print " 打开 Nethunter Terminal kali shell 执行 ：";
ui_print "  busybox sh load-*.sh ";
ui_print " load-*.sh换为具体的名称)，即可完成导入，下次开机时自动启动 systemd 容器。";
ui_print " 2、Termux：";
ui_print " 执行如下：
 su -c 'source /data/docker/env.sh && /data/docker/bin/busybox sh /data/docker/tmp/load-*.sh'";
ui_print " load-*.sh换为具体的名称，如需自定义请查看 /data/docker/tmp/load-*.sh 内容，按需修改。";
ui_print " 重启一次手机，确保 cron 定时器工作，ssh 连接容 ssh root@localhost -p xxxx 密码 root。";

ui_print " ";
ui_print " 关于此模块的卸载，该模块只是复制导入作用。";
ui_print " 删除容器/镜像，使用 docker cli 执行操作，在 Nethunter-Terminal 中执行：";
ui_print " docker -rm -f $容器名" ;
ui_print " docker -rmi $镜像名" ;

ui_print " ";
ui_print " 刷入完成，重启设备使其生效";

#
# 权限设置
#

# 请注意，magisk模块目录中的所有文件/文件夹都有$MODPATH前缀-在所有文件/文件夹中保留此前缀
# 一些例子:
  
# 对于目录(包括文件):
# set_perm_recursive  <目录>                <所有者> <用户组> <目录权限> <文件权限> <上下文> (默认值是: u:object_r:system_file:s0)
  
# set_perm_recursive $MODPATH/system/lib 0 0 0755 0644
# set_perm_recursive $MODPATH/system/vendor/lib/soundfx 0 0 0755 0644

# 对于文件(不包括文件所在目录)
# set_perm  <文件名>                         <所有者> <用户组> <文件权限> <上下文> (默认值是: u:object_r:system_file:s0)
  
# set_perm $MODPATH/system/lib/libart.so 0 0 0644
# set_perm /data/local/tmp/file.txt 0 0 644

# 默认权限请勿删除
set_perm $MODPATH/service.sh 0 0 0755
set_perm $MODPATH/post-fs-data.sh 0 0 0755
set_perm_recursive /data/docker/tmp 0 0 0755 0755
set_perm_recursive $MODPATH/system/bin 0 0 0755 0755
set_perm_recursive $MODPATH/system/etc 0 0 0755 0644
set_perm_recursive $MODPATH/system/lib64 0 0 0755 0644
set_perm_recursive $MODPATH/system/lib 0 0 0755 0644

set_perm $MODPATH/system/bin/docker 0 0 0755 

# 伪造系统信息
generate_os_release() {
  local OS_RELEASE_FILE="$MODPATH/system/etc/os-release"
  mkdir -p $(dirname "$OS_RELEASE_FILE")
  local ANDROID_VERSION=$(getprop ro.build.version.release)
  local BUILD_ID=$(getprop ro.build.id)

  echo "NAME=\"Android\"" > "$OS_RELEASE_FILE"
  echo "ID=\"android\"" >> "$OS_RELEASE_FILE"
  echo "VERSION=\"$ANDROID_VERSION\"" >> "$OS_RELEASE_FILE"
  echo "VERSION_ID=\"$ANDROID_VERSION\"" >> "$OS_RELEASE_FILE"
  echo "BUILD_ID=\"$BUILD_ID\"" >> "$OS_RELEASE_FILE"
  echo "PRETTY_NAME=\"Android $ANDROID_VERSION \"" >> "$OS_RELEASE_FILE"
  set_perm "$OS_RELEASE_FILE" 0 0 0644
}
generate_os_release