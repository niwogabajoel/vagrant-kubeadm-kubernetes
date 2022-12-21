#!/bin/bash
#
# Setup for Control Plane (Master) servers

#Master
echo "[TASK 6] Initialize Kubernetes cluster with Kubeadm command"
sudo kubeadm init --control-plane-endpoint=master.ddx.com
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

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