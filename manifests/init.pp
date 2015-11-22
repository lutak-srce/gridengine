# Class: gridengine
#
# This class includes the common components for SGE installations
#
# Parameters:
#
# Actions:
#
# Sample Usage:
#   include gridengine
#
class gridengine (
  $cluster_name = 'default',
  $jmx_port = 538,
  $jvm_lib_path = '/usr/lib/jvm/java/jre/lib/amd64/server/libjvm.so',
  $qmaster_host = 'localhost',
  $default_domain = 'none',
  $admin_mail = 'root',
  $nodes,
) {
  package { 'gridengine':
    ensure => present,
  }
  file { '/opt/sge/sge_install_template.conf':
    require => Package['gridengine'],
    content  => template('gridengine/sge_install_template.conf.erb'),
  }
}
