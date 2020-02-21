#!/bin/bash -x
vbmg () { /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe "$@"; }
    
NET_NAME="NETMIDTERM"
VM_NAME="MIDTERM4640"
NEW_VM_NAME="A01023366"
SSH_PORT="12922"
WEB_PORT="12980"


# This function will clean the NAT network and the virtual machine
clean_all () {
	vbmg natnetwork remove --netname "$NET_NAME"
}

change_name () {
 vbmg modifyvm "$VM_NAME" --name "$NEW_VM_NAME"
}

create_network () {
    vbmg natnetwork add --netname $NET_NAME --network "192.168.10.0/24" --enable --dhcp disable --ipv6 off
    
    vbmg natnetwork modify \
        --netname $NET_NAME --port-forward-4 "ssh:tcp:[]:$SSH_PORT:[192.168.10.10]:22" \
        --port-forward-4 "http:tcp:[]:$WEB_PORT:[192.168.10.10]:80" 
}

start_vm () {

vbmg startvm "$NEW_VM_NAME"
}

echo "Starting script..."
clean_all
create_network
change_name
start_vm

echo "DONE!"

