#
# Cookbook Name:: bacula
# Recipe:: bat
#
# Copyright 2012, computerlyrik
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "bacula-console-qt"

n = search(:node, 'run_list:recipe\[bacula\:\:server\]').first

template "/etc/bacula/bat.conf" do
  group node['bacula']['group']
  mode 0640
  variables ({
    :bacula_dir_password=> n['bacula']['dir']['password'],
    :bacula_dir_address => n['bacula']['dir']['address']})
end