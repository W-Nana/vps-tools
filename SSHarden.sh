#!/bin/bash

# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请使用 root 权限运行此脚本 (sudo bash $0 [Github用户名])"
  exit 1
fi

# 检查参数
GITHUB_USER=$1
if [ -z "$GITHUB_USER" ]; then
  echo "错误: 未提供 Github 用户名"
  echo "用法: $0 [Github用户名]"
  exit 1
fi

echo "--- 开始服务器安全配置 ---"

# 1. 导入 GitHub 公钥
echo "[1/6] 正在获取并配置 $GITHUB_USER 的 SSH 公钥..."
KEYS_URL="https://github.com/${GITHUB_USER}.keys"
SSH_DIR="$HOME/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

# 确保 .ssh 目录存在
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# 获取密钥并追加到 authorized_keys (避免覆盖现有密钥)
curl -s "$KEYS_URL" >> "$AUTH_KEYS"

# 检查是否成功获取到密钥
if [ $? -ne 0 ] || [ ! -s "$AUTH_KEYS" ]; then
    echo "错误: 无法获取 GitHub 用户 $GITHUB_USER 的公钥，请检查用户名或网络。"
    exit 1
fi

# 设置权限
chmod 600 "$AUTH_KEYS"
echo "公钥导入完成。"

# 3. 随机更改 SSH 端口 (生成 10000-65535 之间的随机端口)
echo "[2/6] 生成随机 SSH 端口..."
RANDOM_PORT=$(shuf -i 10000-65535 -n 1)
SSHD_CONFIG="/etc/ssh/sshd_config"

# 备份配置文件
cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak"

# 修改端口 (如果 Port 行存在则替换，不存在则追加)
if grep -q "^Port" "$SSHD_CONFIG"; then
    sed -i "s/^Port.*/Port $RANDOM_PORT/" "$SSHD_CONFIG"
else
    echo "Port $RANDOM_PORT" >> "$SSHD_CONFIG"
fi

# 2. 关闭密码登录，启用密钥登录
echo "[3/6] 强化 SSH 配置 (禁止密码登录)..."
# 确保 PubkeyAuthentication yes
if grep -q "^PubkeyAuthentication" "$SSHD_CONFIG"; then
    sed -i "s/^PubkeyAuthentication.*/PubkeyAuthentication yes/" "$SSHD_CONFIG"
else
    echo "PubkeyAuthentication yes" >> "$SSHD_CONFIG"
fi

# 设置 PasswordAuthentication no
if grep -q "^PasswordAuthentication" "$SSHD_CONFIG"; then
    sed -i "s/^PasswordAuthentication.*/PasswordAuthentication no/" "$SSHD_CONFIG"
else
    echo "PasswordAuthentication no" >> "$SSHD_CONFIG"
fi

# 禁用空密码
sed -i "s/^PermitEmptyPasswords.*/PermitEmptyPasswords no/" "$SSHD_CONFIG"

# 4. 配置 Fail2Ban
echo "[4/6] 安装并配置 Fail2Ban..."
apt-get update -y > /dev/null
apt-get install fail2ban -y > /dev/null

# 创建本地配置副本以避免更新覆盖
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# 确保 fail2ban 监控新的 SSH 端口
# 在 jail.local 中找到 [sshd] 部分并设置端口
if grep -q "\[sshd\]" /etc/fail2ban/jail.local; then
    # 这是一个简化的配置注入，确保 sshd 启用并指向新端口
    # 注意：fail2ban 通常自动读取 sshd 配置，但显式指定更安全
    cat <<EOF > /etc/fail2ban/jail.d/defaults-debian.conf
[sshd]
enabled = true
port = $RANDOM_PORT
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF
fi

systemctl restart fail2ban
systemctl enable fail2ban

# 5. 安装 UFW 并配置防火墙
echo "[5/6] 配置 UFW 防火墙..."
apt-get install ufw -y > /dev/null

# 重置 UFW 规则 (可选，防止旧规则干扰，这里暂不强制重置，只添加)
ufw default deny incoming
ufw default allow outgoing

# 允许新的 SSH 端口
ufw allow "$RANDOM_PORT"/tcp

# 启用 UFW (非交互式)
echo "y" | ufw enable

# 6. 重启 SSH 服务应用更改
echo "[6/6] 重启 SSH 服务..."
systemctl restart sshd

echo "------------------------------------------------"
echo "✅ 配置完成！"
echo "------------------------------------------------"
echo "GitHub 用户: $GITHUB_USER"
echo "SSH 新端口 : $RANDOM_PORT"
echo "防火墙状态 : 已开启 (仅允许端口 $RANDOM_PORT)"
echo "Fail2Ban  : 已启用"
echo "------------------------------------------------"
echo "⚠️  注意: 请不要立即关闭当前窗口！"
echo "请打开一个新的终端，使用以下命令测试连接："
echo "ssh -p $RANDOM_PORT $USER@$(curl -s ifconfig.me)"
echo "------------------------------------------------"
