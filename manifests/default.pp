
class ruby::default {

  $ensure          = 'present'
  $rubygems_ensure = 'present'

  $gems            = []

  #---

  case $::operatingsystem {
    debian, ubuntu: {
      $package                   = 'ruby'
      $rubygems_package          = 'rubygems'
      $git_package               = 'ruby-git'

      $vagrant_environment       = '/etc/profile.d/vagrant_ruby.sh'
      $environment               = '/etc/profile.d/ruby.sh'

      $environment_template      = 'ruby/ruby.sh.erb'

      $gem_home                  = '/var/lib/gems/1.8'
      $gem_path                  = []
    }
    default: {
      fail("The ruby module is not currently supported on ${::operatingsystem}")
    }
  }
}
