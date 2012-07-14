
class ruby (

  $ruby_package_version     = $ruby::params::ruby_package_version,
  $rubygems_package_version = $ruby::params::rubygems_package_version,
  $ruby_gems                = $ruby::params::ruby_gems,
  $gem_home                 = $ruby::params::gem_home,
  $gem_path                 = [],

) inherits ruby::params {

  $vagrant_environment      = $ruby::params::vagrant_environment
  $ruby_environment         = $ruby::params::ruby_environment

  $ruby_package_name        = $ruby::params::ruby_package_name
  $rubygems_package_name    = $ruby::params::rubygems_package_name

  #-----------------------------------------------------------------------------
  # Installation

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
  # Configuration

  $gem_full_path = flatten([ $ruby::params::gem_home, $gem_path ])

  if $ruby_environment {
    file { 'ruby_environment':
      path    => $ruby_environment,
      ensure  => 'present',
      require => Package['rubygems'],
      content => template('ruby/ruby.sh.erb'),
    }
  }

  #-----------------------------------------------------------------------------

  File['vagrant_environment'] -> Package['ruby']
}
