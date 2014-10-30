# This class provides default options for mrepo that can be overridden as well
# as validating overridden parameters.
#
# Parameters:
# [*src_root*]
# The path to store the mrepo mirror data.
# Default: /var/mrepo
#
# [*www_root*]
# The path of the mrepo html document root.
# Default: /var/www/mrepo
#
# [*user*]
# The account to use for mirroring the files.
# Default: apache
#
# [*group*]
# The group to use for mirroring the files.
# Default: apache
#
# [*source*]
# The package source.
# Default: package
# Values: git, package
#
# [*selinux*]
# Whether to update the selinux context for the mrepo document root.
# Default: the selinux fact.
# Values: true, false
#
# [*rhn*]
# Whether to install redhat dependencies or not. Defaults to false.
# Default: false
# Values: true, false
#
# [*mailto*]
# The email recipient for mrepo updates. Defaults to unset
#
# == Examples
#
# node default {
#   class { "mrepo::params":
#     src_root     => '/srv/mrepo',
#     www_root     => '/srv/www/mrepo',
#     user         => 'www-user',
#     source       => 'package',
#     rhn          => true,
#   }
# }
#
# == Author
#
# Adrien Thebo <adrien@puppetlabs.com>
#
# == Copyright
#
# Copyright 2011 Puppet Labs, unless otherwise noted
#
class mrepo::params {

  $src_root       = '/var/mrepo'
  $webservice     = present
  $www_root       = '/var/www/mrepo'
  $www_servername = 'mrepo'
  $user           = 'apache'
  $group          = 'apache'
  $source         = 'package'
  $selinux        = false   # requires webservice be enabled too.
  $rhn            = false
  $mailto         = 'UNSET'
  $git_proto      = 'git'
  $descriptions   = {}
  $http_proxy     = ''
  $https_proxy    = ''


  validate_re($source, "^git$|^package$")
  validate_re($git_proto, "^git$|^https$")
  validate_bool($rhn)
  validate_hash($descriptions)

  if $rhn {
    validate_re($rhn_username, ".+")
    validate_re($rhn_password, ".+")
  }
}
