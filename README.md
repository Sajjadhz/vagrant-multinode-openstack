# Introduction
In this repository we are trying to install multi node openstack version bobcat (2023.2) on ubuntu 22.04 virtual machines using vagrant.

## How to install 
1. create two networks on VirtualBox one host-only 10.0.0.0/24 named vboxnet0 and another one NAT 203.0.113.0/24 name ProviderNetwork1.
2. `git clone https://github.com/Sajjadhz/vagrant-multinode-openstack.git`
3. `cd vagrant-multinode-openstack`
4. `vagrant up`

## How to use
On your browser go to the 10.0.0.11/horizon login with user: 'admin' and password: 'openstack', default domain is 'Default', you should change the password for you environment.

## How to destroy
In order to destroy the vms run following command.
`vagrant destroy`
