# nasqueron/openfire:4.7.5

- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
  - [Announcements](../../issues/1)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  - [Persistence](#persistence)
  - [Logs](#logs)
- [References](#references)

# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image for [Openfire](http://www.igniterealtime.org/projects/openfire/).

Openfire is a real time collaboration (RTC) server licensed under the Open Source Apache License. It uses the only widely adopted open protocol for instant messaging, XMPP (also called Jabber). Openfire is incredibly easy to setup and administer, but offers rock-solid security and performance.

This image lineage is:
1. [nasqueron/openfire](https://github.com/nasqueron/docker-openfire), *fork of*
1. [gizmotronic/openfire](https://github.com/gizmotronic/docker-openfire), *fork of*
1. [sameersbn/docker-openfire](https://github.com/sameersbn/docker-openfire)


## Contributing

If you find this image useful here's how you can help:

- Send a pull request with your awesome features and bug fixes
- Help users resolve their [issues](../../issues?q=is%3Aopen+is%3Aissue).

## Other issues

Before reporting a bug please try updating Docker to the latest version and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) for instructions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

If the above recommendations do not help then [report your issue](../../issues/new) along with the following information:

- Output of the `docker version` and `docker info` commands
- The `docker run` command or `docker-compose.yml` used to start the image. Mask out the sensitive bits.
- Please state if you are using [Boot2Docker](http://www.boot2docker.io), [VirtualBox](https://www.virtualbox.org), etc.

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/nasqueron/openfire) and is the recommended method of installation.

```bash
docker pull sjrobinsonconsulting/openfire:`cat VERSION`
```

Alternatively you can build the image yourself.

```bash
docker build -t sjrobinsonconsulting/openfire:`cat VERSION` .
```

## Quickstart

Start Openfire using:

``` bash
docker run -it --rm  -p 3478:3478/tcp -p 3479:3479/tcp -p 5222:5222/tcp -p 5223:5223/tcp -p 5229:5229/tcp -p 5262:5262/tcp -p 5263:5263/tcp -p 5275:5275/tcp -p 5276:5276/tcp -p 7070:7070/tcp -p 7443:7443/tcp -p 7777:7777/tcp -p 9090:9090/tcp -p 9091:9091/tcp -p 5005:5005/tcp -v /srv/docker/openfire/syslog:/var/log -v /srv/docker/openfire/newcerts:/var/lib/openfire/resources/security/hotdeploy -v /srv/docker/openfire/logs:/var/lib/openfire/logs sjrobinsonconsulting/openfire:`cat VERSION`
```

*Alternatively, you can use the sample [docker-compose.yml](docker-compose.yml) file to start the container using [Docker Compose](https://docs.docker.com/compose/)*

Point your browser to http://localhost:9090 and follow the setup procedure to complete the installation. The [Build A Free Jabber Server In 10 Minutes](https://www.youtube.com/watch?v=ytUB5qJm5HE#t=246s) video by HAKK5 should help you with the configuration and also introduce you to some of its features.

## Persistence

> *The [Quickstart](#quickstart) command already mounts a volume for persistence.*

SELinux users should update the security context of the host mountpoint so that it plays nicely with Docker:

```bash
mkdir -p /srv/docker/openfire
chcon -Rt svirt_sandbox_file_t /srv/docker/openfire
```

## Java VM options

Based on `OPENFIRE_OPTS` in section *A Word About Garbage Collection* at [Hazelcast Clustering Plugin Readme](https://igniterealtime.org/projects/openfire/plugin-archive.jsp?plugin=hazelcast).

```bash
JAVA_OPTS="-Xmx4G -Xms4G -XX:NewRatio=1 -XX:SurvivorRatio=4 -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:CMSFullGCsBeforeCompaction=1 -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly"
```

## Logs

To access the Openfire logs, located at `/var/log/openfire`, you can use `docker exec`. For example, if you want to tail the logs:

```bash
docker exec -it openfire tail -F /var/log/openfire/info.log
```

# Maintenance

## Upgrading

To upgrade to newer releases:

  1. Download the updated Docker image:

  ```bash
  docker pull sjrobinsonconsulting/openfire:wood-dragon.1
  ```

  2. Stop the currently running image:

  ```bash
  docker stop openfire
  ```

  3. Remove the stopped container

  ```bash
  docker rm -v openfire
  ```

  4. Start the updated image

  ```bash
  docker run -name openfire -d \
    [OPTIONS] \
    sjrobinsonconsulting/openfire:wood-dragon.1
  ```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it openfire sh
```

# References

  * http://www.igniterealtime.org/projects/openfire/
  * https://library.linode.com/communications/xmpp/openfire/ubuntu-12.04-precise-pangolin
