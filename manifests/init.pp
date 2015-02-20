# == Class: burp
#
# Full description of class burp here.
#
# === Parameters
#
# Document parameters here.
#
# [*mode*]
#   String.
#   Default: client
#   Valid values: client, server
#
# [*ssl_key_password*]
#   String. Password used only once, before the first backupjob, when creating ssl keys
#   Default: ssl_key_password
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { burp:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name rudi.broekhuizen@naturalis.nl
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#

class burp (
# general settings
  $mode             = "client",
  $ssl_key_password = "ssl_key_password",          # must be the same on client and server
  $password         = "password",
  $extra_options    = [ 'ratelimit=10' ],          # see http://burp.grke.org/docs/manpage.html for all options

# client: settings for /etc/burp/burp.conf on client
  $server             = "172.16.3.13",
  $cname              = $fqdn,
  $server_can_restore = "1",
  $includes           = [ '/home', '/var/log' ],
  $excludes           = [ '/home/ubuntu' ],
 
# server: settings for /etc/burp-server.conf
  $directory             = "/mnt/backup/burpdata",
  $max_children          = "25",
  $max_status_children   = "25",
  $keep                  = "100",
  $waittime              = "20h",
  $starttime             = "Mon,Tue,Wed,Thu,Fri,Sat,Sun,00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23",
  $backup_stats_logstash = true,
  $common_clientconfig   = [ 'working_dir_recovery_method=resume' ],

# server: create client config files in /etc/clientconfdir
  $clientconf_hash = { 'windowsclient.domain' => { password => 'password', },
                         'linuxclient.domain' => { password => 'password', },
                         'workstation.domain' => { password => 'password', },
                     },
) {

  # Install package 
  include burp::package

  if $mode == "server" {
    class { 'burp::server': }

  } elsif $mode == "client" {
      class { 'burp::client': }

    } else {
        fail( "Please set mode: server or client..." )
  }

}
