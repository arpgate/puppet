
user { 'arpgate':
  ensure     => present,
  uid        => '507',
  gid        => 'admin',
  shell      => '/bin/bash',
  home       => '/home/arpgate',
  managehome => true,
}

file {'/etc/arpgate/arpgate.conf':
  ensure  => present,
  content => "#arpgate",
}