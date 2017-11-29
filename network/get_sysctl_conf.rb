# get_sysctl_conf.rb
# /etc/sysctl.conf -> ~/Templates/network/sysctl.conf.erb

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
SRC="/etc/"
DST="/home/#{USER_NAME}/Templates/network/"

directory DST do
  action :create
  owner USER_NAME
  group USER_NAME
end

template "#{DST}sysctl.conf.erb" do
  action :create
  mode "644"
  owner USER_NAME
  group USER_NAME
  source "#{SRC}sysctl.conf"
end
