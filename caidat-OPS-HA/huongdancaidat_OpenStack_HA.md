# Hướng dẫn cài đặt OpenStack HA 

## Môi trường

- Ubuntu server 14.04  64 bit
- OpenStack Mitaka

## Thiết lập các host

- CTL1
- CTL2
- CTL3

### Thiết lập IP, hostname và repos

#### Cài đặt trên CTL1

- Sao lưu file cấu hình network

```sh
cp /etc/network/interfaces /etc/network/interfaces.orig
```

- Khai báo IP cho các NICs của node Controller1 

```sh
cat << EOF >> /etc/network/interfaces
#Assign IP for Controller node

# LOOPBACK NET
auto lo
iface lo inet loopback

# MGNT NETWORK
auto eth0
iface eth0 inet static
address 10.10.10.51
netmask 255.255.255.0

# EXT NETWORK
auto eth1
iface eth1 inet static
address 172.16.69.51
netmask 255.255.255.0
gateway 172.16.69.1
dns-nameservers 8.8.8.8
EOF
```

- Cấu hình hostname

```sh
echo "controller1" > /etc/hostname
hostname -F /etc/hostname

cat << EOF >> /etc/hosts
127.0.0.1       localhost controller1
10.10.10.50 	controller
10.10.10.51 	controller1
10.10.10.52 	controller2
10.10.10.53 	controller3
10.10.10.61 	compute1
10.10.10.62 	compute2
10.10.10.63 	compute3
EOF
```

-  Khai báo repos cài đặt OpenStack

```sh
apt-get install software-properties-common -y
add-apt-repository cloud-archive:mitaka -y
```

- Khởi động lại node Controller1

```sh
init 6
```

#### Cài đặt trên CTL2

- Sao lưu file cấu hình network

```sh
cp /etc/network/interfaces /etc/network/interfaces.orig
```

- Khai báo IP cho các NICs của node Controller2

```sh
cat << EOF >> /etc/network/interfaces
#Assign IP for Controller node

# LOOPBACK NET
auto lo
iface lo inet loopback

# MGNT NETWORK
auto eth0
iface eth0 inet static
address 10.10.10.52
netmask 255.255.255.0

# EXT NETWORK
auto eth1
iface eth1 inet static
address 172.16.69.52
netmask 255.255.255.0
gateway 172.16.69.1
dns-nameservers 8.8.8.8
EOF
```

- Cấu hình hostname

```sh
echo "controller2" > /etc/hostname
hostname -F /etc/hostname

cat << EOF >> /etc/hosts
127.0.0.1       localhost controller2
10.10.10.50 	controller
10.10.10.51 	controller1
10.10.10.52 	controller2
10.10.10.53 	controller3
10.10.10.61 	compute1
10.10.10.62 	compute2
10.10.10.63 	compute3
EOF
```

-  Khai báo repos cài đặt OpenStack

```sh
apt-get install software-properties-common -y
add-apt-repository cloud-archive:mitaka -y
```

- Khởi động lại node Controller2

```sh
init 6
```

#### Cài đặt trên CTL3

- Sao lưu file cấu hình network

```sh
cp /etc/network/interfaces /etc/network/interfaces.orig
```

- Khai báo IP cho các NICs của node Controller3

```sh
cat << EOF >> /etc/network/interfaces
#Assign IP for Controller node

# LOOPBACK NET
auto lo
iface lo inet loopback

# MGNT NETWORK
auto eth0
iface eth0 inet static
address 10.10.10.53
netmask 255.255.255.0

# EXT NETWORK
auto eth1
iface eth1 inet static
address 172.16.69.53
netmask 255.255.255.0
gateway 172.16.69.1
dns-nameservers 8.8.8.8
EOF
```

- Cấu hình hostname

```sh
echo "controller3" > /etc/hostname
hostname -F /etc/hostname

cat << EOF >> /etc/hosts
127.0.0.1       localhost controller3
10.10.10.50 	controller
10.10.10.51 	controller1
10.10.10.52 	controller2
10.10.10.53 	controller3
10.10.10.61 	compute1
10.10.10.62 	compute2
10.10.10.63 	compute3
EOF
```

-  Khai báo repos cài đặt OpenStack

```sh
apt-get install software-properties-common -y
add-apt-repository cloud-archive:mitaka -y
```

- Khởi động lại node Controller3

```sh
init 6
```

### Cài đặt Network Time Protocol (NTP)
#### Cài đặt NTP trên CTL1

- Tải gói `chrony`

```sh
apt-get -y install chrony
````

- Cấu hình NTP Server

```sh
cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.orig


