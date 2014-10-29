# This class installs and configures apache to serve mrepo repositories.
#
# == Examples
#
# This class does not need to be directly included
#
# == Author
#
# Adrien Thebo <adrien@puppetlabs.com>
#
# == Copyright
#
# Copyright 2011 Puppet Labs, unless otherwise noted
#
class mrepo::webservice(
  $ensure         = present,
  $user           = $mrepo::params::user,
  $group          = $mrepo::params::group,
  $www_root       = $mrepo::params::www_root,
  $www_servername = $mrepo::params::www_servername
) inherits mrepo::params {

  case $ensure {
    present: {
      include apache

      file { $www_root:
        ensure  => directory,
        owner   => $user,
        group   => $group,
        mode    => '0755',
      }

      apache::vhost { "mrepo":
        priority        => "10",
        port            => "80",
        servername      => $www_servername,
        docroot         => $www_root,
        custom_fragment => template("${module_name}/apache.conf.erb"),
      }
    }
    absent: {
      apache::vhost { "mrepo":
        ensure  => $ensure,
        port    => "80",
        docroot => $www_root,
      }
    }
  }
}
