# get_hostapd_conf.rb
# /etc/hostapd/hostapd.conf -> ~/Templates/hostapd/hostapd.conf.erb

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
SRC1="/etc/hostapd/"
SRC2="/usr/share/doc/hostapd/examples/"
DST="/home/#{USER_NAME}/Templates/hostapd/"

directory DST do
  action :create
  user USER_NAME
  owner USER_NAME
  group USER_NAME
end

execute "get_hostapd_conf_gz" do
  not_if "test -f #{SRC1}hostapd.conf"
  user USER_NAME
  command "zcat #{SRC2}hostapd.conf.gz > #{DST}hostapd.conf.erb"
end

execute "get_hostapd_conf" do
  only_if "test -f #{SRC1}hostapd.conf"
  user USER_NAME
  command "cat #{SRC1}hostapd.conf > #{DST}hostapd.conf.erb"
end
