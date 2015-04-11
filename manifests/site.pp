# arpgate puppet file

include  nmap 

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


package { 'haproxy':
    ensure => 'present',
}

file {'/etc/haproxy/haproxy.cfg': 
    ensure => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0777',
    require => Package['haproxy'],
    source => 'puppet:///modules/haproxy/haproxy.cfg',
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
    source => 'puppet:///modules/nginx/127.0.0.1',
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

