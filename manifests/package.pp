# This class installs mrepo from source or from the system package repository
#
# == Parameters
#
# [*user*]
#   Username to set owner of config files and directories.
#
# [*group*]
#   Group name to set owner of config files and directories.
#
# [*source*]
#   Source for installing mrepo.
#   values: package, git
#
# [*git_proto*]
#   Protocol to use when installing via git.
#
# [*src_root*]
#   Directory to store packages.
#
# [*www_root*]
#   Directory for serving packages from via web server.
#
# [*rhn_username*]
#   RHN username.  Used for mirroring from RHN.
#
# [*rhn_password*]
#   RHN password.  Used for mirroring from RHN.
#
# [*mailto*]
#   Email address for notifications.
#
# [*http_proxy*]
#   HTTP proxy URL
#
# [*https_proxy*]
#   HTTPS proxy URL.
#
# == Examples
#
# This class does not need to be directly included.
#
# == Author
#
# Adrien Thebo <adrien@puppetlabs.com>
#
# == Copyright
#
# Copyright 2011 Puppet Labs, unless otherwise noted
#
class mrepo::package (
  $user         = $mrepo::params::user,
  $group        = $mrepo::params::group,
  $source       = $mrepo::params::source,
  $git_proto    = $mrepo::params::git_proto,
  $src_root     = $mrepo::params::src_root,
  $www_root     = $mrepo::params::www_root,
  $rhn_username = $mrepo::params::rhn_username,
  $rhn_password = $mrepo::params::rhn_password,
  $mailto       = $mrepo::params::mailto,
  $http_proxy   = $mrepo::params::http_proxy,
  $https_proxy  = $mrepo::params::https_proxy,
) inherits mrepo::params {

  case $source {
    git: {
      vcsrepo { "/usr/src/mrepo":
        ensure    => latest,
        revision  => 'HEAD',
        provider  => "git",
        source    => "${git_proto}://github.com/dagwieers/mrepo.git",
      }

      exec { "Install mrepo from source":
        refreshonly => true,
        path        => "/usr/bin:/usr/sbin:/sbin:/bin",
        cwd         => "/usr/src/mrepo",
        refresh     => "make install",
        subscribe   => Vcsrepo["/usr/src/mrepo"],
        logoutput => on_failure,
      }
    }
    package: {
      package { "mrepo":
        ensure  => present,
      }
    }
  }


  file { "/etc/mrepo.conf":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => template("mrepo/mrepo.conf.erb"),
  }

  file {
    "/etc/mrepo.conf.d":
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0755';
    "/var/cache/mrepo":
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0755';
    $src_root:
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0755';
    "/var/log/mrepo.log":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0640';
  }

  # Packages needed to mirror files and generate mirror metadata
  package { ['lftp', 'createrepo']:
    ensure  => present,
  }
}
