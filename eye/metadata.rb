name             'eye'
maintainer       'Holger Amann'
maintainer_email 'holger@fehu.org'
license          'Apache 2.0'
description      'Installs eye gem and configures it to manage services, includes eye_service LWRP'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'
recipe "eye::default", "Installs eye rubygem"
