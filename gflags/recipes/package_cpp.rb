include_recipe "apt" if node['platform'] == "ubuntu"
include_recipe "yum::epel" if node['platform_family'] == "rhel"

node['gflags']['package']['cpp_packages'].each do |p|
  package p
end
