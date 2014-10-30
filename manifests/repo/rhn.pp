# This define creates and manages a redhat mrepo repository.
#
# == Parameters
#
# [*rhn*]
# Whether to generate rhn metadata for these repos.
# Default: false
#
# [*rhnrelease*]
# The name of the RHN release as understood by mrepo. Optional.
#
# == Examples
#
# TODO
#
# Further examples can be found in the module README.
#
# == Author
#
# Adrien Thebo <adrien@puppetlabs.com>
#
# == Copyright
#
# Copyright 2012 Puppet Labs, unless otherwise noted
#
define mrepo::repo::rhn (
  $ensure,
  $release,
  $arch,
  $rhn_username,
  $rhn_password,
  $urls         = {},
  $metadata     = 'repomd',
  $update       = 'nightly',
  $hour         = '0',
  $iso          = '',
  $typerelease  = $release,
  $repotitle    = $name,
  $user         = undef,
  $group        = undef,
  $http_proxy   = undef,
  $https_proxy  = undef,
  $src_root     = undef,
) {
  include mrepo::params

  # Set user and group.
  if $user == undef {
    $real_user = $mrepo::params::user
  } else {
    $real_user = $user
  }

  if $group == undef {
    $real_group = $mrepo::params::group
  } else {
    $real_group = $group
  }

  if $src_root == undef {
    $real_src_root = $mrepo::params::src_root
  } else {
    $real_src_root = $src_root
  }

  case $ensure {
    present: {
      exec { "Generate systemid $name - $arch":
        command   => "gensystemid -u '${rhn_username}' -p '${rhn_password}' --release '${typerelease}' --arch '${arch}' '${real_src_root}/${name}'",
        path      => [ '/bin', '/usr/bin' ],
        user      => $real_user,
        group     => $real_group,
        creates   => "${real_src_root}/${name}/systemid",
        require   => [
          Class['mrepo::package'],
          Class['mrepo::rhn'],
        ],
        before      => Exec["Generate mrepo repo ${name}"],
        logoutput   => on_failure,
        environment => ["http_proxy=${http_proxy}","https_proxy=${https_proxy}"],
      }
    }
  }
}
