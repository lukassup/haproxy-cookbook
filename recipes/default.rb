#
# Cookbook:: haproxy
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'chef-vault'

haproxy_service = node['haproxy'][:service]

package node['haproxy'][:package] do
  notifies :reload, "service[#{haproxy_service}]", :delayed
end

file node['haproxy'][:ca_cert] do
  content data_bag_item('pki', 'ca')['cert']
  notifies :reload, "service[#{haproxy_service}]", :delayed
end

file node['haproxy'][:key] do
  content chef_vault_item('pki', "#{node.name}-vault")['haproxy']
  notifies :reload, "service[#{haproxy_service}]", :delayed
end

template node['haproxy'][:config] do
  source 'haproxy.cfg.erb'
  variables ({
    backend_hosts: search(:node, 'role:web'),
    ca_cert: node['haproxy'][:ca_cert],
    key: node['haproxy'][:key],
  })
  notifies :reload, "service[#{haproxy_service}]", :delayed
end

service haproxy_service do
  action [:enable, :start]
end
