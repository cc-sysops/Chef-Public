Description
===========

Basic functionality for writing cookbooks that manage services in a
[Cloud Foundry](http://www.cloudfoundry.org) installation. This cookbook also
installs a few management tools that work with all the services.

Requirements
============

Cookbooks
---------

* cloudfoundry
* logrotate
* rbenv

Platform
--------

* Ubuntu

Tested on:

* Ubuntu 10.04
* Ubuntu 12.04

Attributes
==========

This cookbooks defines common attributes that are used by its own recipes and
resources, as well as by the actual services cookbooks.

The following attributes are user-configurable:

default
-------

* `node['cloudfoundry_service']['install_path']` - The directory where sources
  for each service will be installed. Defaults to `/srv/cloudfoundry/services`.
* `node['cloudfoundry_service']['repo']` - The URL to a git repository
  containing the sources for all the services. If you wish to make changes to
  the source code, you can fork this repository and change this attribute to
  point to your own fork. Defaults to
  `https://github.com/cloudfoundry/vcap-services.git`.
* `node['cloudfoundry_service']['reference']` - A reference to a commit (the
  SHA1 or a branch name) to deploy. Defaults to the latest version that has
  been tested by the maintainers.
* `node['cloudfoundry_service']['base_dir']` - Path to the directory used by
  services to store private data. Defaults to `/var/vcap/services`.
* `node['cloudfoundry_service']['lock_dir']` - Path to the directory used by
  services to store locks. Defaults to `/var/vcap/sys`.
* `node['cloudfoundry_service']['ruby_version']` - Version of ruby to use by
  default for running services. Defaults to `1.9.3-p362`.

tools
-----

* `node['cloudfoundry_service']['tools']['install_path']` - The directory where
  sources for the service tools will be installed. Defaults to
  `/srv/cloudfoundry/services/tools`.
* `node['cloudfoundry_service']['tools']['ruby_version']` - Version of ruby to
  use for running service tools. Defaults to `1.9.3-p362`.
* `node['cloudfoundry_service']['tools']['install']` - A list of service tools
  that should be installed. Defaults to `['backup/manager']`.

Resources/Providers
===================

cloudfoundry\_service\_component
--------------------------------

Manages the installation, configuration and execution of a component of a CloudFoundry service.

Most services have different components: pretty much all of them have a `gateway`, most have a `node`
and some will have additional lifecycle components.

By default, it uses the `cloudfoundry_service_install` resource to install the service from git;
see its documentation (below) for more information. It is possible to opt-out and handle the
installation with other means by setting the `install` attribute to false.

# Actions:

* `:create` - installs and configures the given service component;
* `:enable` - configures the given service component to start automatically at boot;
* `:start` - starts the given service component;
* `:restart` - restarts the given service component.

# Attribute parameters

- `name`: name attribute. The name of the service component. This will be used to derive the default value for other attribute;
- `service_name`: the name of the service, e.g. `mongodb` for the MongoDB service;
- `install`: if false, the service component will not be installed automatically; it will need to be installed explicitly. Defaults to true.
- `config_dir`: path to a directory that will contain the configuration files for the service component; it will be created if it does not exist. Defaults to `node['cloudfoundry']['config_dir']`;
- `data_dir`: path to a directory that will runtime data for the service component; it will be created if it does not exist. Defaults to `File.join(node['cloudfoundry_service']['base_dir'], service_name)`;
- `user`: the user that will own the installed files. Defaults to `node['cloudfoundry']['user']`;
- `pid_dir`: path to a directory that will hold pid files for the service. Defaults to `node['cloudfoundry']['pid_dir']`;
- `pid_dir`: path to a directory that will hold log files for the service. Defaults to `node['cloudfoundry']['log_dir']`;
- `lock_dir`: path to a directory that will hold lock files for the service. Defaults to `node['cloudfoundry_service']['lock_dir']`;
- `init_service_name`: the name of the `init` (Upstart) service that will be created. Defaults to `#{cloudfoundry}_name`;
- `base_path`: path to a directory that will contain the installation of all the services; if `install` is specifiied, it will be created if it does not exist. Defaults to `node['cloudfoundry_service']['install_path']}`;
- `subdirectory`: name of a subdirectory of `base_path` that will contain the installation of this services; if `install` is specifiied, it will be created if it does not exist. Defaults to `name`;
- `extra_args`: extra arguments to add to the service component invokation.

Examples:

    cloudfoundry_service_component "mysql_node" do
      service_name  "mysql"
    end

    cloudfoundry_service_component "mysql_gateway" do
      service_name  "mysql"
    end

cloudfoundry\_service\_install
------------------------------

Manages the installation of a CloudFoundry service.

At the time of this writing, services are distributed only in source form as part of the
`vcap-services` git repository; this resource checks out the git repository only once regardless
of the number of services that are installed.

When the content of the repository changes, it will automatically perform any task that is
required to updated all the services running on a node. In particular, it will restart every
service that is installed from that repository, since there is no way of detecting changes in a
single service.

Conversely, if the content of the repository did not change, Bundler will not be run and no
service will be restarted unless the directories created by Bundler don't exist.
In other words, if you make other changes (deinstall a gem, or make manual changes) you need to
either run `bundle` manually or delete the `#{path}/bundle` directory.

Warning: the current version of this resource strongly assumes this particular layout; as a
consequence, installing different services to unrelated directories is not supported at this time.

# Actions:

* `:update` - updates the installation of the given service.

# Attribute parameters

- `name`: name attribute. The name of the service you wish to install. This will be used to derive the default value for other attribute;
- `base_path`: path to a directory that will contain the installation of all the services; it will be created if it does not exist. Defaults to `node['cloudfoundry_service']['install_path']`;
- `subdirectory`: name of a subdirectory of `base_path` that will contain the installation of this services; it will be created if it does not exist. Defaults to `name`;
- `path`: path to a directory that will contain the installation of this services; it will be created if it does not exist. Note: at this time it *must* be a subdirectory of `base_path`; Defaults to `#{base_path}/#{subdirectory}`;
- `user`: the user that will own the installed files. Defaults to `node['cloudfoundry']['user']`;
- `repository`: the URL to a git repository containing the sources for all the services. Defaults to `node['cloudfoundry_service']['repo']`;
- `reference`: a reference to a commit (the SHA1 or a branch name) to deploy. Defaults to `node['cloudfoundry_service']['reference']`;
- `enable_submodules`: if true, any submodules for the repository will by updated as well. This must be true when using the default repository; only change if you know what you are doing. Defaults to `true`;
- `depth`: if not nil, it will limit the depth of the git checkout to the given value; this may speed up the deployment. Defaults to `10`;
- `ruby_version`: the version of Ruby that will be used to run Bundler. Defaults to `node['cloudfoundry']['ruby_version']`;
- `ruby_path`: the path to a Ruby interpreter that will be used to run Bundler. Defaults to the `rbenv` installation of Ruby version `node['cloudfoundry']['ruby_version']`.

Usage
=====

Install service tools:

    run_list: "recipe[cloudfoundry_service::tools]"

License and Author
==================

Author:: Andrea Campi (<andrea.campi@zephirworks.om.com>)
Author:: Trotter Cashion (<cashion@gmail.com>)

Copyright:: 2012-2013 ZephirWorks
Copyright:: 2012 Trotter Cashion

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
