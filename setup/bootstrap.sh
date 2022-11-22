#!/bin/bash

# Used to install rsync for deployments
apt-get update -y
apt-get -y install rsync

# Install HEXO
npm install -g hexo
