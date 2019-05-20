# discovery.dotmesh.io [![Build Status](https://drone.app.cloud.dotscience.net/api/badges/dotmesh-io/discovery.dotmesh.io/status.svg)](https://drone.app.cloud.dotscience.net/dotmesh-io/discovery.dotmesh.io)

This is a modified fork of https://github.com/coreos/discovery.etcd.io

# Configuration

The service has three configuration options, and can be configured with either
runtime arguments or environment variables.

* `--addr` / `DISC_ADDR`: the address to run the service on, including port.
* `--host` / `DISC_HOST`: the host url to prepend to `/new` requests.
* `--etcd` / `DISC_ETCD`: the url of the etcd endpoint backing the instance.

## Docker Container

You may run the service in a docker container:

```
docker pull quay.io/dotmesh/discovery
docker run -d -p 80:8087 -e DISC_ETCD=http://etcd.example.com:2379 -e DISC_HOST=http://discovery.example.com quay.io/dotmesh/discovery
```

## Development

discovery.etcd.io uses devweb for easy development. It is simple to get started:

```
./devweb
curl --verbose -X PUT localhost:8087/new
```
