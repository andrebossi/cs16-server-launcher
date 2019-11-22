# Counter-Strike 1.6 Server

[![GitHub](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/dobolinux/cs16-server-launcher.svg)](https://hub.docker.com/r/dobolinux/cs16-server-launcher)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/dobolinux/cs16-server-launcher.svg)](https://hub.docker.com/r/dobolinux/cs16-server-launcher/builds)

A Docker container for Counter-Strike 1.6 Server

## Getting Started

These instructions will cover usage information and for the Docker container.

### Prerequisites

In order to run this container you'll need [Docker](https://docs.docker.com/get-started/) installed.

### Installing

Pull the image from the Docker repository:

```sh
docker pull dobolinux/cs16-server-launcher
docker tag dobolinux/cs16-server-launcher cs16-server-launcher
docker rmi dobolinux/cs16-server-launcher
```

Or build image from source:

```sh
git clone https://github.com/dobolinux/cs16-server-launcher.git
cd cs16-server-launcher
docker build -t cs16-server-launcher .
```

## Documentation

* [Installation](https://github.com/dobolinux/cs16-server-launcher/wiki/Installation)
* [Configuration](https://github.com/dobolinux/cs16-server-launcher/wiki/Configuration)
