# get_dhcpd_conf.rb
# /etc/dhcp/dhcpd.conf -> ~/Templates/isc-dhcp-server/dhcpd.conf.erb

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
SRC="/etc/dhcp/"
DST="/home/#{USER_NAME}/Templates/isc-dhcp-server/"

directory DST do
  action :create
  user USER_NAME
  owner USER_NAME
  group USER_NAME
end

template "#{DST}dhcpd.conf.erb" do
  action :create
  mode "644"
  user USER_NAME
  owner USER_NAME
  group USER_NAME
  source "#{SRC}dhcpd.conf"
end
