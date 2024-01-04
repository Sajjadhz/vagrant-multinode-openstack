#! /bin/sh

cp /vagrant/controller_interfaces /etc/network/interfaces
cp /vagrant/hosts /etc/hosts
cp /vagrant/grub /etc/default/grub

update-grub

# TODO: install required packages
echo "[TASK 1] install required packages"
apt update -y && apt dist-upgrade -y && apt upgrade -y
add-apt-repository cloud-archive:bobcat
apt install python3-pip python3 python3-simplejson
pip3 install boto3
pip3 install osc-placement
apt install glances chrony python3-openstackclient crudini mariadb-server python3-pymysql curl gnupg apt-transport-https rabbitmq-server memcached python3-memcache etcd software-properties-common keystone glance wget nova-api nova-conductor nova-novncproxy nova-scheduler placement-api neutron-server neutron-plugin-ml2 neutron-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent openstack-dashboard -y 
### TODO: take backup from configurations before any changes
echo "[TASK 2] take backup from configurations before any changes"
cp /etc/chrony/chrony.conf  /etc/chrony/chrony-backup-before-change.conf
cp /etc/memcached.conf /etc/memcached-backup-before-change.conf
cp /etc/default/etcd /etc/default/etcd-backup-before-change
cp /etc/keystone/keystone.conf /etc/keystone/keystone-backup-before-change.conf
cp /etc/apache2/apache2.conf /etc/apache2/apache2-backup-before-change.conf
cp /etc/glance/glance-api.conf /etc/glance/glance-api-backup-before-change.conf
cp /etc/placement/placement.conf /etc/placement/placement-backup-before-change.conf
cp /etc/nova/nova.conf /etc/nova/nova-backup-before-change.conf
cp /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent-backup-before-change.ini
cp /etc/neutron/neutron.conf /etc/neutron/neutron-backup-before-change.conf
cp /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf-backup-before-change.ini
cp /etc/neutron/l3_agent.ini /etc/neutron/l3_agent-backup-before-change.ini
cp /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent-backup-before-change.ini
cp /etc/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings-backup-before-change.py
cp /etc/neutron/plugins/ml2/openvswitch_agent.ini /etc/neutron/plugins/ml2/openvswitch_agent-backup-before-change.ini

# TODO: copy and apply configuration files
echo "[TASK 3] copy and apply configuration files"
cp /vagrant/chrony.conf  /etc/chrony/chrony.conf
cp /vagrant/90-openstack.cnf /etc/mysql/mariadb.conf.d/90-openstack.cnf
cp /vagrant/memcached.conf /etc/memcached.conf
cp /vagrant/etcd /etc/default/etcd
cp /vagrant/keystone.conf /etc/keystone/keystone.conf
cp /vagrant/apache2.conf /etc/apache2/apache2.conf
cp /vagrant/glance-api.conf /etc/glance/glance-api.conf
cp /vagrant/placement.conf /etc/placement/placement.conf
cp /vagrant/nova.conf /etc/nova/nova.conf
cp /vagrant/metadata_agent.ini /etc/neutron/metadata_agent.ini
cp /vagrant/neutron.conf /etc/neutron/neutron.conf
cp /vagrant/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini
cp /vagrant/l3_agent.ini /etc/neutron/l3_agent.ini
cp /vagrant/dhcp_agent.ini /etc/neutron/dhcp_agent.ini
cp /vagrant/local_settings.py /etc/openstack-dashboard/local_settings.py
cp /vagrant/openvswitch_agent.ini /etc/neutron/plugins/ml2/openvswitch_agent.ini

### TODO: take backup from configurations after changes
echo "[TASK 4] take backup from configurations after changes"
cp /etc/chrony/chrony.conf  /etc/chrony/chrony-backup-after-change.conf
cp /etc/memcached.conf /etc/memcached-backup-after-change.conf
cp /etc/default/etcd /etc/default/etcd-backup-after-change
cp /etc/keystone/keystone.conf /etc/keystone/keystone-backup-after-change.conf
cp /etc/apache2/apache2.conf /etc/apache2/apache2-backup-after-change.conf
cp /etc/glance/glance-api.conf /etc/glance/glance-api-backup-after-change.conf
cp /etc/placement/placement.conf /etc/placement/placement-backup-after-change.conf
cp /etc/nova/nova.conf /etc/nova/nova-backup-after-change.conf
cp /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent-backup-after-change.ini
cp /etc/neutron/neutron.conf /etc/neutron/neutron-backup-after-change.conf
cp /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf-backup-after-change.ini
cp /etc/neutron/l3_agent.ini /etc/neutron/l3_agent-backup-after-change.ini
cp /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent-backup-after-change.ini
cp /etc/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings-backup-after-change.py
cp /etc/neutron/plugins/ml2/openvswitch_agent.ini /etc/neutron/plugins/ml2/openvswitch_agent-backup-after-change.ini

# TODO: apply /etc/network/interfaces without reboot


# TODO: configure NTP
# TODO: Finalize NTP
echo "[TASK 5] configure and finalize NTP setups"
service chrony restart
chronyc sources
timedatectl

# TODO: configure MySQL DB
# TODO: Finalize MySQL DB installation
echo "[TASK 6] configure and finalize mysql setups"
# TODO: Secure database (Optional)
service mysql restart

# TODO: configure rabbitmq
echo "[TASK 7] configure and finalize rabbitmq setups"
rabbitmqctl add_user openstack openstack
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# TODO: configure memcached
# TODO: Finalize memcached installation
echo "[TASK 8] configure and finalize memcached setups"
service memcached restart

