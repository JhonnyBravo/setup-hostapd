# hostapd.conf
template "/etc/hostapd/hostapd.conf" do
  action :create
  mode "644"
  source "templates/hostapd.conf.erb"
end

# hostapd
template "/etc/default/hostapd" do
  action :create
  mode "644"
  source "templates/hostapd.erb"
end

# dhcpd.conf
template "/etc/dhcp/dhcpd.conf" do
  action :create
  mode "644"
  source "templates/dhcpd.conf.erb"
end

# isc-dhcp-server
template "/etc/default/isc-dhcp-server" do
  action :create
  mode "644"
  source "templates/isc-dhcp-server.erb"
end

# sysctl.conf
template "/etc/sysctl.conf" do
  action :create
  mode "644"
  source "templates/sysctl.conf.erb"
end

# dhcpcd.conf
template "/etc/dhcpcd.conf" do
  action :create
  mode "644"
  source "templates/dhcpcd.conf.erb"
end

# interfaces
template "/etc/network/interfaces" do
  action :create
  mode "644"
  source "templates/interfaces.erb"
end
