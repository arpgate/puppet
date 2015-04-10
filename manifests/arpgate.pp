
user { 'arpgate':
  ensure     => present,
  uid        => '507',
  gid        => 'root',
  shell      => '/bin/bash',
  home       => '/home/arpgate',
  managehome => true,
}

# create a directory      
file { "/etc/arpgate":
    ensure => "directory",
}

file {'/etc/arpgate/arpgate.conf':
  ensure  => present,
  content => "#arpgate",
}