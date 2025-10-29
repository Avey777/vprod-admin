#!/bin/bash
set -e

# 支持传参自定义 TAG，如果没有传，默认 latest
TAG="${1:-latest}"
IMAGE_NAME="avey777/v-admin:$TAG"

echo "=== 准备推送镜像 ==="
echo "最新标签: $IMAGE_NAME"

# 检查镜像是否存在
if ! docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    echo "错误: 镜像 $IMAGE_NAME 不存在，请先构建镜像"
    exit 1
fi

# -----------------------------
# 加载环境变量文件
# -----------------------------
load_env() {
    local env_file=".env"
    if [[ -f "$env_file" ]]; then
        echo "加载环境变量文件: $env_file"
        while IFS='=' read -r key value || [ -n "$key" ]; do
            [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
            value="${value%\"}"
            value="${value#\"}"
            value="${value%\'}"
            value="${value#\'}"
            export "$key"="$value"
        done < "$env_file"
        echo "环境变量加载完成"
    else
        echo "警告: 未找到环境变量文件 $env_file"
    fi
}

load_env

# -----------------------------
# 强制登录 Docker Hub
# -----------------------------
LOGIN_REGISTRY="docker.io"

echo "=== 强制登录 Docker Hub ==="

# 从环境变量获取凭证
DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME:-avey777}"
DOCKER_HUB_ACCESS_TOKEN="${DOCKER_HUB_ACCESS_TOKEN}"

if [[ -z "$DOCKER_HUB_ACCESS_TOKEN" ]]; then
    echo "错误: DOCKER_HUB_ACCESS_TOKEN 环境变量未设置"
    exit 1
fi

# 执行登录，覆盖可能已有的 session
echo "$DOCKER_HUB_ACCESS_TOKEN" | docker login "$LOGIN_REGISTRY" \
    -u "$DOCKER_HUB_USERNAME" \
    --password-stdin || {
    echo "Docker Hub 登录失败"
    exit 1
}

CURRENT_USER=$(docker login "$LOGIN_REGISTRY" --get-login 2>/dev/null)
echo "已登录为: $CURRENT_USER"

# -----------------------------
# 推送镜像
# -----------------------------
echo "=== 开始推送镜像 ==="
echo "推送最新标签: $IMAGE_NAME"
docker push "$IMAGE_NAME" || {
    echo "推送失败: $IMAGE_NAME"
    exit 1
}

echo "=== 镜像推送成功 ==="
echo "镜像地址: docker.io/$IMAGE_NAME"
echo "=== 推送完成 ==="
