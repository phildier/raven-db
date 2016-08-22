name             'raven-db'
maintainer       'Sitening LLC'
maintainer_email 'phil@raventools.com'
license          'MIT'
description      'Utility cookbook for managing local (vagrant) database instances'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends "raven-deploy"
depends "raven-supervisor"

recipe "raven-db::memcached", "install and configure memcached"
recipe "raven-db::install_mysql_server", "install and configure mysql"

attribute "raven_db",
	:display_name => "Raven DB",
	:type => "hash"

attribute "raven_db/memcached_port",
	:display_name => "Memcached port",
	:description => "Memcache port",
	:required => "recommended",
	:type => "string",
	:recipes => ["raven-db::memcached"],
	:default => "11211"

attribute "raven_db/memcached_user",
	:display_name => "Memcached user",
	:description => "Memcached user",
	:required => "recommended",
	:type => "string",
	:recipes => ["raven-db::memcached"],
	:default => "memcached"

attribute "raven_db/memcached_max_conn",
	:display_name => "max connections for memcached",
	:description => "max connections for memcached",
	:required => "recommended",
	:type => "string",
	:recipes => ["raven-db::memcached"],
	:default => "4096"

attribute "raven_db/memcached_max_mem",
	:display_name => "max memory in mb memcached",
	:description => "max memory in mb memcached",
	:required => "recommended",
	:type => "string",
	:recipes => ["raven-db::memcached"],
	:default => "900"

attribute "raven_db/memcached_socket",
	:display_name => "memcached socket path",
	:description => "memcached socket path",
	:required => "recommended",
	:type => "string",
	:recipes => ["raven-db::memcached"],
	:default => ""

attribute "raven_db/root_password",
	:display_name => "mysql root password",
	:description => "password for root user",
	:required => "recommended",
	:type => "string",
	:recipes => ["raven-db::install_mysql_server"],

