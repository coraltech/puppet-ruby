
class ruby::params inherits ruby::default {

  $package              = module_param('package')
  $ensure               = module_param('ensure')
  $rubygems_package     = module_param('rubygems_package')
  $rubygems_ensure      = module_param('rubygems_ensure')
  $git_package          = module_param('git_package')

  $gems                 = module_param('gems')

  $vagrant_environment  = module_param('vagrant_environment')
  $environment          = module_param('environment')

  $environment_template = module_param('environment_template')

  $gem_home             = module_param('gem_home')
  $gem_path             = module_param('gem_path')
}
