# Class: burp::server
#
#
class burp::server {

  file { '/etc/burp/clientconfdir':
    ensure  => 'directory',
    require => Package['burp']
  }

  file { '/etc/burp/burp-server.conf':
    ensure  => present,
    mode    => '600',
    content => template("burp/burp-server.conf.erb"),
    require => Package['burp']
  }

  file { '/etc/default/burp':
    ensure  => present,
    mode    => '600',
    content => template("burp/default.erb"),
    require => Package['burp']
  }

  file { '/etc/burp/clientconfdir/incexc/common':
    ensure  => present,
    mode    => '600',
    content => template("burp/common.erb"),
    require => File['/etc/burp/clientconfdir']
  }

  service { 'burp':
    ensure  => 'running',
    require => File['/etc/burp/burp-server.conf'] 
  }
  
  # Modify backup_stats file so that logstash can use it as input
  if $burp::backup_stats_logstash == true {
    file { '/etc/burp/server_script_post':
      content => template("burp/server_script_post.erb"),
      mode    => 0700,
      require => Package['burp']
    }
  }

  create_resources('burp::clientconf', $burp::clientconf_hash)

}
