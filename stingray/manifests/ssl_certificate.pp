# == Define: ssl_certificate
#
# Import an SSL Certificate to the Stingray Traffic Manager catalog.
#
# === Parameters
#
# [*name*]
# The name to give the SSL Certificate being imported to the catalog.
#
# [*certificate_file*]
# Path to the PEM encoded certificate file
#
# [*private_key_file*]
# Path to the PEM encoded private key file. The Private key must not
# be encrypted. You can use openssl to unencrypt the key:
#
#   openssl rsa -in key.private
#
# === Examples
#
#  stingray::ssl_certificate { 'My SSL Certificate':
#      certificate_file => 'puppet:///modules/stingray/cert.public',
#      private_key_file => 'puppet:///modules/stingray/cert.private'
#  }
#
# === Authors
#
# Faisal Memon <fmemon@riverbed.com>
# Erik Redding <erik.redding@rackspace.com>
#
# === Copyright
#
# Copyright 2013 Riverbed Technology
#
define stingray::ssl_certificate(
    $certificate_file = '',
    $private_key_file = ''
) {
    include stingray
    include stingray::ssl_server_keys_config

    $path = $stingray::install_dir
    $keyname = $name
    info ("Configuring SSL certificate ${keyname}")
    info ("${path}/zxtm/conf/ssl/server_keys/${keyname}.public")

    file { "${path}/zxtm/conf/ssl/server_keys/${keyname}.public":
        ensure => 'present',
        source => $certificate_file
    }
    info ("${path}/zxtm/conf/ssl/server_keys/${keyname}.private")
    file { "${path}/zxtm/conf/ssl/server_keys/${keyname}.private":
        ensure => 'present',
        source => $private_key_file
    }
    file_line { "public key ${keyname}":
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${keyname}!public  %zeushome%/zxtm/conf/ssl/server_keys/${keyname}.public",
        require => File["server_keys_config"],
        notify => Exec['replicate_config']
    }

    file_line { "private key ${keyname}":
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${keyname}!private  %zeushome%/zxtm/conf/ssl/server_keys/${keyname}.private",
        require => File["server_keys_config"],
        notify => Exec['replicate_config']
    }

    file_line { "managed ${keyname}":
        ensure  => present,
        path    => "${path}/zxtm/conf/ssl/server_keys_config",
        line    => "${keyname}!managed  yes",
        require => File["server_keys_config"],
        notify => Exec['replicate_config']
    }
}
