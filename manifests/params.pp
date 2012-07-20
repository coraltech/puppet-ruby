
class ruby::params {

  include ruby::default

  #-----------------------------------------------------------------------------
  # General configurations

  if $::hiera_ready {
    $ruby_ensure     = hiera('ruby_ensure', $ruby::default::ruby_ensure)
    $rubygems_ensure = hiera('ruby_rubygems_ensure', $ruby::default::rubygems_ensure)
    $ruby_gems       = hiera('ruby_gems', $ruby::default::ruby_gems)
  }
  else {
    $ruby_ensure     = $ruby::default::ruby_ensure
    $rubygems_ensure = $ruby::default::rubygems_ensure
    $ruby_gems       = $ruby::default::ruby_gems
  }

  #-----------------------------------------------------------------------------
  # Operating system specific configurations

  case $::operatingsystem {
    debian, ubuntu: {
      $os_ruby_package              = 'ruby'
      $os_rubygems_package          = 'rubygems'

      $os_vagrant_environment       = '/etc/profile.d/vagrant_ruby.sh'
      $os_ruby_environment          = '/etc/profile.d/ruby.sh'

      $os_ruby_environment_template = 'ruby/ruby.sh.erb'

      $os_gem_home                  = '/var/lib/gems/1.8'
      $os_gem_path                  = []
    }
    default: {
      fail("The ruby module is not currently supported on ${::operatingsystem}")
    }
  }
}
