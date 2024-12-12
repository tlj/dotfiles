#!/bin/bash

# Exit on any error
set -e

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

echo "Starting Ubuntu server hardening process..."

# Update and upgrade system
echo "Updating system packages..."
apt-get -qq update && apt-get -qq upgrade -y

# Install SSH and essential security packages
echo "Installing SSH and security packages..."
apt-get -qq install -y \
    openssh-server \
    openssh-client \
    ufw \
    fail2ban \
    unattended-upgrades \
    apt-listchanges \
    logwatch \
    auditd \
    rkhunter \
    lynis

# Backup original SSH config
echo "Backing up original SSH configuration..."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%F)

# Configure SSH with secure defaults
echo "Configuring SSH with secure defaults..."
cat > /etc/ssh/sshd_config << EOF
# SSH Server Configuration
Protocol 2
Port 22

# Authentication
PermitRootLogin no
MaxAuthTries 3
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
AuthenticationMethods publickey

# Security
X11Forwarding no
AllowTcpForwarding no
AllowAgentForwarding no
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
Compression no

# Timeout Configuration
LoginGraceTime 30
ClientAliveInterval 300
ClientAliveCountMax 2

# Logging
SyslogFacility AUTH
LogLevel VERBOSE

# Access Controls
MaxStartups 10:30:60
MaxSessions 4
AllowUsers *@* # Modify this to restrict SSH access to specific users

# Banner
Banner /etc/issue.net
EOF

# Create a warning banner
echo "Creating SSH warning banner..."
cat > /etc/issue.net << EOF
***************************************************************************
UNAUTHORIZED ACCESS TO THIS DEVICE IS PROHIBITED
All actions performed on this system are logged and monitored.
***************************************************************************
EOF

# Set proper permissions on SSH directory and files
echo "Setting correct SSH directory permissions..."
chmod 755 /etc/ssh
chmod 644 /etc/ssh/*.pub
chmod 600 /etc/ssh/ssh_host_*_key

# Configure automatic security updates
echo "Configuring unattended-upgrades..."
cat > /etc/apt/apt.conf.d/50unattended-upgrades << EOF
Unattended-Upgrade::Allowed-Origins {
    "\${distro_id}:\${distro_codename}";
    "\${distro_id}:\${distro_codename}-security";
    "\${distro_id}ESMApps:\${distro_codename}-apps-security";
    "\${distro_id}ESM:\${distro_codename}-infra-security";
};
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Automatic-Reboot "false";
EOF

# Enable automatic updates
echo "Enable automatic updates..."
cat > /etc/apt/apt.conf.d/20auto-upgrades << EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF

# Restart SSH service
systemctl restart ssh

# Configure UFW (Uncomplicated Firewall)
echo "Configuring firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw --force enable

# Configure fail2ban
echo "Configuring fail2ban..."
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
cat > /etc/fail2ban/jail.local << EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF

systemctl restart fail2ban

# Secure shared memory
echo "Securing shared memory..."
echo "tmpfs     /run/shm     tmpfs     defaults,noexec,nosuid     0     0" >> /etc/fstab

# Secure sysctl settings
echo "Configuring sysctl security settings..."
cat > /etc/sysctl.d/99-security.conf << EOF
# IP Spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP broadcast requests
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0

# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Block SYN attacks
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5

# Log Martians
net.ipv4.conf.all.log_martians = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Disable IPv6 if not needed
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

sysctl -p /etc/sysctl.d/99-security.conf

# Set up system auditing
echo "Configuring system auditing..."
auditctl -e 1

# Set up basic auditd rules
cat > /etc/audit/rules.d/audit.rules << EOF
# Delete all existing rules
-D

# Buffer Size
-b 8192

# Failure Mode
-f 1

# Monitor file system mounts
-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts

# Monitor changes to system administration scope
-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d/ -p wa -k scope

# Monitor system authentication files
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/gshadow -p wa -k identity

# Monitor security related files
-w /var/log/auth.log -p wa -k auth_log
-w /var/log/syslog -p wa -k syslog

# Monitor SSH configuration changes
-w /etc/ssh/sshd_config -p wa -k sshd_config
EOF

service auditd restart

echo "Server hardening completed. Please review the changes and reboot the system."
echo "IMPORTANT: Before logging out, test SSH access with your key in a new session!"
echo ""
echo "Remember to:"
echo "1. Review and customize the SSH AllowUsers directive"
echo "2. Add your SSH public key to ~/.ssh/authorized_keys for necessary users"
echo "3. Keep your system regularly updated"
echo "4. Monitor system logs regularly"
echo "5. Consider additional security measures based on your specific needs"
