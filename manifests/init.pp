
class ruby (

  $package                   = $ruby::params::package,
  $ensure                    = $ruby::params::ensure,
  $rubygems_package          = $ruby::params::rubygems_package,
  $rubygems_ensure           = $ruby::params::rubygems_ensure,
  $git_package               = $ruby::params::git_package,
  $gems                      = $ruby::params::gems,
  $gem_home                  = $ruby::params::gem_home,
  $gem_path                  = $ruby::params::gem_path,
  $vagrant_environment       = $ruby::params::vagrant_environment,
  $environment               = $ruby::params::environment,
  $environment_template      = $ruby::params::environment_template,

) inherits ruby::params {

  #-----------------------------------------------------------------------------
  # Installation

  if $vagrant_environment {
    file { 'vagrant-environment':
      path   => $vagrant_environment,
      ensure => 'absent',
    }
  }

  #---

  if ! ( $package and $ensure ) {
    fail('Ruby package name and version must be defined')
  }
  package { 'ruby':
    name   => $package,
    ensure => $ensure,
  }

  if ! ( $rubygems_package and $rubygems_ensure ) {
    fail('Rubygems package name and version must be defined')
  }
  package { 'rubygems':
    name    => $rubygems_package,
    ensure  => $rubygems_ensure,
    require => Package['ruby'],
  }

  #---

  if defined(Class['git']) and $git_package {
    package { 'ruby-git':
      name     => $git_package,
      ensure   => $rubygems_ensure,
      require  => [ Class['git'], Package['rubygems'] ],
    }
  }

  if ! empty($gems) {
    package { $gems:
      ensure   => $rubygems_ensure,
      provider => 'gem',
      require  => Package['rubygems'],
    }
  }

  #-----------------------------------------------------------------------------
  # Configuration

  $gem_full_path = flatten([ $gem_home, $gem_path ])

  if $environment {
    file { 'ruby-environment':
      path    => $environment,
      require => Package['rubygems'],
      content => template($environment_template),
    }
  }

  #-----------------------------------------------------------------------------

  File['vagrant-environment'] -> Package['ruby']
}
