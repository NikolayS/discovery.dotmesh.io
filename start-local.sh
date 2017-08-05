#!/bin/bash
docker build -t lmarsden/discovery.data-mesh.io .
HostIP=localhost
docker rm -f etcd discovery
docker run --restart=always -d -v /usr/share/ca-certificates/:/etc/ssl/certs \
 -v /pool/etcd-data:/var/lib/etcd \
 --name etcd \
 quay.io/coreos/etcd:v3.0.15 \
 etcd -name etcd0 \
 -data-dir /var/lib/etcd \
 -advertise-client-urls http://${HostIP}:2379,http://${HostIP}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${HostIP}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://${HostIP}:2380 \
 -initial-cluster-state new
docker run --restart=always -d --link etcd -e DISC_ETCD=http://etcd:2379 \
 --name discovery -p 8087:8087 \
 -e DISC_HOST=http://172.17.0.1:8087 lmarsden/discovery.data-mesh.io
