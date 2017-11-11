# templates ディレクトリの生成
directory "templates" do
  action :create
end

# hostapd.conf
execute "get-hostapd-conf" do
  not_if "test -f /etc/hostapd/hostapd.conf"
  command "zcat /usr/share/doc/hostapd/examples/hostapd.conf.gz > templates/hostapd.conf.erb"

  only_if "test -f /etc/hostapd/hostapd.conf"
  command "cp /etc/hostapd/hostapd.conf templates/hostapd.conf.erb"
end

# hostapd
template "templates/hostapd.erb" do
  action :create
  source "/etc/default/hostapd"
end

# dhcpd.conf
template "templates/dhcpd.conf.erb" do
  action :create
  source "/etc/dhcp/dhcpd.conf"
end

# isc-dhcp-server
template "templates/isc-dhcp-server.erb" do
  action :create
  source "/etc/default/isc-dhcp-server"
end

# sysctl.conf
template "templates/sysctl.conf.erb" do
  action :create
  source "/etc/sysctl.conf"
end

# dhcpcd.conf
template "templates/dhcpcd.conf.erb" do
  action :create
  source "/etc/dhcpcd.conf"
end

# interfaces
template "templates/interfaces.erb" do
  action :create
  source "/etc/network/interfaces"
end
