#!/bin/bash
#
# Common setup for all servers (Control Plane and Nodes)
echo "[TASK 1] Common setup for all servers (Control Plane and Nodes)"
set -euxo pipefail

# Variable Declaration
KUBERNETES_VERSION="1.23.6-00"

echo "[TASK 2] Disable Swap & add kernel settings"
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true

echo "--- [DONE TASK 2] ---"

echo "[TASK 3] Install containerd run time"

sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io

#Configure containerd so that it starts using systemd as cgroup.
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

echo "--- [DONE TASK 3] ---"

echo "[TASK 4] Add apt repository for Kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
echo "--- [DONE TASK 4] ---"

echo "[TASK 5] Install Kubernetes components Kubectl, kubeadm & kubelet"
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "--- [DONE TASK 5] ---"

