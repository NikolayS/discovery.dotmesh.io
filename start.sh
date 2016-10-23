#!/bin/bash
docker build -t lmarsden/discovery.data-mesh.io .
HostIP=localhost
docker run -d -v /usr/share/ca-certificates/:/etc/ssl/certs \
 --name etcd quay.io/coreos/etcd \
 etcd -name etcd0 \
 -advertise-client-urls http://${HostIP}:2379,http://${HostIP}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${HostIP}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://${HostIP}:2380 \
 -initial-cluster-state new
docker run -d --link etcd -p 80:8087 -e DISC_ETCD=http://etcd0:2379 \
 --name discovery \
 -e DISC_HOST=http://discovery.data-mesh.io lmarsden/discovery.data-mesh.io
