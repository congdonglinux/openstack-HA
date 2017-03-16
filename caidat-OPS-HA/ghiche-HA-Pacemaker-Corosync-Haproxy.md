## Ghi chep cai dat HA 

## Cac chu y chung 

- Khai bao proxy
```sh 
echo 'Acquire::http::Proxy "http://192.168.100.143:3142";' > /etc/apt/apt.conf
apt-get update
```

- Dai ip duoc cap  
	172.16.69.61 - 99
	192.168.100.61 - 99

- 

## Các thiết lập về network

- IP VIP được sử dụng là: `192.168.11.70`

### Controlelr1
- SSH: umdt/1q	root/1q
- IP cho controller1

  ```sh
  eth0: 	Hostonly	192.168.11.129		/24		
  eth1: 	NAT			  172.16.69.210		  /24		172.16.69.1
  eth2: 	Bridge: 	192.168.100.139		/24
  ```

### Controlelr2
- SSH: umdt/1q	root/1q
- IP cho controller2

  ```sh
	eth0: 	Hostonly	192.168.11.130		 /24		
	eth1: 	NAT			172.16.69.200		     /24		172.16.69.1
	eth2: 	Bridge: 	192.168.100.141		 /24
  ```


### Controlelr3
- SSH: `umdt/1q`	`root/1q`
- IP cho controller3

  ```sh
  eth0: 	Hostonly	192.168.11.132		/24		
  eth1: 	NAT			172.16.69.201		    /24		172.16.69.1
  eth2: 	Bridge: 	192.168.100.142		/24
  ```

## Khai bao repos va dat IP cho cac may CONTROLLER

##########################################
### Khai bao  repos & IP tren CONTROLLER1
##########################################

- Khai báo repos trên cả 3 node
  ```sh
  apt-get install software-properties-common
  add-apt-repository cloud-archive:mitaka

  apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y
  ```

- Sao luu file cau hinh network
  ```sh 
  cp /etc/network/interfaces /etc/network/interfaces.orig
  ```

- Khai bao IP tinh cho eth0 va eth1. De IP dong cho eth2
  ```sh
  cat << EOF > /etc/network/interfaces
  auto lo
  iface lo inet loopback


  # The primary network interface
  auto eth0
  iface eth0 inet static
  address 192.168.11.71
  netmask 255.255.255.0

  auto eth1
  iface eth1 inet static
  address 172.16.69.71
  gateway 172.16.69.1
  netmask 255.255.255.0
  dns-nameservers 8.8.8.8

  auto eth2
  iface eth2 inet dhcp
  EOF
  ```


- Khai bao /ect/hosts, o day u14-ctl1, u14-ctl2, u14-ctl3 la hostname cua cac may
  ```sh
  cat << EOF >> /etc/hosts
  192.168.11.71 	u14-ctl1
  192.168.11.72 	u14-ctl2
  192.168.11.73 	u14-ctl3
  EOF
  ```

- Cho phep dang nhap root tu xa
  ```sh
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
  ```
- Khoi dong la CONTROLLER1

  ```sh
  init 6
  ```


### Khai bao  repos & IP tren CONTROLLER2

- Khai báo repos trên node controller2
  ```sh
  apt-get install software-properties-common
  add-apt-repository cloud-archive:mitaka

  apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y 
  ```

- Sao luu file cau hinh network 
  ```sh
  cp /etc/network/interfaces /etc/network/interfaces.orig
  ```

- Khai bao IP tinh cho eth0 va eth1. De IP dong cho eth2
  ```sh
  cat << EOF > /etc/network/interfaces
  auto lo
  iface lo inet loopback

  # The primary network interface
  auto eth0
  iface eth0 inet static
  address 192.168.11.72
  netmask 255.255.255.0

  auto eth1
  iface eth1 inet static
  address 172.16.69.72
  gateway 172.16.69.1
  netmask 255.255.255.0
  dns-nameservers 8.8.8.8

  auto eth2
  iface eth2 inet dhcp
  EOF
  ```

- Khai bao /ect/hosts, o day u14-ctl1, u14-ctl2, u14-ctl3 la hostname cua cac may
  ```sh
  cat << EOF >> /etc/hosts
  192.168.11.71 	u14-ctl1
  192.168.11.72 	u14-ctl2
  192.168.11.73 	u14-ctl3
  EOF
  ```

