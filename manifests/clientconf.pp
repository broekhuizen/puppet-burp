# Define: burp::clientconf
#
# This file is needed on the server for each client.
#
define burp::clientconf (
  $password,
  ) {

  file { "/etc/burp/clientconfdir/${title}":
    mode    => "600",
    content => template('burp/clientconf.erb'),
    require => File['/etc/burp/clientconfdir'],
  }

}
