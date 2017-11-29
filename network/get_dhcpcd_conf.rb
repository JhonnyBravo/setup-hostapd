# get_dhcpcd_conf.rb
# /etc/dhcpcd.conf -> ~/Templates/network/dhcpcd.conf.erb

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

template "#{DST}dhcpcd.conf.erb" do
  action :create
  mode "644"
  owner USER_NAME
  group USER_NAME
  source "#{SRC}dhcpcd.conf"
end
