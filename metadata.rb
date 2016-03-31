name             'raven-db'
maintainer       'Sitening LLC'
maintainer_email 'phil@raventools.com'
license          'MIT'
description      'Utility cookbook for managing local (vagrant) database instances'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends "raven-deploy"
depends "raven-supervisor"
depends "yum-mysql-community"
