# Class: gridengine::pe::gpu
#
# This class installs scripts for GPU PE
#
class gridengine::pe::gpu {
  include gridengine

  file { '/opt/sge/gpu/':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['gridengine'],
  }
  file { '/opt/sge/gpu/var':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '1777',
    require => File['/opt/sge/gpu/'],
  }    
  file { '/opt/sge/gpu/start_gpu.sh':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    ensure  => 'directory',
    require => File['/opt/sge/gpu'],
    source  => 'puppet:///modules/gridengine/start_gpu.sh',
  }
  file { '/opt/sge/gpu/stop_gpu.sh':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    ensure  => 'directory',
    require => File['/opt/sge/gpu'],
    source  => 'puppet:///modules/gridengine/stop_gpu.sh',
  }
}
