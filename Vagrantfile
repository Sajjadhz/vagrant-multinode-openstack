# -*- mode: ruby -*-
# vi: set ft=ruby :
servers=[
  {
    :hostname => "controller",
    :box => "generic/ubuntu2204",
    :ram => 8192,
    :cpu => 2,
    :disk => "100GB",
    :script => "controller_setup.sh",
    :ip => "10.0.0.11"
  },
  {
    :hostname => "compute1",
    :box => "generic/ubuntu2204",
    :ram => 8192,
    :cpu => 4,
    :disk => "100GB",
    :script => "compute1_setup.sh",
    :ip => "10.0.0.31"
  },
  {
    :hostname => "block1",
    :box => "generic/ubuntu2204",
    :ram => 4096,
    :cpu => 1,
    :disk => "100GB",
    :script => "block1_setup.sh",
    :ip => "10.0.0.41"
  },
  {
    :hostname => "object1",
    :box => "generic/ubuntu2204",
    :ram => 4096,
    :cpu => 1,
    :disk => "100GB",
    :script => "object1_setup.sh",
    :ip => "10.0.0.51"
  }#,
  # {
  #   :hostname => "deployment",
  #   :box => "generic/ubuntu2204",
  #   :ram => 2048,
  #   :cpu => 1,
  #   :disk => "40GB",
  #   :script => "deployment_setup.sh",
  #   :ip => "10.0.0.100"
  # }
]

Vagrant.configure(2) do |config|
    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.synced_folder ".", "/vagrant"
            # node.disksize.size = machine[:disk]
            node.vm.disk :disk, name: machine[:hostname], size: machine[:disk]
            node.vm.hostname = machine[:hostname]
            node.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--memory", machine[:ram], "--cpus", machine[:cpu]]
                vb.customize ["modifyvm", :id, "--nic2", "hostonly", "--hostonlyadapter2", "vboxnet0"]
                vb.customize ["modifyvm", :id, "--nic3", "natnetwork", "--nat-network3", "ProviderNetwork1", "--nicpromisc3", "allow-all"]
                if machine[:hostname] == "block1"
                    file_to_disk = File.realpath( "." ).to_s + "/block1cinder1.vdi"
                    vb.customize ['createhd', '--filename', file_to_disk, '--format', 'VDI', '--size', "30720"]
                   # In line below: 'SCSI' may have to be changed to possibly other name of Storage Controller Name of VirtualBox VM
                    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
                end
              end
            node.vm.provision "shell", path: machine[:script], privileged: true, run: "once"
            end
      end
end
