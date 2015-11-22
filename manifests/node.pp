# Class: gridengine::node
#
# This class installs the SGE node
#
class gridengine::node (
  $cluster_name = $gridengine::cluster_name,
  $qmaster_host = $gridengine::qmaster_host,
  $admin_mail   = $gridengine::admin_mail,
) inherits gridengine {
  package { 'gridengine-execd':
    ensure => present,
  }
  package { 'sge-scripts-crongi':
    ensure   => present,
  }
  file { '/opt/sge/util/install_modules/inst_common.sh':
    require => Package['gridengine'],
    source  => 'puppet:///modules/gridengine/execd-inst_common.sh',
    owner   => root,
    group   => root,
    mode    => '0755',
  }    
  file { '/opt/sge/default':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0755',
    ensure  => 'directory',
    require => Package['gridengine-execd'],
  }
  file { '/opt/sge/default/common':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0755',
    ensure  => 'directory',
    require => File['/opt/sge/default'],
  }
  file { '/opt/sge/default/common/act_qmaster':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0644',
    require => File['/opt/sge/default/common'],
    content  => template('gridengine/act_qmaster.erb'),
  }
  file { '/opt/sge/default/common/cluster_name':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0644',
    require => File['/opt/sge/default/common'],
    content  => template('gridengine/cluster_name.erb'),
  }
  file { '/opt/sge/default/common/bootstrap':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0644',
    require => File['/opt/sge/default/common'],
    source  => 'puppet:///modules/gridengine/bootstrap',
  }
  file { '/opt/sge/default/common/settings.sh':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0644',
    require => File['/opt/sge/default/common'],
    content  => template('gridengine/settings.sh.erb'),
  }
  file { '/opt/sge/default/common/settings.csh':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0644',
    require => File['/opt/sge/default/common'],
    content  => template('gridengine/settings.csh.erb'),
  }
  file { '/opt/sge/default/common/sgeexecd':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0755',
    require => File['/opt/sge/default/common'],
    content  => template('gridengine/sgeexecd.erb'),
  }
  file { '/opt/sge/default/common/sgemaster':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0755',
    require => File['/opt/sge/default/common'],
    content  => template('gridengine/sgemaster.erb'),
  }

  file { '/opt/sge/default/common/configuration':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0644',
    require => File['/opt/sge/default/common'],
    content  => template('gridengine/configuration.erb'),
  }
  file { '/opt/sge/default/common/sge_aliases':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0644',
    require => File['/opt/sge/default/common'],
    source  => 'puppet:///modules/gridengine/sge_aliases',
  }
  file { '/opt/sge/default/common/sge_request':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0644',
    require => File['/opt/sge/default/common'],
    source  => 'puppet:///modules/gridengine/sge_request',
  }
  file { '/opt/sge/default/common/qtask':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0644',
    require => File['/opt/sge/default/common'],
    source  => 'puppet:///modules/gridengine/qtask',
  }
  file { '/opt/sge/default/common/sched_configuration':
    owner   => 'sgeadmin',
    group   => 'sgeadmin',
    mode    => '0644',
    require => File['/opt/sge/default/common'],
    source  => 'puppet:///modules/gridengine/sched_configuration',
  }

  exec { 'install_sge_execd':
    command => '/opt/sge/inst_sge -x -noremote -auto /opt/sge/sge_install_template.conf',
    cwd     => '/opt/sge',
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    creates => "/etc/init.d/sgeexecd.$cluster_name",
    require => [ File['/opt/sge/sge_install_template.conf'], File['/opt/sge/default/common/act_qmaster'], File['/opt/sge/default/common/cluster_name'], File['/opt/sge/default/common/bootstrap'], File['/opt/sge/default/common/settings.sh'], File['/opt/sge/default/common/settings.csh'], File['/opt/sge/default/common/sgeexecd'], File['/opt/sge/default/common/sgemaster'], File['/opt/sge/default/common/configuration'], File['/opt/sge/default/common/sge_aliases'], File['/opt/sge/default/common/sge_request'], File['/opt/sge/default/common/qtask'], File['/opt/sge/default/common/sched_configuration'] ],
  }
  service { "sgeexecd.$cluster_name":
    enable    => true,
#    ensure    => running,
    provider  => redhat,
    hasstatus => false,
    require   => Exec['install_sge_execd'],
  }

  file { '/etc/profile.d/gridengine.sh':
    ensure  => 'link',
    target  => '/opt/sge/default/common/settings.sh',
    require => File['/opt/sge/default/common/settings.sh'],
  }
  file { '/etc/profile.d/gridengine.csh':
    ensure  => 'link',
    target  => '/opt/sge/default/common/settings.csh',
    require => File['/opt/sge/default/common/settings.csh'],
  }
}
