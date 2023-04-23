# 代码 snippets 与技术笔记

这里记录一些平时的心得体会、工作备忘录。在线阅读：[snippets.xfoss.com](https://snippets.xfoss.com)

---


## 在本地阅读

在本地阅读本书，需要安装 `mdbook` 程序。根据操作系统的不同，安装 `mdbook` 程序有所不同。


### 在 Linux 系统上

```console
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install mdbook
```

### 在 Windows 上

在 “Powershell（管理员）”（"Administrator: Windows Powershell"） 中，先安装 `choco`

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

经由 `choco` 安装 `msys2`

```powershell
choco install -y msys2
```

在 `msys2` 中安装 `mdbook`

```console
pacman -S mingw-w64-x86_64-mdbook
```

安装好 `mdbook` 后, 带一些命令行参数和开关运行服务器：

```console
mdbook serve ~/rust-lang-zh_CN -p 8080 -n 127.0.0.1 --open
```

> 注：当在 Windows 系统上时，咱们要在 `msys2` 的终端窗口中运行此命令。

此时，将在操作系统的默认浏览器中，打开本书。

---
# 运维
- [Flask `uwsgi` `supervisord`](01_flask_uwsgi_supervisord.md)
- [`ionic serve`](02_ionic_serve.md)
- [Ionic 4 flask cors](03_ionic_4_flask_cors.md)
- [Hackintosh](04_Hackintosh.md)
- [`modprobe`](05_modprobe.md)
- [06 Viewflow deploy notes](06_Viewflow_Deploy_Notes.md)
- [Add Linux to AD](07_Add_Linux_to_AD.md)
- [Extend a Disk Partion with Unallocated Disk Space in Linux](10_Extend_a_Disk_Partion_with_Unallocated_Disk_Space_in_Linux.md)
- [LDAP Query](11_LDAP_Query.md)
- [BPM Deployment](13_BPM_deployment.md)
- [RG AC Configuration Notes](16_RG_AC_configuration_notes.md)
- [Nginx php](18_nginx_php.md)
- [Wordpress Optimization](19_wordpress_optimization.md)
- [Dot 1 X Port Dynamic VLAN](22_dot1x_port_dynamic_vlan.md)
- [Huawei Switch SSH TELENT Weird Problem](23_Huawei_switch_SSH_TELENT_weird_problem.md)
- [Gitlab CE Deployment](25_gitlab_ce_deployment.md)
- [Epel Nginx Selinux Problem](26_epel_nginx_selinux_problem.md)
- [Zotrs Nginx Deployment](27_zotrs_nginx_deployment.md)
- [Samba Configuration](31_samba_configuration.md)
- [Git behind Proxy](33_git_behind_proxy.md)
- [Arch Linux Manjaro Autoproxy Pac](34_ArchLinux_Manjaro_autoproxy_pac.md)
- [Win Sys Admin](36_Win_SysAdmin.md)
- [Linux Sys Admin](39_Linux_SysAdmin.md)

---
# 编程开发
- [Sh Bash](00_sh_bash.md)
- [Using Huawei Repos](08_Using_Huawei_Repos.md)
- [`vim.gtk3` Installation Notes](09_vim.gtk3_Installation_Notes.md)
- [Java Learning](12_Java_Learning.md)
- [`ffmpeg`](15_ffmpeg.md)
- [Job Notes](20_job_notes.md)
- [Gitbook Polyfills Js Problem](21_gitbook_polyfills-js_problem.md)
- [Vim Tips](29_vim_tips.md)
- [Sapling SCM Usage](32_sapling-scm_usage.md)
- [`tmux` Manual](35_tmux_manual.md)

---
# 杂项
- [OA BPM](14_OA_BPM.md)
- [eteams.cn Notes](17_eteams.cn_notes.md)
- [SC Network Op](24_SC_network_op.md)
- [Manjaro User Tips](28_manjaro_user_tips.md)
- [HPC Knowledges](30_HPC_knowledges.md)
- [IPTV Watching Guide](37_IPTV_Watching_Guide.md)
- [ArchLinux Wi-Fi AP Setup](38_ArchLinux_Wi-Fi_ap_setup.md)
