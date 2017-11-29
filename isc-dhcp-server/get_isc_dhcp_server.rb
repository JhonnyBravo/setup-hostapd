# get_isc_dhcp_server.rb
# /etc/default/isc-dhcp-server -> ~/Templates/isc-dhcp-server/isc-dhcp-server.erb

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
SRC="/etc/default/"
DST="/home/#{USER_NAME}/Templates/isc-dhcp-server/"

directory DST do
  action :create
  owner USER_NAME
  group USER_NAME
end

template "#{DST}isc-dhcp-server.erb" do
  action :create
  mode "644"
  owner USER_NAME
  group USER_NAME
  source "#{SRC}isc-dhcp-server"
end
