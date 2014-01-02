#!/bin/sh

sleep 30

# No password sudo
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# Set ubuntu as sudo
groupadd -r admin
usermod -a -G admin ubuntu

# Setup apt and install default packages
sudo sh -c "wget -qO- https://get.docker.io/gpg | apt-key add -"
sudo sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y logrotate linux-image-extra-`uname -r` lxc-docker jq curl libcurl3 libcurl3-gnutls libcurl4-openssl-dev

# Install self signed cert - http://www.g-loaded.eu/2005/11/10/be-your-own-ca/
mkdir -m 0755 \
     /etc/pki_mmd \
     /etc/pki_mmd/ca \
     /etc/pki_mmd/ca/private \
     /etc/pki_mmd/ca/certs \
     /etc/pki_mmd/ca/newcerts \
     /etc/pki_mmd/ca/crl


echo "Creating CA OpenSSL config"
cp /etc/ssl/openssl.cnf /etc/pki_mmd/ca/openssl.ca.cnf
sed -i '0,/dir.*=.*/{s:dir.*=.*:dir = .:}' /etc/pki_mmd/ca/openssl.ca.cnf
sed -i '0,/certificate.*=.*/{s:certificate.*=.*:certificate = \$dir/certs/mmdca.crt:}' /etc/pki_mmd/ca/openssl.ca.cnf
sed -i '0,/private_key.*=.*/{s:private_key.*=.*:private_key = \$dir/private/mmdca.key:}' /etc/pki_mmd/ca/openssl.ca.cnf

chmod 0600 /etc/pki_mmd/ca/openssl.ca.cnf

echo "Creating CA cert"
touch /etc/pki_mmd/ca/index.txt
echo '01' > /etc/pki_mmd/ca/serial
cd /etc/pki_mmd/ca/ && openssl req -config openssl.ca.cnf -nodes  -new -x509 -extensions v3_ca -keyout private/mmdca.key -out certs/mmdca.crt -days 3650 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=mmd.ca"
chmod 0400 /etc/pki_mmd/ca/private/mmdca.key

echo "Creating EtcD Client cert"
cd /etc/pki_mmd/ca && openssl req -config openssl.ca.cnf -new -nodes -keyout private/etcd.key -out etcd.csr -days 3650 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=mmd.etcd"
chown root.root /etc/pki_mmd/ca/private/etcd.key
chmod 0400 /etc/pki_mmd/ca/private/etcd.key

cd /etc/pki_mmd/ca && openssl ca -batch -config openssl.ca.cnf -policy policy_anything -out certs/etcd.crt -infiles etcd.csr
rm -f /etc/pki_mmd/mmd/etcd.csr

echo "Verifying Server cert"
openssl x509 -in /etc/pki_mmd/ca/certs/etcd.crt -noout -text
openssl verify -purpose sslserver -CAfile /etc/pki_mmd/ca/certs/mmdca.crt /etc/pki_mmd/ca/certs/etcd.crt

cd /etc/pki_mmd/ca && cat certs/etcd.crt private/etcd.key > private/etcd-key-cert.pem \
    && chown root.root private/etcd-key-cert.pem \
    && chmod 0400 private/etcd-key-cert.pem

cat /etc/pki_mmd/ca/certs/etcd.crt /etc/pki_mmd/ca/certs/mmdca.crt > /etc/pki_mmd/ca/certs/etcd.chained.crt

echo "Creating Web Server cert"
cd /etc/pki_mmd/ca && openssl req -config openssl.ca.cnf -new -nodes -keyout private/web.key -out web.csr -days 3650 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=mmd.etcd"
chown root.root /etc/pki_mmd/ca/private/web.key
chmod 0400 /etc/pki_mmd/ca/private/web.key

cd /etc/pki_mmd/ca && openssl ca -batch -config openssl.ca.cnf -policy policy_anything -out certs/web.crt -infiles web.csr
rm -f /etc/pki_mmd/mmd/web.csr

echo "Verifying Server cert"
openssl x509 -in /etc/pki_mmd/ca/certs/web.crt -noout -text
openssl verify -purpose sslserver -CAfile /etc/pki_mmd/ca/certs/mmdca.crt /etc/pki_mmd/ca/certs/web.crt

cd /etc/pki_mmd/ca && cat certs/web.crt private/web.key > private/etcd-key-cert.pem \
    && chown root.root private/etcd-key-cert.pem \
    && chmod 0400 private/etcd-key-cert.pem

cat /etc/pki_mmd/ca/certs/web.crt /etc/pki_mmd/ca/certs/mmdca.crt > /etc/pki_mmd/ca/certs/web.chained.crt


# Setup docker
sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw
mkdir /opt/docker /opt/docker/images

sudo docker run -d -p 4001:4001 -p 7001:7001 -v /etc/pki_mmd/ca:/etc/pki_mmd/ca -name etcd coreos/etcd -f -cert-file=/etc/pki_mmd/ca/certs/etcd.crt -key-file=/etc/pki_mmd/ca/private/etcd.key -data-dir machine0 -name machine0


mkdir /var/lib/mariadb
sudo docker run -d -p 3306:3306 -v /var/lib/mariadb:/data -name mariadb paintedfox/mariadb

mkdir /etc/nginx /var/log/nginx
sudo docker run -d -p 80:80 -v /etc/pki_mmd/ca:/etc/pki_mmd/ca -v /var/log/nginx:/var/log/nginx -v /etc/nginx:/etc/nginx/sites-enabled  mguymon/nginx

exit 0