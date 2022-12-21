#!/bin/bash
#
# Setup for Control Plane (Master) servers

#Master
echo "[TASK 6] Initialize Kubernetes cluster with Kubeadm command"
sudo kubeadm init --control-plane-endpoint=master.ddx.com
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#Fix the connection issue localhost:8080 not connected
#https://k21academy.com/docker-kubernetes/the-connection-to-the-server-localhost8080-was-refused/
export KUBECONFIG=$HOME/.kube/config


# For Vagrant re-runs, check if there is existing configs in the location and delete it for saving new configuration.
config_path="/vagrant/configs"
if [ -d $config_path ]; then
  sudo rm -f $config_path/*
else
  sudo mkdir -p $config_path
fi

sudo cp -i /etc/kubernetes/admin.conf /vagrant/configs/config
sudo touch /vagrant/configs/join.sh
sudo chmod +x /vagrant/configs/join.sh
sudo kubeadm token create --print-join-command > /vagrant/configs/join.sh

kubectl cluster-info
kubectl get nodes
kubectl get nodes
echo "--- [DONE TASK 6] ---"

echo "[TASK 7] Install Calico Pod Network Add-on"
curl https://projectcalico.docs.tigera.io/manifests/calico.yaml -O
kubectl apply -f calico.yaml
kubectl get pods -n kube-system
kubectl get nodes
echo "--- [DONE TASK 7] ---"

echo "[TASK 8] Closed Master"
#kubectl create deployment nginx-app --image=nginx --replicas=2