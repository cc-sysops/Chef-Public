#
# Author:: Steven Craig <support@smashrun.com>
# Cookbook Name:: cerberus
# Definition:: sentry_json
#
# Copyright 2013, Smashrun, Inc.
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
define :sentry_json, :variables => {}, :config_subdir => true do

  conf_dir = params[:jsondir] ? node['firewall']['jsonconf'] : node['firewall']['jsonconf']

  template "#{conf_dir}/#{params[:name]}.json" do
    source "advancedfw.json.erb"
    variables params[:variables]
    notifies :create, "ruby_block[apply-#{params[:name]}.json]", :delayed
    backup 5
  end
end