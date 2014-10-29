# == Define: mrepo::iso
#
# Downloads isos
#
# NOTE: Resource name should be the filename to download.
#
# === Parameters
#
# [*source_root*]
#   Directory root of package.  Used to construct location of ISO.
#   ex. $target_file = "${src_root}/iso/${name}"
#
# [*source_url*]
#   URL path to ISO file sand filename.  Type uses resource name for
#   filename.
#
# [*repo*]
#   Repo this ISO is need by.
#
define mrepo::iso(
  $source_root,
  $source_url,
  $repo,
) {
  $target_file = "${source_root}/iso/${name}"

  staging::file { $name:
    source => "${source_url}/${name}",
    target => $target_file,
    before => Mrepo::Repo[$repo],
  }
}
