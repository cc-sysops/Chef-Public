include_recipe "applications::default"

package "pwgen" do
  action [:install, :upgrade]
end