- Cho phep dang nhap root tu xa
  ```sh
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
  service ssh restart 
  ```

- Khoi dong la CONTROLLER2
  ```sh
  init 6
  ```

##########################################
### Khai bao  repos & IP tren CONTROLLER3
##########################################

  ```sh
  apt-get install -y software-properties-common
  add-apt-repository -y cloud-archive:mitaka

  apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y 
  ```

- Sao luu file cau hinh network 
  ```sh
  cp /etc/network/interfaces /etc/network/interfaces.orig
  ```

- Khai bao IP tinh cho eth0 va eth1. De IP dong cho eth2

  ```sh
  cat << EOF > /etc/network/interfaces
  auto lo
  iface lo inet loopback

  # The primary network interface
  auto eth0
  iface eth0 inet static
  address 192.168.11.73
  netmask 255.255.255.0

  auto eth1
  iface eth1 inet static
  address 172.16.69.73
  gateway 172.16.69.1
  netmask 255.255.255.0
  dns-nameservers 8.8.8.8

  auto eth2
  iface eth2 inet dhcp
  EOF
  ```

- Khai bao /ect/hosts, o day u14-ctl1, u14-ctl2, u14-ctl3 la hostname cua cac may
  ```sh
  cat << EOF >> /etc/hosts
  192.168.11.71 	u14-ctl1
  192.168.11.72 	u14-ctl2
  192.168.11.73 	u14-ctl3
  EOF
  ```

- Cho phep dang nhap root tu xa
  ```sh
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
  ```

- Khoi dong la CONTROLLER3
  ```sh
  init 6
  ```


## Cai dat Pacemaker & Corosync
### Cai dat Pacemaker & Corosync tren CONTROLLER1, CONTROLLER2, CONTROLLER3

- Cai dat NTP

  ```sh
  sudo apt-get -y install ntp

  sudo apt-get -y install pacemaker haveged

  sudo apt-get -y install haproxy 
  ```

- Dung tren controller1 thuc hien lenh duoi

  ```sh
  sudo corosync-keygen
  ```

- Copy file key do corosync sinh ra tren Controller1 sang Controller2 va Controller3

  ```sh
  scp /etc/corosync/authkey root@192.168.11.72:/tmp/corosync-authkey

  scp /etc/corosync/authkey root@192.168.11.73:/tmp/corosync-authkey
  ```

- Dung tren controller2 va controller3 thuc hien cac lenh sau

  ```sh
  sudo mv /tmp/corosync-authkey /etc/corosync/authkey

  sudo chown root: /etc/corosync/authkey

  sudo chmod 400 /etc/corosync/authkey
  ```

########################################################################################################
# Cau hinh corosync tren ca 3 server

- Sao luu file corosync

  ```sh
  cp /etc/corosync/corosync.conf /etc/corosync/corosync.conf.orig
  ```

- Sua file `/etc/corosync/corosync.conf` tren ca 3 node

  ```sh
  cat << EOF >> /etc/corosync/corosync.conf
  totem {
    version: 2
    cluster_name: lbcluster
    transport: udpu
    interface {
      ringnumber: 0
      bindnetaddr: 192.168.11.0
      broadcast: yes
      mcastport: 5405
    }
  }

  quorum {
    provider: corosync_votequorum
    two_node: 1
  }

  nodelist {
    node {
      ring0_addr: 192.168.11.71
      nodeid: 1
    }
    node {
      ring0_addr: 192.168.11.72
      nodeid: 2
    }

      node {
      ring0_addr: 192.168.11.73
      nodeid: 3
    }
  }

  logging {
    to_logfile: yes
    logfile: /var/log/corosync/corosync.log
    to_syslog: yes
    timestamp: on
  }
  EOF
  ```

- Tao file voi noi dung duoi

  ```sh
  cat << EOF > /etc/corosync/service.d/pcmk
  service {
    name: pacemaker
    ver: 1
  }
  EOF
  ```


- Sua file tren ca 3 node
  ```sh
  sed -i 's/START=no/START=yes/g' /etc/default/corosync
  ```

