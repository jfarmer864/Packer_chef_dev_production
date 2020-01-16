#
# Cookbook:: python_cookbook
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
apt_update "update" do
  action :update
end

package "python3-dev" do
  action :install
end

package "python3-pip" do
  action :install
end

directory "/home/ubuntu/require" do
  action :create
end

cookbook_file '/home/ubuntu/require/requirements.txt' do
  source 'app/requirements.txt'
  action :create
end

execute 'pip install requirements' do
  command 'pip3 install -r /home/ubuntu/app/requirements.txt'
end

directory "/home/vagrant/Downloads" do
  action :create
end

file '/home/vagrant/Downloads/ItJobsWatchTop30.csv' do
  action :create
  mode '777'
end
