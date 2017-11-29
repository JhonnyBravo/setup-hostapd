# set_hostapd.rb
# ~/Templates/hostapd/hostapd.erb -> /etc/default/hostapd

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
DST="/etc/default/"
SRC="/home/#{USER_NAME}/Templates/hostapd/"

template "#{DST}hostapd" do
  action :create
  mode "644"
  source "#{SRC}hostapd.erb"
end
