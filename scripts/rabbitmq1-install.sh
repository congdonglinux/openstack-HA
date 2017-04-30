#!/bin/bash -ex
### Script cai dat rabbitmq tren mq1


#Khai bao cac bien su dung trong script
##Bien cho bond0
MQ1_IP_BOND1=192.168.20.21
MQ2_IP_BOND1=192.168.20.22
MQ3_IP_BOND1=192.168.20.23

### Kiem tra cu phap khi thuc hien shell 
if [ $# -ne 1 ]
    then
        echo  "Cu phap dung nhu sau "
        echo "Thuc hien tren may chu MQ1: bash $0 mq1"
        echo "Thuc hien tren may chu MQ2: bash $0 mq2"
        echo "Thuc hien tren may chu MQ3: bash $0 mq3"
        exit 1;
fi

echo "Cai dat rabbitmq"
sleep 5

function install_proxy {
        echo "proxy=http://123.30.178.220:3142" >> /etc/yum.conf 
        yum -y update
}

function install_repo {
        yum install -y centos-release-openstack-newton
        yum upgrade
}

function khai_bao_host {
        if [ "$1" == "mq1" ]; then
                echo "$MQ1_IP_BOND1 mq1" >> /etc/hosts
                echo "$MQ2_IP_BOND1 mq2" >> /etc/hosts
                echo "$MQ3_IP_BOND1 mq3" >> /etc/hosts

                scp /etc/hosts root@$MQ2_IP_BOND1:/etc/
                scp /etc/hosts root@$MQ3_IP_BOND1:/etc/
        else 
                echo "khong khai bao"
        fi 
}

function install_rabbitmq {
        yum install -y rabbitmq-server

        systemctl enable rabbitmq-server.service
        systemctl start rabbitmq-server.service

        if [ "$1" == "mq1" ]; then
                rabbitmqctl add_user openstack Welcome123
                rabbitmqctl set_permissions openstack ".*" ".*" ".*"
                rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all"}'
                
                scp /var/lib/rabbitmq/.erlang.cookie root@mq2:/var/lib/rabbitmq/.erlang.cookie
                scp /var/lib/rabbitmq/.erlang.cookie root@mq3:/var/lib/rabbitmq/.erlang.cookie
                
                rabbitmqctl start_app
        elif [ "$1" == "mq2" ] || [ "$1" == "mq3" ]; then
                chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
                chmod 400 /var/lib/rabbitmq/.erlang.cookie
                systemctl enable rabbitmq-server.service
                systemctl start rabbitmq-server.service
                
                rabbitmqctl stop_app
                rabbitmqctl join_cluster rabbit@mq1 
                rabbitmqctl start_app
        fi
        
                
}

# Thuc thi cac functions
## Goi cac functions
install_proxy
install_repo
khai_bao_host
install_rabbitmq

rabbitmqctl cluster_status
