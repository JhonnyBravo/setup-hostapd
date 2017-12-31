# set_hostapd_conf.rb
# ~/Templates/hostapd/hostapd.conf.erb -> /etc/hostapd/hostapd.conf

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
DST="/etc/hostapd/"
SRC="/home/#{USER_NAME}/Templates/hostapd/"

template "#{DST}hostapd.conf" do
  action :create
  mode "644"
  source "#{SRC}hostapd.conf.erb"
end
