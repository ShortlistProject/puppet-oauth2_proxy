# == Class: oauth2_proxy::params
#
# This class should be considered private.
#
#
class oauth2_proxy::params {
  $upstart_service_path = '/etc/init/oauth2_proxy.conf'
  $systemd_service_path = '/usr/lib/systemd/system/oauth2_proxy.service'

  $defaults = {
    'manage_user'      => true,
    'user'             => 'oauth2',
    'manage_group'     => true,
    'group'            => 'oauth2',
    'install_root'     => '/opt/oauth2_proxy',
    'service_template' => $upstart_service_path,
    'service_provider' => 'upstart',
    'manage_service'   => true,
  }


  # in theory, this module should work on any linux distro that uses systemd
  # but it has only been tested on el7
  case $::osfamily {
    'RedHat': {
      if $::operatingsystemmajrelease == '7' {
          $overrides = {
            'service_template' => $systemd_service_path,
            'service_provider' => 'systemd',
          }
      }
    }
    'Debian': {
      $overrides = {}
    }
    default: {
      fail("Module ${module_name} is not supported on operatingsystem ${::operatingsystem}")
    }
  }

  # bit.ly does not provide x86 builds
  case $::architecture {
    'x86_64': {}
    'amd64':  {}
    default: {
      fail("Module ${module_name} is not supported on architecture ${::architecture}")
    }
  }

  $merged = merge($defaults, $overrides)

  $manage_user      = $merged['manage_user']
  $user             = $merged['user']
  $manage_group     = $merged['manage_group']
  $group            = $merged['group']
  $install_root     = $merged['install_root']
  $service_template = $merged['service_template']
  $service_provider = $merged['service_provider']
  $manage_service   = $merged['manage_service']
}
