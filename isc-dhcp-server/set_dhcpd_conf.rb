# set_dhcpd_conf.rb
# ~/Templates/isc-dhcp-server/dhcpd.conf.erb -> /etc/dhcp/dhcpd.conf

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
DST="/etc/dhcp/"
SRC="/home/#{USER_NAME}/Templates/isc-dhcp-server/"

template "#{DST}dhcpd.conf" do
  action :create
  mode "644"
  source "#{SRC}dhcpd.conf.erb"
end
