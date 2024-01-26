#!/bin/bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
minikube config set driver docker
minikube start --driver=docker
kubectl get po -A
minikube kubectl -- get po -A
alias kubectl="minikube kubectl --"
