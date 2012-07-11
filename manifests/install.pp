
class ruby::install (

  $ruby_package_version     = $ruby::params::ruby_package_version,
  $rubygems_package_version = $ruby::params::rubygems_package_version,
  $ruby_gems                = $ruby::params::ruby_gems,

) inherits ruby::params {

  $vagrant_environment   = $ruby::params::vagrant_environment

  $ruby_package_name     = $ruby::params::ruby_package_name
  $rubygems_package_name = $ruby::params::rubygems_package_name

  #-----------------------------------------------------------------------------

  if $vagrant_environment {
    file { 'vagrant_environment':
      path   => $vagrant_environment,
      ensure => 'absent',
    }
  }

  #---

  if ! $ruby_package_name or ! $ruby_package_version {
    fail('Ruby package name and version must be defined')
  }
  package { 'ruby':
    name   => $ruby_package_name,
    ensure => $ruby_package_version,
  }

  if ! $rubygems_package_name or ! $rubygems_package_version {
    fail('Rubygems package name and version must be defined')
  }
  package { 'rubygems':
    name    => $rubygems_package_name,
    ensure  => $rubygems_package_version,
    require => Package['ruby'],
  }

  #---

  package { $ruby_gems:
    ensure   => 'present',
    provider => 'gem',
    require  => Package['rubygems'],
  }

  #-----------------------------------------------------------------------------

  File['vagrant_environment'] -> Package['ruby']
}
