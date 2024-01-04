#! /bin/sh

cp /vagrant/compute1_interfaces /etc/network/interfaces
cp /vagrant/hosts /etc/hosts
cp /vagrant/grub /etc/default/grub

update-grub

# TODO: install required packages
echo "[TASK 1] install required packages on compute node"
apt update -y && apt dist-upgrade -y && apt upgrade -y
# add-apt-repository cloud-archive:zed -y
add-apt-repository cloud-archive:bobcat
apt install python3-pip python3 python3-simplejson glances chrony software-properties-common python3-openstackclient crudini nova-compute neutron-openvswitch-agent -y

### TODO: take backup from configurations before any change
echo "[TASK 2] take backup from configurations before any changes on compute node"
cp /etc/chrony/chrony.conf  /etc/chrony/chrony-backup-before-change.conf
cp /etc/nova/nova.conf /etc/nova/nova-backup-before-change.conf
cp /etc/nova/nova-compute.conf /etc/nova/nova-compute-backup-before-change.conf
cp /etc/neutron/neutron.conf /etc/neutron/neutron-backup-before-change.conf
cp /etc/neutron/plugins/ml2/openvswitch_agent.ini /etc/neutron/plugins/ml2/openvswitch_agent-backup-before-change.ini

### TODO: copy and apply configuration files
echo "[TASK 3] copy and apply configuration files on compute node"
cp /vagrant/chrony-compute1.conf  /etc/chrony/chrony.conf
cp /vagrant/nova-compute1.conf /etc/nova/nova.conf
cp /vagrant/nova-compute-compute1.conf /etc/nova/nova-compute.conf
cp /vagrant/neutron-compute1.conf /etc/neutron/neutron.conf
cp /vagrant/linuxbridge_agent-compute1-compute1.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini

### TODO: take backup from configurations before any change
echo "[TASK 4] take backup from configurations after changes on compute node"
cp /etc/chrony/chrony.conf  /etc/chrony/chrony-backup-after-change.conf
cp /etc/nova/nova.conf /etc/nova/nova-backup-after-change.conf
cp /etc/nova/nova-compute.conf /etc/nova/nova-compute-backup-after-change.conf
cp /etc/neutron/neutron.conf /etc/neutron/neutron-backup-after-change.conf
cp /etc/neutron/plugins/ml2/openvswitch_agent.ini /etc/neutron/plugins/ml2/openvswitch_agent-backup-after-change.ini

# TODO: apply /etc/network/interfaces without reboot


# TODO: configure NTP
echo "[TASK 5] configure and finalize NTP setups on compute node"
service chrony restart
chronyc sources
timedatectl

# TODO: configure nova on compute node
# finalize nova installation on copmute node
echo "[TASK 6] finalize nova installation on copmute node"
service nova-compute restart

# TODO: configure neutron on compute node
# finalize neutron installation on compute node
echo "[TASK 7] finalize neutron installation on compute node"
service nova-compute restart
service neutron-linuxbridge-agent restart

# verify services status on compute node
echo "[TASK 5] verify services status on compute node"
service nova-compute status
service neutron-linuxbridge-agent status

reboot