# Class: stingray::ssl_server_keys_config
# This class is included by stingray::ssl_certificate.pp and is NOT to be 
#   included otherwise.  This gets around a bug found in the initial
#   puppet module provided by riverbed because of the singleton nature
#   of puppet.  
# 
# === Parameters
# 
# === Examples
#  
# === Authors
#
# Erik Redding <erik.redding@rackspace.com>
#
# === Copyright
#
# Copyright 2013 Rackspace 
class stingray::ssl_server_keys_config (){
  include stingray
  $path = $stingray::install_dir
  file { "${path}/zxtm/conf/ssl/server_keys_config":
    ensure => 'present',
    alias  => 'server_keys_config',
    require => Exec['install_stingray']
  }
}