# TODO: configure etcd
# TODO: Finalize etcd installation
echo "[TASK 8] configure and finalize etcd setups"
systemctl enable etcd
systemctl restart etcd


# TODO: create components user on database and grant proper access to them
echo "[TASK 9] create database required datases and privileges"
echo "CREATE DATABASE keystone;"|mysql
echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'openstack';"|mysql
echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'openstack';"|mysql
echo "CREATE DATABASE glance;"|mysql
echo "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'openstack';"|mysql
echo "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'openstack';"|mysql
echo "CREATE DATABASE nova_api;"|mysql
echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'openstack';"|mysql
echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'openstack';"|mysql
echo "CREATE DATABASE nova;"|mysql
echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'openstack';"|mysql
echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'openstack';"|mysql
echo "CREATE DATABASE nova_cell0;"|mysql
echo "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'openstack';"|mysql
echo "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'openstack';"|mysql
echo "CREATE DATABASE neutron;"|mysql
echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'openstack';"|mysql
echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'openstack';"|mysql
echo "CREATE DATABASE cinder;"|mysql
echo "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'openstack';"|mysql
echo "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'openstack';"|mysql
echo "CREATE DATABASE placement;"|mysql
echo "GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY 'openstack';"|mysql
echo "GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY 'openstack';"|mysql
# only for test, remove next 3 lines
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';"|mysql
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';"|mysql
echo "flush privileges;"|mysql

# TODO: configure keystone
echo "[TASK 10] configure and finalize keystone setups"
su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap --bootstrap-password openstack --bootstrap-admin-url http://controller:5000/v3/ --bootstrap-internal-url http://controller:5000/v3/ --bootstrap-public-url http://controller:5000/v3/ --bootstrap-region-id RegionOne
service apache2 restart
echo "[TASK 11] verify keystone setups"
export OS_USERNAME=admin
export OS_PASSWORD=openstack
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

openstack domain create --description "An Example Domain" example
openstack domain list
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" myproject
openstack project list
openstack user create --domain default --password openstack myuser
openstack user list
openstack role create myrole
openstack role add --project myproject --user myuser myrole
unset OS_AUTH_URL OS_PASSWORD
openstack --os-auth-url http://controller:5000/v3 --os-password openstack --os-project-domain-name Default --os-user-domain-name Default --os-project-name admin --os-username admin token issue
openstack --os-auth-url http://controller:5000/v3 --os-password openstack --os-project-domain-name Default --os-user-domain-name Default --os-project-name myproject --os-username myuser token issue

cat >> ./admin-openrc <<EOF
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=openstack
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF

cat >> ./demo-openrc <<EOF
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=myproject
export OS_USERNAME=myuser
export OS_PASSWORD=openstack
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF

source ./admin-openrc
openstack token issue

# # configure glance
echo "[TASK 13] configure and finalize glance setups"
openstack user create --domain default --password openstack glance
openstack user list
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack service list
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292
openstack endpoint list
sed -i "s/ENDPOINT_ID/`openstack endpoint list --service glance --interface public | awk '{print $2}'  | sed -n '4 p'`/" /etc/glance/glance-api.conf
# register qouta limit (optional)
openstack role add --user glance --user-domain Default --system all reader
su -s /bin/sh -c "glance-manage db_sync" glance
service glance-api restart
# TODO: verify glance
echo "[TASK 13] verify glance setups"
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
# openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public
# or
glance image-create --name "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --visibility=public
glance image-list


# # TODO: configure placement
echo "[TASK 14] verify placement setups"
openstack user create --domain default --password openstack placement
openstack user list
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack service list
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778
openstack endpoint list
su -s /bin/sh -c "placement-manage db sync" placement
service apache2 restart

# TODO: verify placement setups
echo "[TASK 15] verify placement setups"
placement-status upgrade check
openstack --os-placement-api-version 1.2 resource class list --sort-column name
openstack --os-placement-api-version 1.6 trait list --sort-column name

# # TODO: configure Nova
echo "[TASK 16] configure and finalize Nova setups"
openstack user create --domain default --password openstack nova
openstack user list
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack service list
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1
openstack endpoint list
service nova-api restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart

# TODO: verify nova setups
echo "[TASK 17] verify Nova setups"
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova
service nova-api restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart

# # TODO: configure Neutron
echo "[TASK 18] configure and finalize Neutron setups"
openstack user create --domain default --password openstack neutron
openstack user list
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack service list
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696
openstack endpoint list
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
service nova-api restart
service neutron-server restart
service neutron-openvswitch-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-l3-agent restart

# verify services status
echo "[TASK 19] verify all services - final verification"
service chrony status
service mysql status
service memcached status
service etcd status
service apache2 status
service glance-api status
service nova-api status
service nova-scheduler status
service nova-conductor status
service nova-novncproxy status
service neutron-server status
service neutron-openvswitch-agent status
service neutron-dhcp-agent status
service neutron-metadata-agent status
service neutron-l3-agent status

# verify openstack components
echo "[TASK 20] openstack components - final verification"
openstack user list
openstack service list
openstack endpoint list
openstack network list
openstack flavor list
openstack server list
openstack group list
openstack security group list
openstack domain list
openstack project list

# TODO: configure horizon
echo "[TASK 21] configure and finalize horizon"
systemctl reload apache2.service

reboot
