#!/bin/bash

# 安全清理：仅清除容器缓存，不触及镜像
podman container prune -f &>/dev/null
podman buildah rm -a &>/dev/null
rm -rf /run/user/1000/containers/*

# 一次性命令，带缓存清理
podman build --no-cache --network=host --rm=true --tmpdir=/tmp/podman-tmp -f Containerfile -t avey777/v-admin || {
    echo "构建失败，执行清理..."
    buildah rm -a
    podman image prune -f
    exit 1
}

# 独立清理临时镜像/悬空镜像（无论构建成功/失败都执行）
podman image prune -f
