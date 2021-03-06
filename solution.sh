#!/bin/bash
#
# https://github.com/DieNacht/I219-LM-Low-Performance-Solution
# Author: DieNacht
#
# Thanks to QSS
# https://blog.gloriousdays.pw/2020/07/20/intel-i219-lm-performance-issue-and-mitigation/

apt -y update
apt -y install git build-essential dkms networkd-dispatcher ethtool
cd /etc
git clone https://github.com/KozakaiAya/e1000e-rollback.git e1000e-3.8.4
cd e1000e-3.8.4
cp -R . /usr/src/e1000e-3.8.4
dkms add -m e1000e -v 3.8.4
dkms build -m e1000e -v 3.8.4
dkms install -m e1000e -v 3.8.4
cat << EOF > /usr/lib/networkd-dispatcher/routable.d/10-disable-offloading
#!/bin/sh
ethtool -K $(ip -o -4 route show to default | awk '{print $5}') tso off gso off
EOF
chmod 755 /usr/lib/networkd-dispatcher/routable.d/10-disable-offloading
reboot
