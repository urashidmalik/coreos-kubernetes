#!/bin/bash
kubectl config set-cluster vagrant --server=https://172.17.4.101:443 --certificate-authority=${PWD}/ssl/ca.pem
kubectl config set-credentials vagrant-admin --certificate-authority=${PWD}/ssl/ca.pem --client-key=${PWD}/ssl/admin-key.pem --client-certificate=${PWD}/ssl/admin.pem --username=vagrnat --password=vagrant --insecure-skip-tls-verify=true
kubectl config set-context vagrant --cluster=vagrant --user=vagrant-admin
kubectl config use-context vagrant


cd ../../../
if [ ! -d "./kubernetes" ]; then
	git clone git@github.com:urashidmalik/kubernetes.git
fi
cd kubernetes

echo "Getting kubernetes Dashboard up..."
kubectl create -f cluster/addons/kube-ui/kube-ui-rc.yaml --namespace=kube-system
kubectl create -f cluster/addons/kube-ui/kube-ui-svc.yaml --namespace=kube-system
sleep 10

kubectl create -f examples/guestbook-go/redis-master-controller.json
kubectl create -f examples/guestbook-go/redis-master-service.json

kubectl create -f examples/guestbook-go/redis-slave-controller.json
kubectl create -f examples/guestbook-go/redis-slave-service.json
kubectl create -f examples/guestbook-go/guestbook-controller.json
kubectl create -f examples/guestbook-go/guestbook-service.json