- [1. Counter-Strike 1.6 Server](#1-counter-strike-16-server)
  - [1.1. Getting Started](#11-getting-started)
    - [1.1.1. Prerequisites](#111-prerequisites)
    - [1.1.2. Installing](#112-installing)
  - [1.2. Documentation](#12-documentation)

# 1. Counter-Strike 1.6 Server

[![GitHub](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub Workflow Status](https://github.com/andrebossi/cs16-server-launcher/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/andrebossi/cs16-server-launcher/actions/workflows/docker-publish.yml)

A Docker container for Counter-Strike 1.6 Server

## 1.1. Getting Started

These instructions will cover usage information and for the Docker container.

### 1.1.1. Prerequisites

In order to run this container you'll need [Docker](https://docs.docker.com/get-started/) installed.

### 1.1.2. Installing

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

## 1.2. Documentation

* [Installation](https://github.com/dobolinux/cs16-server-launcher/wiki/Installation)
* [Configuration](https://github.com/dobolinux/cs16-server-launcher/wiki/Configuration)
