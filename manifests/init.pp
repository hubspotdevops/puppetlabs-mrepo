# This class installs mrepo and all dependencies.
#
# Directly including this class is optional; if you instantiate an mrepo::repo
# the necessary dependencies will be pulled in. If you plan on managing mirrors
# outside of puppet and only want dependencies to be installed, then include
# this class.
#
#
# == Parameters
#
# repo_hash = undef (Default)
# Hash with repo definitions to create
# These can also be provided via Hiera
#
# Other optional parameters can be found in the mrepo::params class
#
# == Examples
#
#  node default {
#    class { "mrepo": }
#  }
#
# == Author
#
# Adrien Thebo <adrien@puppetlabs.com>
#
# == Copyright
#
# Copyright 2011 Puppet Labs, unless otherwise noted
#
class mrepo (
  $user           = $mrepo::params::user,
  $group          = $mrepo::params::group,
  $source         = $mrepo::params::source,
  $git_proto      = $mrepo::params::git_proto,
  $src_root       = $mrepo::params::src_root,
  $webservice     = $mrepo::params::webservice,
  $www_root       = $mrepo::params::www_root,
  $www_servername = $mrepo::params::www_servername,
  $rhn            = $mrepo::params::rhn,
  $rhn_username   = $mrepo::params::rhn_username,
  $rhn_password   = $mrepo::params::rhn_password,
  $mailto         = $mrepo::params::mailto,
  $http_proxy     = $mrepo::params::http_proxy,
  $https_proxy    = $mrepo::params::https_proxy
) inherits mrepo::params{

  include mrepo::selinux

  anchor { 'mrepo::begin':
    before => Class['mrepo::package'],
  }

  class { '::mrepo::package':
    user         => $user,
    group        => $group,
    source       => $source,
    git_proto    => $git_proto,
    src_root     => $src_root,
    www_root     => $www_root,
    rhn_username => $rhn_username,
    rhn_password => $rhn_password,
    mailto       => $mailto,
    http_proxy   => $http_proxy,
    https_proxy  => $https_proxy,
  }

  if $rhn == true {
    class { '::mrepo::rhn': }

    Class['::mrepo::package'] ->
    Class['::mrepo::rhn'] ->
    Anchor['mrepo::end']
  }

  # Set $webservice to ahnything else to not set it up.
  if $webservice == present or $webservice == absent {
    class { '::mrepo::webservice' :
      ensure         => $webservice,
      user           => $user,
      group          => $group,
      www_root       => $www_root,
      www_servername => $www_servername
    }

    Class['mrepo::package'] ->
    Class['mrepo::webservice'] ->
    Anchor['mrepo::end']
  }

  Class['mrepo::params']     -> Class['mrepo::package']
  Class['mrepo::package']    -> Class['mrepo::selinux']
  Class['mrepo::webservice'] -> Class['mrepo::selinux']
  Class['mrepo::selinux']    -> Class['mrepo::repos']

  anchor { 'mrepo::end':
    require => [
#      Class['mrepo::package'],
#      Class['mrepo::selinux'],
      Class['mrepo::repos'],
    ],
  }
}

