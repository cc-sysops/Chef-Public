#
# Author:: John E. Vincent (<lusis.org+github.com@gmail.com>)
# Cookbook Name:: noahlite
#
# Copyright (c) 2010 John E. Vincent
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
def initialize(*args)
  super
  @action = :create
end

actions :create, :delete

attribute :name, :kind_of => [String], :name_attribute => true, :required => true
attribute :tags, :kind_of => [Array]
attribute :link, :kind_of => [String]
attribute :status, :kind_of => [String], :default => "up"
attribute :timeout, :kind_of => [Integer]
attribute :retry_interval, :kind_of => [Integer]
attribute :noah_server, :kind_of => [String]
attribute :noah_port, :kind_of => [String]
