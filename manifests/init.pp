
class ruby (

  $package                   = $ruby::params::os_ruby_package,
  $ensure                    = $ruby::params::ruby_ensure,
  $rubygems_package          = $ruby::params::os_rubygems_package,
  $rubygems_ensure           = $ruby::params::rubygems_ensure,
  $ruby_git_package          = $ruby::params::os_ruby_git_package,
  $ruby_gems                 = $ruby::params::ruby_gems,
  $gem_home                  = $ruby::params::os_gem_home,
  $gem_path                  = $ruby::params::os_gem_path,
  $vagrant_environment       = $ruby::params::os_vagrant_environment,
  $ruby_environment          = $ruby::params::os_ruby_environment,
  $ruby_environment_template = $ruby::params::os_ruby_environment_template,

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

  if defined(Class['git']) and $ruby_git_package {
    package { 'ruby-git':
      name     => $ruby_git_package,
      ensure   => $rubygems_ensure,
      require  => Package['rubygems'],
    }
  }

  if ! empty($ruby_gems) {
    package { $ruby_gems:
      ensure   => $rubygems_ensure,
      provider => 'gem',
      require  => Package['rubygems'],
    }
  }

  #-----------------------------------------------------------------------------
  # Configuration

  $gem_full_path = flatten([ $gem_home, $gem_path ])

  if $ruby_environment {
    file { 'ruby-environment':
      path    => $ruby_environment,
      require => Package['rubygems'],
      content => template($ruby_environment_template),
    }
  }

  #-----------------------------------------------------------------------------

  File['vagrant-environment'] -> Package['ruby']
}
