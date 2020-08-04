# BBR 一键脚本 Debian9+/Ubuntu16+/Centos7+
# https://blog.ylx.me/archives/783.html
wget -N --no-check-certificate "https://github.000060000.xyz/tcpx.sh" && chmod +x tcpx.sh && ./tcpx.sh

# 修改配置
sed  -i 's/default_qdisc=fq/default_qdisc=fq_codel/g' /etc/sysctl.conf

cat >> /etc/sysctl.conf <<EOF
net.core.netdev_max_backlog=250000
net.core.rmem_default = 2129920
net.core.wmem_default = 2129920
net.core.rmem_max=67108864
net.core.wmem_max=67108864
net.ipv4.ip_local_port_range=10000 65000
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_keepalive_time = 50
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_max_syn_backlog=16384
net.ipv4.tcp_max_tw_buckets=5000
net.ipv4.tcp_rmem=4096 4096 16777216
net.ipv4.tcp_wmem=4096 4096 16777216
net.ipv4.tcp_mem=786432 2097152 3145728
net.ipv4.tcp_syncookies=1
#net.ipv4.tcp_tw_recycle=0
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_timestamps = 0
net.ipv4.neigh.default.gc_stale_time=120
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce=2
net.ipv4.conf.all.arp_announce=2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_mtu_probing = 1
fs.file-max = 65535
net.core.somaxconn = 65535
net.ipv4.ip_forward=1
net.ipv6.conf.all.disable_ipv6=1
EOF

# 保存退出后执行
[ -f /etc/security/limits.conf ] && LIMIT='262144' && sed -i '/^\(\*\|root\)[[:space:]]*\(hard\|soft\)[[:space:]]*\(nofile\|memlock\)/d' /etc/security/limits.conf && echo -ne "*\thard\tmemlock\t${LIMIT}\n*\tsoft\tmemlock\t${LIMIT}\nroot\thard\tmemlock\t${LIMIT}\nroot\tsoft\tmemlock\t${LIMIT}\n*\thard\tnofile\t${LIMIT}\n*\tsoft\tnofile\t${LIMIT}\nroot\thard\tnofile\t${LIMIT}\nroot\tsoft\tnofile\t${LIMIT}\n\n" >>/etc/security/limits.conf

# 执行后运行
sysctl -p

# 重启
reboot

