maintainer       "John Dewey"
maintainer_email "john@dewey.ws"
license          "Apache 2.0"
description      "Installs/Configures mtr"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.0"

recipe           "mtr", "Installs/Configures mtr"

%w{ centos debian ubuntu }.each do |os|
  supports os
end