sed -i 's/server 0.debian.pool.ntp.org offline minpoll 8/ \
server 1.vn.pool.ntp.org iburst \
server 0.asia.pool.ntp.org iburst \
server 3.asia.pool.ntp.org iburst/g' /etc/chrony/chrony.conf

sed -i 's/server 1.debian.pool.ntp.org offline minpoll 8/ \
# server 1.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 2.debian.pool.ntp.org offline minpoll 8/ \
# server 2.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 3.debian.pool.ntp.org offline minpoll 8/ \
# server 3.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf
```

- Khởi động lại NTP Server

```sh
/etc/init.d/chrony restart
 ```

#### Cài đặt NTP trên CTL2

- Tải gói NTP

```sh
apt-get -y install chrony
```

- Cấu hình NTP trên CTL2

```sh
cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.orig

sed -i "s/server 0.debian.pool.ntp.org offline minpoll 8/ \
server 10.10.10.51 iburst/g" /etc/chrony/chrony.conf

sed -i 's/server 1.debian.pool.ntp.org offline minpoll 8/ \
# server 1.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 2.debian.pool.ntp.org offline minpoll 8/ \
# server 2.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 3.debian.pool.ntp.org offline minpoll 8/ \
# server 3.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf
```

- Khởi động lại NTP Server

```sh
/etc/init.d/chrony restart
 ```

#### Cài đặt NTP trên CTL3

- Tải gói NTP

```sh
apt-get -y install chrony
```

- Cấu hình NTP trên CTL3

```sh
cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.orig

sed -i "s/server 0.debian.pool.ntp.org offline minpoll 8/ \
server 10.10.10.51 iburst/g" /etc/chrony/chrony.conf

sed -i 's/server 1.debian.pool.ntp.org offline minpoll 8/ \
# server 1.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 2.debian.pool.ntp.org offline minpoll 8/ \
# server 2.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 3.debian.pool.ntp.org offline minpoll 8/ \
# server 3.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf
```

- Khởi động lại NTP Server

```sh
/etc/init.d/chrony restart
 ```

### Cài đặt Memcached
#### Cài đặt Memcached trên CTL1
 
- Tải gói cài đặt memcached

 ```sh 
 apt-get -y install memcached python-memcache
 ```

#### Cài đặt Memcached trên CTL2
 
- Tải gói cài đặt memcached

 ```sh 
 apt-get -y install memcached python-memcache
 ```

#### Cài đặt Memcached trên CTL3
 
- Tải gói cài đặt memcached

 ```sh 
 apt-get -y install memcached python-memcache
 ```

### Cài đặt MariaDB và Galera

#### Cài đặt MariaDB và Galera trên CTL1, CTL2 và CTL3

- Khai báo gói phần mềm cần thiét

```sh
apt-get -y install python-software-properties

```

- Khai báo gói repo cho Galera

```sh
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
add-apt-repository "deb http://mirror.edatel.net.co/mariadb/repo/5.5/ubuntu trusty main"
apt-get update
````

- Cài đặt Mariadb và Galera. Lưu ý, mật khẩu lúc này setup là `Welcome123`

```sh
echo mysql-server mysql-server/root_password password Welcome123 | debconf-set-selections
echo mysql-server mysql-server/root_password_again password Welcome123 | debconf-set-selections

apt-get install -y rsync galera  mariadb-galera-server
```

- Kiểm tra trên từng node bằng lệnh `mysql -u root -p`. Kết quả như sau: 

```sh
root@controller2:~# mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 36
Server version: 5.5.54-MariaDB-1~trusty-wsrep mariadb.org binary distribution, wsrep_25.14.r9949137

Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```

- Phiên bản cài đặt Mariadb là Mariadb 5.5

```sh
root@controller1:~# dpkg -l | grep mariadb
ii  libmariadbclient18                  5.5.54+maria-1~trusty             amd64        MariaDB database client library
ii  mariadb-client-5.5                  5.5.54+maria-1~trusty             amd64        MariaDB database client binaries
ii  mariadb-client-core-5.5             5.5.54+maria-1~trusty             amd64        MariaDB database core client binaries
ii  mariadb-common                      5.5.54+maria-1~trusty             all          MariaDB database common files (e.g. /etc/mysql/conf.d/mariadb.cnf)
ii  mariadb-galera-server               5.5.54+maria-1~trusty             all          MariaDB database server with Galera cluster (metapackage depending on the latest version)
ii  mariadb-galera-server-5.5           5.5.54+maria-1~trusty             amd64        MariaDB database server with Galera cluster binaries
root@controller1:~#
```

- Phiên bản cài đặt galera là galera 5.5

