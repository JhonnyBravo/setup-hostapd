# get_hostapd.rb
# /etc/default/hostapd -> ~/Templates/hostapd/hostapd.erb

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
SRC="/etc/default/"
DST="/home/#{USER_NAME}/Templates/hostapd/"

directory DST do
  action :create
  owner USER_NAME
  group USER_NAME
end

template "#{DST}hostapd.erb" do
  action :create
  mode "644"
  owner USER_NAME
  group USER_NAME
  source "#{SRC}hostapd"
end
