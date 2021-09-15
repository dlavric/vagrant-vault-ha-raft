# vagrant-vault-ha-raft

 Repository that builds High Availability of 3xVault nodes with Raft as the backend storage

## Pre-requisites

1. Install [Vagrant](https://www.vagrantup.com/docs/installation)

2. Install [VirtualBox](https://www.virtualbox.org/)

## Clone the Repository

```shell
git clone git@github.com:dlavric/vagrant-vault-ha-raft.git
cd vagrant-vault-ha-raft
```

## How to use this repository

1. Start Vagrant:

```shell
vagrant up
```

2. Connect to the `vault-1` virtual machine:

```shell
vagrant ssh vault-1
```

3. Export the `VAULT_ADDR` of Vault and check its status:

```shell
export VAULT_ADDR="http://127.0.0.1:8200"
vault status
```

You will observe that Vault has not been initialized or unsealed:

```
Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            1.7.0
Storage Type       raft
HA Enabled         true
```

4. Initialize and unseal Vault

```shell
vault operator init \
    -key-shares=1 \
    -key-threshold=1

vault operator unseal 
```

The output should look like this:

```
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            1
Threshold               1
Version                 1.7.0
Storage Type            raft
Cluster Name            vault-cluster-ed0cf15b
Cluster ID              77acc51b-33c6-765b-e316-a1c19914af2a
HA Enabled              true
HA Cluster              n/a
HA Mode                 standby
Active Node Address     <none>
Raft Committed Index    24
Raft Applied Index      24
```

5. Logout and then log into the other Vault nodes:

```shell
logout
vagrant ssh vault-2
```

6. Initialize and unseal Vault node `vault-2`:

```shell
export VAULT_ADDR="http://127.0.0.1:8200"

vault operator init \
    -key-shares=1 \
    -key-threshold=1

vault operator unseal
```

7. Repeat step `5` and `6` for `vault-3`

8. Now, log into the other nodes, like `vault-1`, `vault-2` and check the status:

```shell
logout
vagrant ssh vault-1
```

```shell
export VAULT_ADDR="http://127.0.0.1:8200"
vault status
```

### Output of the Vault status for all 3 nodes of the cluster

## vault-1

The output of `$ vault status` for `vault-1`:

```
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            1
Threshold               1
Version                 1.7.0
Storage Type            raft
Cluster Name            vault-cluster-ed0cf15b
Cluster ID              77acc51b-33c6-765b-e316-a1c19914af2a
HA Enabled              true
HA Cluster              https://192.168.56.151:8201
HA Mode                 active
Active Since            2021-09-15T10:56:27.983572266Z
Raft Committed Index    46
Raft Applied Index      46
```

## vault-2

The output of `$ vault status` for `vault-2`:

```shell
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            1
Threshold               1
Version                 1.7.0
Storage Type            raft
Cluster Name            vault-cluster-ec8a3d84
Cluster ID              ac2428f5-2982-e717-0168-67343098e737
HA Enabled              true
HA Cluster              https://192.168.56.152:8201
HA Mode                 active
Active Since            2021-09-15T11:01:27.660367546Z
Raft Committed Index    35
Raft Applied Index      35
```


## vault-3

The output of `$ vault status` for `vault-3`:

```
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            1
Threshold               1
Version                 1.7.0
Storage Type            raft
Cluster Name            vault-cluster-c6337c8a
Cluster ID              88cc9483-8e6d-2b8d-9df3-b559c3c94de5
HA Enabled              true
HA Cluster              https://192.168.56.153:8201
HA Mode                 active
Active Since            2021-09-15T11:03:01.887877071Z
Raft Committed Index    32
Raft Applied Index      32
```

