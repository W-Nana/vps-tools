#!/bin/sh

# 检查输入参数
if [ -z "$1" ]; then
    echo "错误：请提供GitHub用户名"
    echo "用法: $0 <github_username>"
    exit 1
fi

# 安装必要工具
if ! command -v curl &> /dev/null; then
    echo "正在安装curl..."
    apt-get update && apt-get install -y curl || yum install -y curl || {
        echo "无法安装curl，请手动安装后重试"
        exit 1
    }
fi

# 创建.ssh目录（如果不存在）
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 备份原有SSH配置
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 从GitHub获取公钥
echo "正在获取 $1 的公钥..."
curl -sSf "https://github.com/$1.keys" -o /tmp/github_keys || {
    echo "无法获取公钥，请检查用户名或网络连接"
    exit 1
}

# 添加公钥到授权文件
if [ -s /tmp/github_keys ]; then
    cat /tmp/github_keys >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    echo "成功添加公钥到 ~/.ssh/authorized_keys"
else
    echo "错误：获取的公钥为空"
    exit 1
fi

# 修改SSH配置
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# 重启SSH服务
if systemctl restart sshd 2>/dev/null || service sshd restart 2>/dev/null; then
    echo "SSH服务已成功重启"
else
    echo "警告：无法重启SSH服务，请手动检查"
fi

echo "配置完成！已："
echo "1. 禁用密码登录"
echo "2. 禁止root直接登录"
echo "3. 添加GitHub公钥认证"