```sh
root@controller1:~# dpkg -l | grep galera
ii  galera-3                            25.3.19-trusty                    amd64        Replication framework for transactional applications
ii  mariadb-galera-server               5.5.54+maria-1~trusty             all          MariaDB database server with Galera cluster (metapackage depending on the latest version)
ii  mariadb-galera-server-5.5           5.5.54+maria-1~trusty             amd64        MariaDB database server with Galera cluster binaries
root@controller1:~#
```

### Cấu hình MariaDB và Galera
#### Cấu hình MariaDB và Galera trên CTL1

- Sao lưu fiel cấu hình của MariaDB

```sh
cp /etc/mysql/my.cnf /etc/mysql/my.cnf.orig
```

- Comment các dòng sau trong file `/etc/mysql/my.cnf`

```sh
#bind-address           = 127.0.0.1
#default_storage_engine = InnoDB
#query_cache_limit              = 128K
#query_cache_size               = 64M
```

- Khai báo thêm file dưới

```
cat << EOF > /etc/mysql/conf.d/cluster.cnf
[mysqld]
query_cache_size=0
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
innodb_locks_unsafe_for_binlog=1
innodb_file_per_table
innodb_flush_log_at_trx_commit=2
query_cache_type=0
bind-address=0.0.0.0

max_connections = 102400
max_allowed_packet  = 16M

# Galera Provider Configuration
wsrep_provider=/usr/lib/galera/libgalera_smm.so
#wsrep_provider_options="gcache.size=32G"

# Galera Cluster Configuration
wsrep_cluster_name="openstack"
wsrep_cluster_address="gcomm://10.10.10.51,10.10.10.52,10.10.10.53"
# Galera Synchronization Congifuration
wsrep_sst_method=rsync
#wsrep_sst_auth=user:pass

# Galera Node Configuration
wsrep_node_address="10.10.10.51"
wsrep_node_name="controller1"
EOF
```

#### Cấu hình MariaDB và Galera trên CTL2

- Sao lưu fiel cấu hình của MariaDB

```sh
cp /etc/mysql/my.cnf /etc/mysql/my.cnf.orig
```

- Comment các dòng sau trong file `/etc/mysql/my.cnf`

```sh
#bind-address           = 127.0.0.1
#default_storage_engine = InnoDB
#query_cache_limit              = 128K
#query_cache_size               = 64M
```

- Khai báo thêm file dưới

```sh
cat << EOF > /etc/mysql/conf.d/cluster.cnf
[mysqld]
query_cache_size=0
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
innodb_locks_unsafe_for_binlog=1
innodb_file_per_table
innodb_flush_log_at_trx_commit=2
query_cache_type=0
bind-address=0.0.0.0

max_connections = 102400
max_allowed_packet  = 16M

# Galera Provider Configuration
wsrep_provider=/usr/lib/galera/libgalera_smm.so
#wsrep_provider_options="gcache.size=32G"

# Galera Cluster Configuration
wsrep_cluster_name="openstack"
wsrep_cluster_address="gcomm://10.10.10.51,10.10.10.52,10.10.10.53"
# Galera Synchronization Congifuration
wsrep_sst_method=rsync
#wsrep_sst_auth=user:pass

# Galera Node Configuration
wsrep_node_address="10.10.10.52"
wsrep_node_name="controller2"
EOF
```

#### Cấu hình MariaDB và Galera trên CTL3

- Sao lưu fiel cấu hình của MariaDB

```sh
cp /etc/mysql/my.cnf /etc/mysql/my.cnf.orig
```
- Comment các dòng sau trong file `/etc/mysql/my.cnf`


```sh
#bind-address           = 127.0.0.1
#default_storage_engine = InnoDB
#query_cache_limit              = 128K
#query_cache_size               = 64M
```

- Khai báo thêm file dưới

```
cat << EOF > /etc/mysql/conf.d/cluster.cnf
[mysqld]
query_cache_size=0
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
innodb_locks_unsafe_for_binlog=1
innodb_file_per_table
innodb_flush_log_at_trx_commit=2
query_cache_type=0
bind-address=0.0.0.0

max_connections = 102400
max_allowed_packet  = 16M

# Galera Provider Configuration
wsrep_provider=/usr/lib/galera/libgalera_smm.so
#wsrep_provider_options="gcache.size=32G"

# Galera Cluster Configuration
wsrep_cluster_name="openstack"
wsrep_cluster_address="gcomm://10.10.10.51,10.10.10.52,10.10.10.53"
# Galera Synchronization Congifuration
wsrep_sst_method=rsync
#wsrep_sst_auth=user:pass

# Galera Node Configuration
wsrep_node_address="10.10.10.53"
wsrep_node_name="controller3"
EOF
```