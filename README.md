# Ark-MicroK8s

ARK: Survival Evolved via MicroK8s.

This project was inspired by [Cervator/KubicArk](https://github.com/Cervator/KubicArk), but I wanted something I could maintain myself and could run on my basement MicroK8s edge node (an old Dell R620).

What I'm running:
- Ubuntu 22.04.2 on a Dell R620 with 64GB of RAM, an SSD boot drive, and SSD ZFS pool for local storage (not documented in this repo)
- Using my own [nhalase/ark](https://github.com/nhalase/ark) Docker image because I wanted finer control over the image

## Getting started

If you don't want to use the default `ark` namespace, you can adjust the namespace in the [source.sh](./source.sh) file and kustomize will take care of things for you (note: you'll need kustomize installed).

You'll need to enable the MicroK8s addons: `ingress`, `dns`, and `hostpath-storage`.

1. Run [./generate-files.sh](./generate-files.sh) to get the secret files you need to start the server.
2. Fill out `AllowedCheaterSteamIDs.txt`, `PlayersExclusiveJoinList.txt`, `PlayersJoinNoCheck.txt`, and `ark-server-secrets.env`.
3. Run [./create-ns-and-auth.sh](./create-ns-and-auth.sh) (you only need to do this once).
4. Run [./start-server.sh "mapname"](./start-server.sh) to start the server. Valid names are names that match server directory names (e.g., "theisland").
5. You don't have to fill out `main.cfg`, but it will be volume mounted over `/etc/arkmanager/instances/main.cfg` regardless.

Note: after running [./start-server.sh "mapname"](./start-server.sh), the `build` directory will contain generated YAML manifests of what has been applied. This wasn't necessary, but included for spot-checking what was applied.

## ulimit adjustments

Edit `/var/snap/microk8s/current/args/containerd-env` on your MicroK8s node and adjust the `ulimit -n` value to `1000000`. There is NO way to do this in the container directly.

## Networking

If your MicroK8s does not have a public IP, port forward the service nodePorts as follows:

- client port as UDP
- server port as UDP
- steam query port as UDP
- rcon port as TCP

### Updating the `ingress` plugin

1. Edit the nginx-tcp configmap: `microk8s kubectl -n ingress edit cm nginx-ingress-tcp-microk8s-conf`. Add a `data` entry for each server:

```yaml
# example
data:
  "32003": ark/theisland:32003
```

2. Edit the nginx-udp configmap: `microk8s kubectl -n ingress edit cm nginx-ingress-udp-microk8s-conf`. Add a `data` entry for each server:

```yaml
# example
data:
  "32000": ark/theisland:32000
  "32001": ark/theisland:32001
  "32002": ark/theisland:32002
```

3. Edit the nginx daemonset: `microk8s kubectl -n ingress edit ds nginx-ingress-microk8s-controller`. Add a `port` entry for each server:

```yaml
# example
- containerPort: 32000
  hostPort: 32000
  name: udp-32000
  protocol: UDP
- containerPort: 32001
  hostPort: 32001
  name: udp-32001
  protocol: UDP
- containerPort: 32002
  hostPort: 32002
  name: udp-32002
  protocol: UDP
- containerPort: 32003
  hostPort: 32003
  name: tcp-32003
  protocol: TCP
```
