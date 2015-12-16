#!/bin/bash -e

if [ $# -eq 0 ]
  then
    magenta=`tput setaf 1; tput bold;`
    echo "${magenta}No arguments supplied.
usage: ./tls_generator example.com
    "
    exit
else
  FQDN=$1
fi

magenta=`tput setaf 5; tput bold;`
SSL_DIR=ssl_$FQDN_`date "+%d_%m_%y_%H-%M-%S"`
API_FQDN="kube.$FQDN"
WORKER_FQDN="kubeworker.$FQDN"

echo "${magenta}Creating SSL DIR: $SSL_DIR ..."
mkdir -p  $SSL_DIR
echo "${magenta}Creating CA Certificate for Signing ..."
./init-ssl-ca $SSL_DIR
echo "${magenta}Creating Apiserver Certificate ..."
./init-ssl $SSL_DIR apiserver $API_FQDN "IP.1=10.0.0.50,IP.2=11.1.2.1,DNS.1=$API_FQDN,DNS.2=kubernetes,DNS.3=comkubernetes.default,DNS.4=kubernetes.default.svc,DNS.5=kubernetes.default.svc.cluster.local"
echo "${magenta}Creating Worker Certificate  ..."
./init-ssl $SSL_DIR worker $WORKER_FQDN "DNS.1=$WORKER_FQDN,DNS.2=*.*.cluster.internal,DNS.3=*.ec2.internal"
echo "${magenta}Creating Client Certificate for devops Admin box ..."
./init-ssl $SSL_DIR admin kube-admin

echo ""
echo ""
echo "${magenta}Convert Certificate (CA, Apiserver, Worker) to base64  ..."
cd $SSL_DIR
cat ca.pem | base64 > ca.pem.b64
cat apiserver.pem | base64 > apiserver.pem.b64
cat apiserver-key.pem | base64 > apiserver-key.pem.b64
cat worker.pem | base64 > worker.pem.b64
cat worker-key.pem | base64 > worker-key.pem.b64
echo ""
echo "${magenta}... THANK YOU ..."


#read
#rm -rf $SSL_DIR
