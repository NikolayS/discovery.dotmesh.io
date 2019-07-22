# Dev

```
./start-local.sh
```

# Prod

on initial upgrade to docker compose version:
```
docker rm -f etcd discovery traefik get
```

Start docker compose because nginx needs to be able to resolve the other containers, then rm the nginx container, then:

```
./init-letsencrypt.sh
```

Later, just:

```
docker-compose up -d
```
