# Dev

```
./start-local.sh
```

# Prod

on initial upgrade to docker compose version:
```
docker rm -f etcd discovery traefik get
```

```
./init-letsencrypt.sh
```

```
docker-compose up -d
```