- Khoi dong corosync tren ca 3 node 
  ```sh
  sudo service corosync start
  ```

- Dung tren 1 trong 3 node kiem tra trang thai cua corosync
  ```sh
  sudo corosync-cmapctl | grep members
  ```


- Ket qua nhu duoi
  ```sh
  runtime.totem.pg.mrp.srp.members.1.config_version (u64) = 0
  runtime.totem.pg.mrp.srp.members.1.ip (str) = r(0) ip(192.168.11.71)
  runtime.totem.pg.mrp.srp.members.1.join_count (u32) = 1
  runtime.totem.pg.mrp.srp.members.1.status (str) = joined
  runtime.totem.pg.mrp.srp.members.2.config_version (u64) = 0
  runtime.totem.pg.mrp.srp.members.2.ip (str) = r(0) ip(192.168.11.72)
  runtime.totem.pg.mrp.srp.members.2.join_count (u32) = 1
  runtime.totem.pg.mrp.srp.members.2.status (str) = joined
  runtime.totem.pg.mrp.srp.members.3.config_version (u64) = 0
  runtime.totem.pg.mrp.srp.members.3.ip (str) = r(0) ip(192.168.11.73)
  runtime.totem.pg.mrp.srp.members.3.join_count (u32) = 1
  runtime.totem.pg.mrp.srp.members.3.status (str) = joined
  ```

########################################################################################################
## Start and Configure Pacemaker

- Kich hoat pacemaker khi khoi dong OS, thuc hien tren ca 3 node
  ```sh 
  sudo update-rc.d pacemaker defaults 20 01
  ```

- Khoi dong pacemaker tren ca 3 node
  ```sh
  sudo service pacemaker start
  ```sh

- Dung tren 1 node bat ky kiem tra trang thai cua cluster cua pacemaker
  ```sh
  sudo crm status
  ```

- Ket qua la
  ```sh
  Last updated: Sun Mar 12 00:35:26 2017
  Last change: Sun Mar 12 00:35:22 2017 via crmd on u14-ctl1
  Stack: corosync
  Current DC: u14-ctl1 (1) - partition with quorum
  Version: 1.1.10-42f2063
  3 Nodes configured
  0 Resources configured

  Online: [ u14-ctl1 u14-ctl2 u14-ctl3 ]
  ```


- Hoac su dung "sudo crm_mon" de xem o che do tuong tac

- Cau hinh cac che do dac biet cho Cluster. Dung tren node bat ky thuc hien cac lenh duoi, cac node con lai se dong bo sang
  ```sh
	sudo crm configure property stonith-enabled=false
	sudo crm configure property no-quorum-policy=ignore
  ```

- Xac nhan lai cau hinh cluster cho pacemaker
  ```sh
	sudo crm configure show
  ```


- Lenh thiet lap cac che do cho pacemaker trên một node bất kỳ, các cấu hình này sẽ tự động áp sang các node còn lại vì chúng đã join vào cluster


  ```sh
  sudo crm configure property stonith-enabled=false
  sudo crm configure property no-quorum-policy=ignore
  ```

- Cấu hình resource VIP IP cho Pacemaker,  thực hiện trên node bất kỳ
  ```sh 
  sudo crm configure primitive VIP ocf:heartbeat:IPaddr2 \
  params ip="192.168.11.70" cidr_netmask="24" nic="eth0" \
  op monitor interval="10s" \
  meta migration-threshold="10"
  ```

- Cấu hình resource `HAproxy` cho Pacemaker, thực hiện trên node bất kỳ
  ```
  sudo crm configure primitive res_haproxy lsb:haproxy \
  op start timeout="30s" interval="0" \
  op stop timeout="30s" interval="0" \
  op monitor interval="10s" timeout="60s" \
  meta migration-threshold="10"
  ```

- Gộp nhóm 2 resource `HAproxy và Pacemaker` vừa tạo ở trên để đảm bảo cả HAproxy và IP VIP được chạy đồng thời trên cùng một máy chủ.  Thực hiện trên node bất kỳ
  ```sh
  sudo crm configure group grp_balancing VIP res_haproxy
  ```
