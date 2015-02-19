# Define: burp::clientconf
#
# Client config on burp server.
#
define burp::clientconf (
  $includes,
  $excludes,
  $options,
  $password,
  ) {

  file { "/etc/burp/clientconfdir/${title}":
    mode    => "600",
    content => template('burp/clientconf.erb'),
    require => File['/etc/burp/clientconfdir'],
  }

}
