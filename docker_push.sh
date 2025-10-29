#!/bin/bash
set -e

# -----------------------------
# 参数和镜像名称
# -----------------------------
TAG="${1:-latest}"
IMAGE_NAME="avey777/v-admin:$TAG"
LOCAL_IMAGE="$IMAGE_NAME"

echo "=== 准备推送镜像 ==="
echo "最新标签: $IMAGE_NAME"

# -----------------------------
# 检查本地镜像
# -----------------------------
if ! docker image inspect "$LOCAL_IMAGE" > /dev/null 2>&1; then
    echo "错误: 镜像 $LOCAL_IMAGE 不存在，请先构建镜像"
    exit 1
fi

# -----------------------------
# 加载环境变量
# -----------------------------
DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME:-}"
DOCKER_HUB_ACCESS_TOKEN="${DOCKER_HUB_ACCESS_TOKEN:-}"

if [[ -z "$DOCKER_HUB_USERNAME" || -z "$DOCKER_HUB_ACCESS_TOKEN" ]]; then
    ENV_FILE=".env"
    if [[ -f "$ENV_FILE" ]]; then
        echo "加载本地环境变量文件: $ENV_FILE"
        while IFS='=' read -r key value || [ -n "$key" ]; do
            [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
            value="${value%\"}"
            value="${value#\"}"
            value="${value%\'}"
            value="${value#\'}"
            export "$key"="$value"
        done < "$ENV_FILE"
        DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME}"
        DOCKER_HUB_ACCESS_TOKEN="${DOCKER_HUB_ACCESS_TOKEN}"
    else
        echo "错误: 未找到环境变量文件 $ENV_FILE，且环境变量未设置"
        exit 1
    fi
fi

# -----------------------------
# 调试信息
# -----------------------------
echo "=== 环境变量检查 ==="
echo "用户名: ${DOCKER_HUB_USERNAME:-未设置}"
echo "密码: ${DOCKER_HUB_ACCESS_TOKEN:+已设置（隐藏）}"

# -----------------------------
# 登录 Docker Hub (docker)
# -----------------------------
LOGIN_REGISTRY="https://index.docker.io/v1/"

echo "=== 强制登录 Docker Hub ==="
echo "$DOCKER_HUB_ACCESS_TOKEN" | docker login "$LOGIN_REGISTRY" \
    -u "$DOCKER_HUB_USERNAME" \
    --password-stdin || {
    echo "Docker Hub 登录失败，请检查用户名/访问令牌或网络"
    exit 1
}

# 确认登录用户
CURRENT_USER=$(docker login "$LOGIN_REGISTRY" --get-login 2>/dev/null)
echo "已登录为: $CURRENT_USER"

# -----------------------------
# 推送镜像
# -----------------------------
echo "=== 开始推送镜像 ==="
echo "重新标记镜像: $LOCAL_IMAGE -> $IMAGE_NAME"
docker tag "$LOCAL_IMAGE" "$IMAGE_NAME"

echo "推送镜像: $IMAGE_NAME"
docker push "$IMAGE_NAME" || {
    echo "推送失败: $IMAGE_NAME"
    echo "请检查 Docker Hub 用户名、Access Token 权限（需包含 Write 权限）及镜像命名空间是否匹配"
    exit 1
}

echo "镜像地址: docker.io/$IMAGE_NAME"
echo "=== 镜像推送成功 ==="
