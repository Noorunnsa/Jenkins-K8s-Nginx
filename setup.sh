#!/bin/bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo systemctl start docker
sudo systemctl enable docker


sudo sed -i '/swap/d' /etc/fstab
sudo swapoff -a

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

minikube config set driver docker

minikube start --driver=docker

kubectl get po -A


minikube kubectl -- get po -A

alias kubectl="minikube kubectl --"

