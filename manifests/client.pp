# Class: burp::client
#
#
class burp::client {

  file { '/etc/burp/burp.conf':
    ensure  => present,
    mode    => '600',
    content => template("burp/burp.conf.erb"),
    require => Class['burp::package']
  }

  if ($burp::cron == true){
    $randomcron = fqdn_rand(19)
    cron { 'initiate backup':
      command => '/usr/sbin/burp -a t',
      user    => root,
      minute  => [$randomcron,20+$randomcron, 40+$randomcron]
    }
  }

}
