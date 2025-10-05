#!/bin/bash
sudo adduser -m mwhitney
sudo passwd -d mwhitney
sudo usermod -aG wheel mwhitney

if cat /etc/redhat-release | grep "Red Hat Enterprise Linux" &> /dev/null; then
    echo "RHEL detected"
    sudo dnf update -y
else
   sudo yum update -y
fi

sudo dnf install ansible-core vim needs-restarting -y

if needs-restarting -r; then
    echo "Reboot is not required"
    
else
    echo "No reboot is required"
    sudo shutdown -r now
fi
echo "Update completed"