# /etc/hostapd/hostapd.conf
include_recipe "hostapd/get_hostapd_conf.rb"

# /etc/default/hostapd
include_recipe "hostapd/get_hostapd.rb"

# /etc/dhcp/dhcpd.conf
include_recipe "isc-dhcp-server/get_dhcpd_conf.rb"

# /etc/default/isc-dhcp-server
include_recipe "isc-dhcp-server/get_isc_dhcp_server.rb"

# /etc/sysctl.conf
include_recipe "network/get_sysctl_conf.rb"

# /etc/dhcpcd.conf
include_recipe "network/get_dhcpcd_conf.rb"

# /etc/network/interfaces
include_recipe "network/get_interfaces.rb"
