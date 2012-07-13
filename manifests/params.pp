
class ruby::params {

  #-----------------------------------------------------------------------------

  $ruby_gems = []

  case $::operatingsystem {
    debian, ubuntu: {
      $vagrant_environment      = '/etc/profile.d/vagrant_ruby.sh'
      $ruby_environment         = '/etc/profile.d/ruby.sh'

      $ruby_package_name        = 'ruby'
      $ruby_package_version     = '4.8'

      $rubygems_package_name    = 'rubygems'
      $rubygems_package_version = '1.8.15-1'

      $gem_home                 = '/var/lib/gems/1.8'
    }
    redhat, centos: {}
  }
}
