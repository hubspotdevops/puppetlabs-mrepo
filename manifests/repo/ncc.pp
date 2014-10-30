# This define creates and manages a SLE mrepo repository.
#
# == Parameters
#
# [*ncc_username*]
# The ncc username, which can be found in /etc/zypp.d/NCCCredentials
#
# [*ncc_password*]
# The ncc password, which can be found in /etc/zypp.d/NCCCredentials
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
define mrepo::repo::ncc (
  $ensure,
  $release,
  $arch,
  $ncc_username,
  $ncc_password,
  $urls        = {},
  $metadata    = 'repomd',
  $update      = 'nightly',
  $hour        = '0',
  $iso         = '',
  $repotitle   = $name,
  $typerelease = $release,
  $user        = undef,
  $group       = undef,
  $src_root    = undef
) {
  # This Class needs testing... no SLES here....
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
      $real_name = mrepo_munge($name, $arch)
      $src_root_subdir = "${real_src_root}/${real_name}"

      file {
      "${src_root_subdir}/deviceid":
        ensure  => present,
        owner   => $real_user,
        group   => $real_group,
        mode    => '0640',
        backup  => false,
        content => $ncc_username;
      "${src_root_subdir}/secret":
        ensure  => present,
        owner   => $real_user,
        group   => $real_group,
        mode    => '0640',
        backup  => false,
        content => $ncc_password;
      }
    }
  }
}
