#!/usr/bin/env bash

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

apt-get install -y vault=1.7.0 -V

sudo chown root:root vault

sudo useradd --system --home /etc/vault.d --shell /bin/false vault

cd /etc/vault.d

tee vault.hcl <<EOF
ui = true
mlock = false
disable_mlock = true

storage "raft" {
  path    = "/data/raft3"
  node_id = "raft3"
}

# HTTP listener
listener "tcp" {
  address          = "0.0.0.0:8200"
  cluster_address  = "0.0.0.0:8201"
  tls_disable      = "true"
}

api_addr =  "http://192.168.56.153:8200"
cluster_addr = "http://192.168.56.153:8201"
EOF

#rm -rf raft

#cd /etc/vault.d
#mkdir raft
#cd raft

#rm -rf /data/raft3/
mkdir -p /data/raft3
cd /data/raft3

sudo chown --recursive vault:vault /data/raft3

sudo chown --recursive vault:vault /etc/vault.d

sudo chmod 777 /etc/vault.d/vault.hcl

systemctl enable vault
systemctl stop vault
systemctl start vault





