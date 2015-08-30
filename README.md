# minecraft-pe-node
A minecraft pocket edition standalone raspberry pi 2 server

[mcrcon](http://bukkit.org/threads/admin-rcon-mcrcon-remote-connection-client-for-minecraft-servers.70910/)

## HOST AP and DHCPD
[network config](https://wiki.archlinux.org/index.php/Network_configuration#Enabling_and_disabling_network_interfaces)
[create_ap](https://github.com/oblique/create_ap)
[systemd](https://wiki.archlinux.org/index.php/Systemd#Writing_unit_files)

### Setup IP
systemctl enable create_ap


## Bluetooth
[setup](https://wiki.archlinux.org/index.php/Bluetooth#Bluetoothctl)
[evdev](http://python-evdev.readthedocs.org/en/latest/)

sudo pacman -S core/linux-api-headers python2-pip
sudo pip2 install evdev

### Other libs
* sudo pip2 install requests

Quelab Tablet
quelab.tablet.01
quelab.tablet.02
quelab.tablet.03

