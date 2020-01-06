# Alpine squid

A small image to run squid. It is based on the alpine image and actually only installs squid from the alpine packages and adds an entrypoint script to run squid on startup.

I created this image to run squid on my NAS, and I wanted to have a lightweight image to do so. With actualy 16.3 MB I think this has worked out well. I don't provide any Swarm or Compose config, which would be of no use on NAS.

Anyone is free to use the image as well, with no warranty at all.

The base for the image is Alpine https://hub.docker.com/_/alpine/, while the entrypoint script is a reduced version from the script provided by https://hub.docker.com/r/sameersbn/squid/, where the repo is at https://github.com/sameersbn/docker-squid . I also took parts of the README.md from there.

I appreciate any support on identified issues etc. via the github repo. Either submit an issue on https://github.com/Harald-Berghoff/alpine-squid/issues or send a pull request.

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/sameersbn/squid) and is the recommended method of installation.

```bash
docker pull haraldb/alpine-squid
```

Alternatively you can build the image yourself.

```bash
docker build -t haraldb/alpine-squid github.com/Harald-Berghoff/alpine-squid
```

## Quickstart

Start Squid using:

```bash
docker run --name squid -d --restart=always \
  --publish 3128:3128 \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  haraldb/alpine-squid
```

## Command-line arguments

You can customize the launch command of the Squid server by specifying arguments to `squid` on the `docker run` command. For example the following command prints the help menu of `squid` command:

```bash
docker run --name squid -it --rm \
  --publish 3128:3128 \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  haraldb/alpine-squid -h
```

## Persistence

For the cache to preserve its state across container shutdown and startup you should mount a volume at `/var/spool/squid`.

> *The [Quickstart](#quickstart) command already mounts a volume for persistence.*

SELinux users should update the security context of the host mountpoint so that it plays nicely with Docker:

```bash
mkdir -p /srv/docker/squid
chcon -Rt svirt_sandbox_file_t /srv/docker/squid
```

## Configuration

Squid is a full featured caching proxy server and a large number of configuration parameters. To configure Squid as per your requirements mount your custom configuration at `/etc/squid/squid.conf`.

```bash
docker run --name squid -d --restart=always \
  --publish 3128:3128 \
  --volume /path/to/squid.conf:/etc/squid/squid.conf \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  sameersbn/squid:3.5.27-2
```

To reload the Squid configuration on a running instance you can send the `HUP` signal to the container.

```bash
docker kill -s HUP squid
```
