#!/bin/bash 
##############################################################################
### Script cai dat rabbitmq
### MQ1: bash rabbitmq-install.sh mq1
### MQ1: bash rabbitmq-install.sh mq2
### MQ1: bash rabbitmq-install.sh mq3
##############################################################################

##############################################################################
### Kiem tra cu phap khi thuc hien shell 
if [ $# -ne 1 ]
    then
        echo  "Cu phap dung nhu sau "
        echo "Thuc hien tren may chu MQ1: bash $0 mq1"
        echo "Thuc hien tren may chu MQ2: bash $0 mq2"
        echo "Thuc hien tren may chu MQ3: bash $0 mq3"
        exit 1;
fi

if [ "$1" == "mq1" ]; then
    echo "Khai bao repos"
    sleep 3
    echo "proxy=http://123.30.178.220:3142" >> /etc/yum.conf 
    yum -y update

    hostnamectl set-hostname mq1

    echo "Setup IP  System ens160"
    nmcli c modify ens160 ipv4.addresses 10.10.10.21/24
    nmcli c modify ens160 ipv4.method manual
    nmcli con mod ens160 connection.autoconnect yes

    echo "Setup IP  ens224"
    nmcli c modify ens224 ipv4.addresses 192.168.20.21/24
    nmcli c modify ens224 ipv4.gateway 192.168.20.254
    nmcli c modify ens224 ipv4.dns 8.8.8.8
    nmcli c modify ens224 ipv4.method manual
    nmcli con mod ens224 connection.autoconnect yes

    sudo systemctl disable firewalld
    sudo systemctl stop firewalld
    sudo systemctl disable NetworkManager
    sudo systemctl stop NetworkManager
    sudo systemctl enable network
    sudo systemctl start network

    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

    echo "192.168.20.21 mq1" >> /etc/hosts
    echo "192.168.20.22 mq2" >> /etc/hosts
    echo "192.168.20.23 mq3" >> /etc/hosts

    echo "Khoi dong lai may chu"
    sleep 5
    init 6
    
  elif [ "$1" == "mq2" ]; then
    echo "Khai bao repos"
    sleep 3
    echo "proxy=http://123.30.178.220:3142" >> /etc/yum.conf 
    yum -y update

    hostnamectl set-hostname mq2

    echo "Setup IP  ens160"
    nmcli c modify ens160 ipv4.addresses 10.10.10.22/24
    nmcli c modify ens160 ipv4.method manual
    nmcli con mod ens160 connection.autoconnect yes

    echo "Setup IP  ens224"
    nmcli c modify ens224 ipv4.addresses 192.168.20.22/24
    nmcli c modify ens224 ipv4.gateway 192.168.20.254
    nmcli c modify ens224 ipv4.dns 8.8.8.8
    nmcli c modify ens224 ipv4.method manual
    nmcli con mod ens224 connection.autoconnect yes

    sudo systemctl disable firewalld
    sudo systemctl stop firewalld
    sudo systemctl disable NetworkManager
    sudo systemctl stop NetworkManager
    sudo systemctl enable network
    sudo systemctl start network

    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

    echo "192.168.20.21 mq1" >> /etc/hosts
    echo "192.168.20.22 mq2" >> /etc/hosts
    echo "192.168.20.23 mq3" >> /etc/hosts

    echo "Khoi dong lai may chu"
    sleep 5
    init 6
  elif [ "$1" == "mq3" ]; then
    echo "Khai bao repos"
    sleep 3
    echo "proxy=http://123.30.178.220:3142" >> /etc/yum.conf 
    yum -y update

    hostnamectl set-hostname mq3

    echo "Setup IP  System ens160"
    nmcli c modify ens160 ipv4.addresses 10.10.10.23/24
    nmcli c modify ens160 ipv4.method manual
    nmcli con mod ens160 connection.autoconnect yes

    echo "Setup IP  ens224"
    nmcli c modify ens224 ipv4.addresses 192.168.20.23/24
    nmcli c modify ens224 ipv4.gateway 192.168.20.254
    nmcli c modify ens224 ipv4.dns 8.8.8.8
    nmcli c modify ens224 ipv4.method manual
    nmcli con mod ens224 connection.autoconnect yes

    sudo systemctl disable firewalld
    sudo systemctl stop firewalld
    sudo systemctl disable NetworkManager
    sudo systemctl stop NetworkManager
    sudo systemctl enable network
    sudo systemctl start network

    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

    echo "192.168.20.21 mq1" >> /etc/hosts
    echo "192.168.20.22 mq2" >> /etc/hosts
    echo "192.168.20.23 mq3" >> /etc/hosts

    echo "Khoi dong lai may chu"
    sleep 5
    init 6
  else
    echo "Sai cu phap roi, cu phap dung nhu sau "
    echo "Thuc hien tren may chu MQ1: bash $0 mq1"
    echo "Thuc hien tren may chu MQ2: bash $0 mq2"
    echo "Thuc hien tren may chu MQ3: bash $0 mq3"
    exit 1
fi

