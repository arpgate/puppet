# puppet
puppet scripts to build an arpgate image

The modules directory includes all Puppet modules.

To checkout in /home/ubuntu/puppet on the Raspberry Pi:

cd /home/ubuntu/puppet

git clone https://github.com/arpgate/puppet 


If you like to install the modules manually do:

sudo puppet module install  --modulepath=/home/ubuntu/puppet/modules puppetlabs-concat

sudo puppet module install  --modulepath=/home/ubuntu/puppet/modules puppetlabs-haproxy

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules saz-ssh

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules puppetlabs-ntp

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules jfryman-nginx

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules dcoxall-golang

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules puppetlabs-haproxy

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules puppetlabs-firewall

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules  ghoneycutt-nmap

sud0 puppet module install --modulepath=/home/ubuntu/puppet/modules puppetlabs-tftp

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules puppetlabs-dhcp

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules zanloy-tmux

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules ajjahn-dns

sudo puppet module install --modulepath=/home/ubuntu/puppet/modules puppetlabs-sqlite
