maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Installs and configures krb5 authentication"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"
depends         "ntp"
%w( redhat centos scientific amazon ubuntu debian).each do |os|
  supports os
end
