# arpgate puppet file

include  nmap, tmux , dns::server, sqlite

# update
exec { 'apt-get update':
  path => '/usr/bin',
}

# create directories
file { "/etc/arpgate":
    ensure => "directory",
}

file {'/etc/arpgate/arpgate.conf':
  ensure  => present,
  content => "${macaddress_eth0}  ",
}

file { '/var/www/':
  ensure => 'directory',
}

file {'/opt/tftp':
    ensure => directory,
}

# create users
user { 'arpgate':
  ensure     => present,
  uid        => '507',
  gid        => 'root',
  shell      => '/bin/bash',
  home       => '/home/arpgate',
  managehome => true,
}

class ntp {
    package { 'ntp':
            ensure => latest,
    }
}

class sshd { 
    package { 'openssh-server': 
        ensure => latest 
    } 
}

class golang {
    package { 'golang': 
        ensure => latest
    }
}

node 'arpgate.home.local' {
  include dns::server

  # Forwarders
  dns::server::options { '/etc/bind/named.conf.options':
    forwarders => [ '8.8.8.8', '8.8.4.4' ]
  }

  # Forward Zone
    dns::zone { 'home.local':
    soa         => 'ns1.home.local',
    soa_email   => 'admin.home.local',
    nameservers => ['ns1']
  }

  # Reverse Zone
  dns::zone { '0.0.10.IN-ADDR.ARPA':
    soa         => 'ns1.home.local',
    soa_email   => 'admin.home.local',
    nameservers => ['ns1']
  }

  # A Records:
  dns::record::a {
    'arpgate':
      zone => 'home.local',
      data => ['10.0.0.7'];
  }
}

class { 'dhcp':
  dnsdomain    => [
    'home.local',
    '0.0.10.in-addr.arpa',
    ],
  nameservers  => ['10.0.0.7'],
  ntpservers   => ['10.0.0.7'],
  interfaces   => ['eth0'],
  pxeserver    => '10.0.0.7',
  pxefilename  => 'pxelinux.0',
}

dhcp::pool{ 'home.local':
  network => '10.0.0.0',
  mask    => '255.255.255.0',
  range   => ['10.0.0.100 10.0.0.200'],
  gateway => '10.0.0.1',
}

package { 'haproxy':
    ensure => 'present',
}

file {'/etc/haproxy/haproxy.cfg': 
    ensure => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0777',
    require => Package['haproxy'],
    source => 'puppet:///modules/arpgate/haproxy.cfg',
}

service { 'haproxy':
    ensure => running,
    require => Package['haproxy'],
    enable => true,
}

package { 'nginx':
    ensure => 'present',
}

file { "/etc/nginx/sites-enabled/default":
    require => Package["nginx"],
    ensure  => absent,
    notify  => Service["nginx"]
}

file {'/etc/nginx/sites-available/127.0.0.1': 
    ensure => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0777',
    require => Package['nginx'],
    source => 'puppet:///modules/arpgate/127.0.0.1',
}

file { 'arpgate-nginx-enable':
    path => '/etc/nginx/sites-enabled/127.0.0.1',
    target => '/etc/nginx/sites-available/127.0.0.1',
    ensure => link,
    notify => Service['nginx'],
    require => [
      File['/etc/nginx/sites-available/127.0.0.1'],
    ],
}

service { 'nginx':
    ensure => running,
    require => Package['nginx'],
    enable => true,
}

class {'firewall':

}

class { 'tftp':
  directory => '/opt/tftp',
  address   => $::ipaddress,
  options   => '--ipv6 --timeout 60',
}

