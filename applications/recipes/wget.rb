include_recipe "applications::default"

package "wget" do
  action [:install, :upgrade]
end
