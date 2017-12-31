# get_dhcpcd_conf.rb
# /etc/dhcpcd.conf -> ~/Templates/dhcpcd/dhcpcd.conf.erb

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
SRC="/etc/"
DST="/home/#{USER_NAME}/Templates/dhcpcd/"

directory DST do
  action :create
  user USER_NAME
  owner USER_NAME
  group USER_NAME
end

template "#{DST}dhcpcd.conf.erb" do
  action :create
  mode "644"
  user USER_NAME
  owner USER_NAME
  group USER_NAME
  source "#{SRC}dhcpcd.conf"
end