- Kiểm tra lại trạng thái cluster của Corosync và Pacemaker
  ```sh
  Last updated: Sun Mar 12 16:18:30 2017
  Last change: Sun Mar 12 12:51:11 2017 via cibadmin on u14-ctl1
  Stack: corosync
  Current DC: u14-ctl3 (3) - partition with quorum
  Version: 1.1.10-42f2063
  3 Nodes configured
  2 Resources configured


  Online: [ u14-ctl1 u14-ctl2 u14-ctl3 ]

   Resource Group: grp_balancing
       VIP        (ocf::heartbeat:IPaddr2):       Started u14-ctl3
       res_haproxy        (lsb:haproxy):  Started u14-ctl3

  ```

- Lúc này ta sẽ nhìn thấy `ocf::heartbeat:IPaddr2` và `lsb:haproxy` chạy trên cùng node `u14-ctl3`

########################################################################################################
### Cài đặt HAproxy

- Cài đặt gói

  ```sh
  sudo apt-get -y install haproxy
  ```

## Thanm khao 

- https://www.digitalocean.com/community/tutorials/how-to-create-a-high-availability-haproxy-setup-with-corosync-pacemaker-and-floating-ips-on-ubuntu-14-04#prerequisites

- https://gist.github.com/Ham5ter/8665b75e974561a761338c1f1c221453


########################################################################################################

## Ghi chep cai dat HAproxy

- Tham khao: https://www.upcloud.com/support/haproxy-load-balancer-ubuntu/
- Mo hinh 03 node


### Thiet lap ban dau

- Cho phep dang nhap root tu xa
  ```sh
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
  service ssh restart 

  init 6
  ```


### Khai bao  repos & IP tren cả 3 node

  ```sh
  apt-get install -y software-properties-common
  add-apt-repository -y cloud-archive:mitaka

  apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y
  ```

## Cai dat apache tren ca 3 node

- Cài Apache trên các node
  ```sh
  apt-get install apache2 -y
  ```

- Tren CTL1 tạo ra nội dung web
  ```sh
  cat <<EOF> /var/www/html/index.html
  <h1> CTL1 </h1>
  EOF
  ```

- Tren CTL2 tạo ra nội dung web
  ```sh
  cat <<EOF> /var/www/html/index.html
  <h1> CTL2 </h1>
  EOF
  ```

- Tren CTL3 tạo ra nội dung web
  ```sh
  cat <<EOF> /var/www/html/index.html
  <h1> CTL3 </h1>
  EOF
  ```

## Cai dat haproy tren ca 3 node

- Tai goi haproxy
  ```sh
  apt-get install haproxy -y
  ```

- Sao luu file cau hinh cua haproxy 
  ```sh
  cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.orig
  ```

- Setup cho HAProxy start tu dong
  ```sh
  echo "ENABLED=1" >> /etc/default/haproxy
  ```

- Khai báo cấu hình cho HAproxy trên 03 node  `/etc/haproxy/haproxy.cfg`
  ```sh
  cat <<EOF>> /etc/haproxy/haproxy.cfg
  global
    log         127.0.0.1 syslog
    maxconn     1000
    user        haproxy
    group       haproxy
    daemon

  defaults
    log  global
    mode  http
    option  httplog
    option  dontlognull
    option  http-server-close
    option  forwardfor except 127.0.0.0/8
    option  redispatch
    option  contstats
    retries  3
    timeout  http-request 10s
    timeout  queue 1m
    timeout  connect 10s
    timeout  client 1m
    timeout  server 1m
    timeout  check 10s

  listen  http_proxy
    bind        192.168.11.70:80
    balance     roundrobin
    server      u14-ctl1 172.16.69.71:80 maxconn 100 check inter 2000 rise 2 fall 5
    server      u14-ctl2 172.16.69.72:80 maxconn 100 check inter 2000 rise 2 fall 5
    server      u14-ctl3 172.16.69.73:80 maxconn 100 check inter 2000 rise 2 fall 5


  listen stats
          bind 192.168.11.70:8080
          mode http
          stats enable
          stats uri /stats
          stats realm HAProxy\ Statistics
          stats auth admin:congto6789
  EOF
  ```

- Truy cập vào trang theo dõi tình trạng HAproxy, nhập user là: `congto` mật khẩu là: `congto6789`
```sh
192.168.11.70:8080/stats
```


