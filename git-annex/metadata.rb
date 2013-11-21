name             "git-annex"
maintainer       "Maciej Pasternacki"
maintainer_email "maciej@3ofcoins.net"
license          'MIT'
description      "Installs git-annex"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.3'

depends 'apt'
depends 'dmg'

supports 'debian'
supports 'mac_os_x'
supports 'ubuntu'
