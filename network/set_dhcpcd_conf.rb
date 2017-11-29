# set_dhcpcd_conf.rb
# ~/Templates/network/dhcpcd.conf.erb -> /etc/dhcpcd.conf

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
DST="/etc/"
SRC="/home/#{USER_NAME}/Templates/network/"

template "#{DST}dhcpcd.conf" do
  action :create
  mode "664"
  group "netdev"
  source "#{SRC}dhcpcd.conf.erb"
end
