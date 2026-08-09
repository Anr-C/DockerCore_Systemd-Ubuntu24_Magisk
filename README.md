

# DockerCore_v8_Systemd-Ubuntu24_Magisk
tomxi1997 的 Docker Core for Android https://github.com/tomxi1997/termux-packages/releases/tag/v10 最后稳定版的个人优化与微调跟进。

2025.11.24

1、增加 os_release 伪造，减少错误日志输出

2、修正 daemon 单词拼写错误导致的 sd 卡日志错乱

3、开机默认启用桥接网络，用于不使用 systemd 容器，纯宿主 docker 运行情况。

2025.11.21

1、梳理项目文案，包括 Readme，sh 等。

2、docker 默认开启 Api 远程模式 2375 端口，可在 Portainer 中集群使用。

💡 容器 SSH 连接：`ssh root@localhost -p 2404`（默认密码：root）
