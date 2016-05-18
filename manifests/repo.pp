# Define yum::repo
#
# Used to install an individual repo and prevent it from being purged
#
#
define yum::repo (
  $enabled        = 1,
  $gpg_source     = undef,
  $baseurl        = undef,
  $descr          = undef,
  $exclude        = undef,
  $gpgcheck       = undef,
  $gpgkey         = undef,
  $mirrorlist     = undef,
  $failovermethod = undef,
  $priority       = undef,
) {

  if !$baseurl and !$mirrorlist {
    fail("yum::repo::${name} Either baseurl or mirrorlist is required")
  }

  include ::yum
  $purge = $::yum::purge

  if $purge {
    file { "/etc/yum.repos.d/${name}.repo": }
  }

  yumrepo { $name:
    enabled        => $enabled,
    baseurl        => $baseurl,
    descr          => $descr,
    exclude        => $exclude,
    gpgcheck       => $gpgcheck,
    gpgkey         => $gpgkey,
    mirrorlist     => $mirrorlist,
    failovermethod => $failovermethod,
  }

  if $gpg_source and $gpg_source =~ /^puppet:/ {
    file { "/etc/pki/rpm-gpg/${name}-GPG-KEY":
      ensure => file,
      owner  => 'root',
      group  => 'root',
      source => $gpg_source,
    }
  }
}
