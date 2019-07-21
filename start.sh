#!/usr/bin/env bash
docker build -t quay.io/dotmesh/discovery.dotmesh.io .
HostIP=localhost
docker rm -f etcd discovery traefik get
docker run --restart=always -d -v /usr/share/ca-certificates/:/etc/ssl/certs \
 -v /pool/etcd-data:/var/lib/etcd \
 --name etcd \
 quay.io/coreos/etcd:v2.3.8 \
 -name etcd0 \
 -data-dir /var/lib/etcd \
 -advertise-client-urls http://${HostIP}:2379,http://${HostIP}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${HostIP}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://${HostIP}:2380 \
 -initial-cluster-state new
docker run --restart=always -d --link etcd -e DISC_ETCD=http://etcd:2379 \
 --name discovery \
 -e DISC_HOST=https://discovery.dotmesh.io quay.io/dotmesh/discovery.dotmesh.io
docker run --restart=always --name get -v /pool/releases:/usr/share/nginx/html:ro --label traefik.port=80 -d nginx
docker run --restart=always --name traefik -d --link discovery --link get -p 8080:8080 -p 80:80 -p 443:443 \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v $PWD/traefik.toml:/etc/traefik/traefik.toml -v $PWD/acme.json:/acme.json traefik:v1.7.12
