# set_interfaces.rb
# ~/Templates/network/interfaces.erb -> /etc/network/interfaces

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
DST="/etc/network/"
SRC="/home/#{USER_NAME}/Templates/network/"

template "#{DST}interfaces" do
  action :create
  mode "644"
  source "#{SRC}interfaces.erb"
end
