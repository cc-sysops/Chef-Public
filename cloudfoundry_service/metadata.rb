name             "cloudfoundry_service"
maintainer       "Andrea Campi"
maintainer_email "andrea.campi@zephirworks.com"
license          "Apache 2.0"
description      "Base cookbook for cloudfoundry service cookbooks"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.2.3"

%w{ ubuntu }.each do |os|
  supports os
end

%w{ logrotate rbenv }.each do |cb|
  depends cb
end

depends "cloudfoundry", "~> 1.3.0"
