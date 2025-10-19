#!/bin/bash

# 构建 v-admin 镜像
docker buildx build --no-cache --network=host --rm=true -f Dockerfile -t avey777/v-admin .
