#!/bin/bash

# ----------------------------------------
# -- WORK IN PROGRESS
# attempt at rebuilding inventory
# after rebooted virthost.
# ----------------------------------------

virthost_ip=$(cat inventory/virthost.inventory | grep ansible_host | awk '{ print $2 }' | cut -d= -f2)

VM=kube-master-1

cat <<'EOF' > /tmp/shell.txt
arp -an | grep "`virsh dumpxml THE_VIRTUAL_MACHINE | grep "mac address" | sed "s/.*'\(.*\)'.*/\1/g"`" | awk '{ gsub(/[\(\)]/,"",$2); print $2 }'
EOF

sed -i -e "s/THE_VIRTUAL_MACHINE/$VM/" /tmp/shell.txt

MYCOMMAND=$(base64 -w0 /tmp/shell.txt)
echo $MYCOMMAND | base64 -d

# ssh user@remotehost "echo $MYCOMMAND | base64 -d | bash"

# ssh root@$virthost_ip "arp -an | grep \"`virsh dumpxml $VM | grep \"mac address\" | sed \"s/.*'\(.*\)'.*/\1/g\"`\" | awk '{ gsub(/[\(\)]/,\"\",$2); print $2 }'"

# #!/bin/bash
# # Returns the IP address of a running KVM guest VM
# # Assumes a working KVM/libvirt environment
# #
# # Install:
# #   Add this bash function to your ~/.bashrc and `source ~/.bashrc`.
# # Usage: 
# #   $ virt-addr vm-name
# #   192.0.2.16
# #
# virt-addr() {
#     VM="$1"
#     arp -an | grep "`virsh dumpxml $VM | grep "mac address" | sed "s/.*'\(.*\)'.*/\1/g"`" | awk '{ gsub(/[\(\)]/,"",$2); print $2 }'
# }