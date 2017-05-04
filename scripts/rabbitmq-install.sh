#!/bin/bash -ex
### Script cai dat rabbitmq tren mq1
# Khai bao bien cho cac script 
cat <<EOF> /root/config.cfg
## Hostname
### Hostname cho cac may rabbitmq
MQ1_HOSTNAME=mq1
MQ2_HOSTNAME=mq2
MQ3_HOSTNAME=mq3

## IP Address
### IP cho bond0 cho cac may rabbitmq
MQ1_IP_NIC1=10.10.10.21
MQ2_IP_NIC1=10.10.10.22
MQ3_IP_NIC1=10.10.10.23

### IP cho bond1 cho cac may rabbitmq
MQ1_IP_NIC2=192.168.20.21
MQ2_IP_NIC2=192.168.20.22
MQ3_IP_NIC2=192.168.20.23
EOF

source config.cfg 

function setup_config {
        for IP_ADD in $MQ1_IP_NIC2 $MQ2_IP_NIC2 $MQ3_IP_NIC2
        do
                scp /root/config.cfg root@$IP_ADD:/root/
                chmod +x config.cfg 
        done
}

##Bien cho hostname

function echocolor {
    echo "#######################################################################"
    echo "$(tput setaf 3)##### $1 #####$(tput sgr0)"
    echo "#######################################################################"

}

function copykey() {
        ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
        for IP_ADD in $MQ1_IP_NIC2 $MQ2_IP_NIC2 $MQ3_IP_NIC2
        do
                ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@$IP_ADD
        done
}

function install_proxy() {
        echo "proxy=http://123.30.178.220:3142" >> /etc/yum.conf 
        yum -y update
}

function install_repo() {
        yum -y install centos-release-openstack-newton
        yum -y upgrade
}

function khai_bao_host() {
                source config.cfg
                echo "$MQ1_IP_NIC2 mq1" >> /etc/hosts
                echo "$MQ2_IP_NIC2 mq2" >> /etc/hosts
                echo "$MQ3_IP_NIC2 mq3" >> /etc/hosts
                scp /etc/hosts root@$MQ2_IP_NIC2:/etc/
                scp /etc/hosts root@$MQ3_IP_NIC2:/etc/
}

function install_rabbitmq() {
        yum -y install rabbitmq-server
        systemctl enable rabbitmq-server.service
        systemctl start rabbitmq-server.service
        rabbitmq-plugins enable rabbitmq_management
        systemctl restart rabbitmq-server
        curl -O http://localhost:15672/cli/rabbitmqadmin
        chmod a+x rabbitmqadmin
        mv rabbitmqadmin /usr/sbin/
        rabbitmqadmin list users
    
}

function config_rabbitmq() {
        source config.cfg
        rabbitmqctl add_user openstack Welcome123
        rabbitmqctl set_permissions openstack ".*" ".*" ".*"
        rabbitmqctl set_user_tags openstack administrator
        rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all"}'          
        echo "Da cai dat xong rabbitmq tren MQ1"
        scp /var/lib/rabbitmq/.erlang.cookie root@$MQ2_IP_NIC2:/var/lib/rabbitmq/.erlang.cookie
        scp /var/lib/rabbitmq/.erlang.cookie root@$MQ3_IP_NIC2:/var/lib/rabbitmq/.erlang.cookie
        rabbitmqctl start_app
        echo "Hoan thanh cai dat "

}

function rabbitmq_join_cluster() {
        source config.cfg
        chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
        chmod 400 /var/lib/rabbitmq/.erlang.cookie
        systemctl restart rabbitmq-server
        rabbitmqctl stop_app 
        rabbitmqctl reset
        rabbitmqctl join_cluster rabbit@$MQ1_HOSTNAME
        rabbitmqctl start_app
        rabbitmqctl cluster_status
     
}

############################
# Thuc thi cac functions
## Goi cac functions
############################
echocolor "Cai dat rabbitmq"
sleep 3

echocolor "Tao key va copy key, bien khai bao sang cac node"
sleep 3
copykey
setup_config


echocolor " install_proxy, install_repo "
sleep 3

for IP_ADD in $MQ1_IP_NIC2 $MQ2_IP_NIC2 $MQ3_IP_NIC2
do 
    echocolor "Cai dat proxy tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_proxy"
    
    echocolor "Cai dat install_repo tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_repo"
    
    if [ "$IP_ADD" == "$MQ1_IP_NIC2" ]; then
      echocolor "Cai dat khai_bao_host tren $IP_ADD"
      sleep 3
      ssh root@$IP_ADD "$(typeset -f); khai_bao_host"
    fi 
    echocolor "Cai dat install_rabbitmq tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_rabbitmq"
done 

for IP_ADD in $MQ1_IP_NIC2 $MQ2_IP_NIC2 $MQ3_IP_NIC2
do 
    if [ "$IP_ADD" == "$MQ1_IP_NIC2" ]; then 
      echocolor "Cai dat config_rabbitmq tren $IP_ADD"
      sleep 3
      ssh root@$IP_ADD "$(typeset -f); config_rabbitmq"    
    elif [ "$IP_ADD" == "$MQ2_IP_NIC2" ] || [ "$IP_ADD" == "$MQ3_IP_NIC2" ]; then
      echocolor "Cai dat rabbitmq_join_cluster tren $IP_ADD"
      sleep 3
      ssh root@$IP_ADD "$(typeset -f); rabbitmq_join_cluster"

    fi 
done 

rabbitmqctl cluster_status
echocolor DONE
