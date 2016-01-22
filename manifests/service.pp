# == Class: oauth2_proxy::service
#
# This class should be considered private.
#
class oauth2_proxy::service (
  $service_template = $oauth2_proxy::params::service_template,
  $service_provider = $oauth2_proxy::params::service_provider,
) inherits oauth2_proxy::params {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file {$service_template:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/service/${service_provider}.erb"),
  } ~>
  service { 'oauth2_proxy':
    ensure => 'running',
    enable => true,
  }
}
