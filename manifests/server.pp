# Class: gridengine::server
#
# This class installs the SGE master
#
class gridengine::server (
  $cluster_name = $gridengine::cluster_name,
) inherits gridengine {
  package { 'gridengine-qmaster':
    ensure => present,
  }
  package { 'gridengine-qmon':
    ensure => present,
  }
  file { '/opt/sge/util/install_modules/inst_common.sh':
    require => Package['gridengine'],
    source  => 'puppet:///modules/gridengine/qmaster-inst_common.sh',
    owner   => root,
    group   => root,
    mode    => '0755',
  }
  exec { 'install_sge_qmaster':
    command => '/opt/sge/inst_sge -m -auto /opt/sge/sge_install_template.conf',
    cwd     => '/opt/sge',
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    creates => "/etc/init.d/sgemaster.$cluster_name",
    require => [ File['/opt/sge/sge_install_template.conf'], File['/opt/sge/util/install_modules/inst_common.sh'], ],
  }
  file { '/etc/profile.d/gridengine.sh':
    ensure  => 'link',
    target  => '/opt/sge/default/common/settings.sh',
    require => Exec['install_sge_qmaster'],
  }
  file { '/etc/profile.d/gridengine.csh':
    ensure  => 'link',
    target  => '/opt/sge/default/common/settings.csh',
    require => Exec['install_sge_qmaster'],
  }
}
