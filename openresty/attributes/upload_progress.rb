#
# Cookbook Name:: openresty
# Attribute:: upload_progress
#
# Author:: Panagiotis Papadomitsos (<pj@ezgr.net>)
#
# Copyright 2012, Panagiotis Papadomitsos
# Based heavily on Opscode's original nginx cookbook (https://github.com/opscode-cookbooks/nginx)
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

# For more information check out https://github.com/masterzen/nginx-upload-progress-module
default['openresty']['upload_progress']['url']      = 'https://github.com/masterzen/nginx-upload-progress-module/tarball/v0.8.4'
default['openresty']['upload_progress']['checksum'] = '9a6acb984d81f5d7e04214d63ae94273'
