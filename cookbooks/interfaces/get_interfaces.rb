# get_interfaces.rb
# /etc/network/interfaces -> ~/Templates/interfaces/interfaces.erb

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
SRC="/etc/network/"
DST="/home/#{USER_NAME}/Templates/interfaces/"

directory DST do
  action :create
  user USER_NAME
  owner USER_NAME
  group USER_NAME
end

template "#{DST}interfaces.erb" do
  action :create
  mode "644"
  user USER_NAME
  owner USER_NAME
  group USER_NAME
  source "#{SRC}interfaces"
end
