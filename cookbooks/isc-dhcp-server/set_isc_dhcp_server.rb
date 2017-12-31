# set_isc_dhcp_server.rb
# ~/Templates/isc-dhcp-server/isc-dhcp-server.erb -> /etc/default/isc-dhcp-server

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
DST="/etc/default/"
SRC="/home/#{USER_NAME}/Templates/isc-dhcp-server/"

template "#{DST}isc-dhcp-server" do
  action :create
  mode "644"
  source "#{SRC}isc-dhcp-server.erb"
end
