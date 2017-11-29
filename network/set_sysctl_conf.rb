# set_sysctl_conf.rb
# ~/Templates/network/sysctl.conf.erb -> /etc/sysctl.conf

require 'dotenv'
Dotenv.load

USER_NAME=ENV["USER_NAME"]
DST="/etc/"
SRC="/home/#{USER_NAME}/Templates/network/"

template "#{DST}sysctl.conf" do
  action :create
  mode "644"
  source "#{SRC}sysctl.conf.erb"
end
