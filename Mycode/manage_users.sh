#!/bin/bash
## wget -O manage_users.sh https://raw.githubusercontent.com/Qoo-330ml/One-KVM/refs/heads/main/Mycode/manage_users.sh && chmod +x manage_users.sh && sudo ./manage_users.sh
# 显示当前用户列表
echo "当前用户列表:"
kvmd-htpasswd list

# 询问用户要进行的操作
echo "请选择你要进行的操作："
echo "1. 添加用户账号"
echo "2. 删除用户账号"
echo "3. 修改现有用户的密码"
read -p "请输入你的选择 (1/2/3): " choice

case $choice in
    1)
        # 添加用户账号
        read -p "请输入要添加的用户名: " username
        if [[ -z "$username" ]]; then
            echo "用户名不能为空，请重新运行脚本。"
            exit 1
        fi
        echo "正在添加用户 $username..."
        kvmd-htpasswd set "$username"
        echo "用户 $username 添加成功。"
        ;;
    2)
        # 删除用户账号
        echo "当前用户列表:"
        kvmd-htpasswd list | awk '{print NR": "$0}'
        read -p "请选择要删除的用户名对应的数字: " user_number
        username=$(kvmd-htpasswd list | awk "NR==$user_number {print \$1}")
        if [[ -z "$username" ]]; then
            echo "未找到对应的用户名，请重新运行脚本。"
            exit 1
        fi
        echo "正在删除用户 $username..."
        kvmd-htpasswd del "$username"
        echo "用户 $username 删除成功。"
        ;;
    3)
        # 修改用户账号密码
        echo "当前用户列表:"
        kvmd-htpasswd list | awk '{print NR": "$0}'
        read -p "请选择要修改密码的用户名对应的数字: " user_number
        username=$(kvmd-htpasswd list | awk "NR==$user_number {print \$1}")
        if [[ -z "$username" ]]; then
            echo "未找到对应的用户名，请重新运行脚本。"
            exit 1
        fi
        echo "正在修改用户 $username 的密码..."
        kvmd-htpasswd set "$username"
        echo "用户 $username 的密码修改成功。"
        ;;
    *)
        echo "无效的选择，脚本将退出。"
        exit 1
        ;;
esac

# 列出当前用户列表
echo "更新后的用户列表:"
kvmd-htpasswd list

# 重启服务
echo "正在重启服务..."
systemctl restart kvmd kvmd-nginx
echo "服务重启成功。"
