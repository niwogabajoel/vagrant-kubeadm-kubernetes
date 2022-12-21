#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.56.10 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
#mkdir /home/vagrant/.kube
#cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
#chown -R vagrant:vagrant /home/vagrant/.kube
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy flannel network
echo "[TASK 3] Deploy flannel network"
su - vagrant -c "kubectl create -f /vagrant/kube-flannel.yaml"

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh
