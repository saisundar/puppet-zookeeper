# Class: zookeeper
#
# This module manages zookeeper
#
# Parameters:
#   user
#   group
#   log_dir
#
# Requires:
#   N/A
# Sample Usage:
#
#   class { 'zookeeper': }
#
class zookeeper(
  $id          = '1',
  $datastore   = '/var/lib/zookeeper',
  $client_port = 2181,
  $log_dir     = '/var/log/zookeeper',
  $cfg_dir     = '/etc/zookeeper/conf',
  $user        = 'zookeeper',
  $group       = 'zookeeper',
  $java_bin    = '/usr/bin/java',
  $java_opts   = '',
  $pid_dir     = '/var/run/zookeeper',
  $pid_file    = '$PIDDIR/zookeeper.pid',
  $zoo_main    = 'org.apache.zookeeper.server.quorum.QuorumPeerMain',
  $log4j_prop  = 'INFO,ROLLINGFILE',
  $cleanup_sh  = '/usr/share/zookeeper/bin/zkCleanup.sh',
  $servers     = [''],
  $ensure      = present,
  $snap_count  = 10000,
  # since zookeeper 3.4, for earlier version cron task might be used
  $snap_retain_count = 3,
  # interval in hours, purging enabled when >= 1
  $purge_interval   = 0,
  # log4j properties
  $log4j_file   = undef,
  $rollingfile_threshold = 'ERROR',
  $tracefile_threshold    = 'TRACE',
  $max_allowed_connections = 10,
  $tick_time = 2000,
  $init_limit = 10,
  $sync_limit = 5,
) {

  anchor { 'zookeeper::start': }->
  class { 'zookeeper::install':
    ensure            => $ensure,
    snap_retain_count => $snap_retain_count,
    datastore         => $datastore,
    user              => $user,
    cleanup_sh        => $cleanup_sh,
  }->
  class { 'zookeeper::config':
    id                      => $id,
    datastore               => $datastore,
    client_port             => $client_port,
    log_dir                 => $log_dir,
    cfg_dir                 => $cfg_dir,
    user                    => $user,
    group                   => $group,
    java_bin                => $java_bin,
    java_opts               => $java_opts,
    pid_dir                 => $pid_dir,
    zoo_main                => $zoo_main,
    log4j_prop              => $log4j_prop,
    servers                 => $servers,
    snap_count              => $snap_count,
    snap_retain_count       => $snap_retain_count,
    purge_interval          => $purge_interval,
    rollingfile_threshold   => $rollingfile_threshold,
    tracefile_threshold     => $tracefile_threshold,
    max_allowed_connections => $max_allowed_connections,
    tick_time               => $tick_time,
    init_limit              => $init_limit,
    sync_limit              => $sync_limit,
    log4j_file              => $log4j_file,
  }->
  class { 'zookeeper::service':
    cfg_dir => $cfg_dir,
  }
  ->
  anchor { 'zookeeper::end': }

}
