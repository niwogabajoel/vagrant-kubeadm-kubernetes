#!/bin/bash
#
# Setup for Node servers
#Join Cluster After Installation
#sudo kubeadm join master.ddx.com:6443 --token asklxw.fhj6tcnjkyx9kdbn --discovery-token-ca-cert-hash sha256:25e99ec175a07528568948a0389bb4159e31692e84f98b85a101e84cf1691497
set -euxo pipefail
#Run the join Script From Master
sudo /bin/bash /vagrant/join.sh -v

sudo -i -u vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker
EOF
