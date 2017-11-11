%w(hostapd iw isc-dhcp-server haveged).each do |pkg|
  package pkg do
    action :install
  end
end
