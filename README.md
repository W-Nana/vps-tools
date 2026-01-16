# 🧰 VPS Tools Collection

---

## 🚀 1. 综合管理工具箱 (VPS Tools)

集成了服务器性能测试、网络质量检测以及节点搭建的一站式脚本。

### 功能特性
- ✅ **融合怪测评**：调用 ECS 脚本进行 CPU、内存、硬盘及流媒体解锁测试。
- ✅ **IP 质量体检**：深度检测 IP 的欺诈值、流媒体访问限制等。
- ✅ **节点快速部署**：支持 XrayR、V2bX 及 Warp 的一键安装与配置。

### ⚡ 快速安装
```bash
bash <(curl -L tools.7white.de/tools.sh)

```

<details>
<summary><strong>📚 引用项目 (Credits)</strong> - 点击展开</summary>

> 本脚本整合或修改自以下优秀的开源项目：
> * [spiritLHLS/ecs](https://github.com/spiritLHLS/ecs)
> * [oneclickvirt/ecs](https://github.com/oneclickvirt/ecs)
> * [xykt/IPQuality](https://github.com/xykt/IPQuality)
> * [XrayR-project/XrayR-release](https://github.com/XrayR-project/XrayR-release)
> * [wyx2685/XrayR-release](https://github.com/wyx2685/XrayR-release)
> * [wyx2685/V2bX-script](https://github.com/wyx2685/V2bX-script)
> * [fscarmen/warp-sh](https://github.com/fscarmen/warp-sh)
> 
> 

</details>

---

## 🛡️ 2. 服务器安全加固 (SSHarden)

Linux 服务器初始化必备的安全加固脚本，防止暴力破解与未授权访问。

### 功能特性

* 🔑 **自动导入公钥**：直接从 GitHub 获取指定用户的 SSH 公钥 (`github.com/User.keys`)。
* 🚫 **禁用密码登录**：强制使用密钥认证，关闭密码验证。
* 🎲 **随机 SSH 端口**：自动更改默认的 22 端口为随机高位端口。
* 🧱 **防火墙配置**：安装 UFW 并仅放行 SSH 端口。
* 👮 **Fail2Ban**：自动配置防爆破保护。

### ⚡ 快速使用

**注意**：请替换 `[Github用户名]` 为你实际的 GitHub ID。

```bash
bash <(curl -L tools.7white.de/SSHarden.sh) [Github用户名]
