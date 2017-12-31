# /etc/hostapd/hostapd.conf
include_recipe "../../cookbooks/hostapd/set_hostapd_conf.rb"

# /etc/default/hostapd
include_recipe "../../cookbooks/hostapd/set_hostapd.rb"

# /etc/dhcp/dhcpd.conf
include_recipe "../../cookbooks/isc-dhcp-server/set_dhcpd_conf.rb"

# /etc/default/isc-dhcp-server
include_recipe "../../cookbooks/isc-dhcp-server/set_isc_dhcp_server.rb"

# /etc/sysctl.conf
include_recipe "../../cookbooks/sysctl/set_sysctl_conf.rb"

# /etc/dhcpcd.conf
include_recipe "../../cookbooks/dhcpcd/set_dhcpcd_conf.rb"

# /etc/network/interfaces
include_recipe "../../cookbooks/interfaces/set_interfaces.rb"
