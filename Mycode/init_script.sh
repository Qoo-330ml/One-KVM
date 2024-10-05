#!/bin/bash
## wget -O init_script.sh https://raw.githubusercontent.com/Qoo-330ml/One-KVM/refs/heads/main/init_script.sh && chmod +x init_script.sh && sudo ./init_script.sh


# 确保脚本以root权限运行
if [ "$(id -u)" != "0" ]; then
    echo "该脚本需要root权限执行" 1>&2
    exit 1
fi

# 步骤1: 使用dd命令创建一个4GB的文件
dd if=/dev/zero of=/root/pikvm_msd.img bs=1M count=4096

# 步骤2: 使用mkfs.ext4命令格式化文件为ext4文件系统
mkfs.ext4 /root/pikvm_msd.img

# 步骤3: 在/etc/fstab追加新的挂载点
echo '/root/pikvm_msd.img /var/lib/kvmd/msd  ext4  nofail,nodev,nosuid,noexec,rw,errors=remount-ro,data=journal,X-kvmd.otgmsd-root=/var/lib/kvmd/msd,X-kvmd.otgmsd-user=kvmd  0 0' >> /etc/fstab

# 步骤4: 挂载文件系统
mount /root/pikvm_msd.img

# 步骤5: 编辑/etc/kvmd/override.yaml文件
sed -i '/msd:/,+2 s/type: disabled/type: otg/' /etc/kvmd/override.yaml

# 步骤6: 重启kvm服务
systemctl restart kvmd-otg kvmd

echo "脚本执行完毕"
