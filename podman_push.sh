#!/bin/bash
set -e

# 支持传参自定义 TAG，如果没有传，默认 latest
TAG="${1:-latest}"
IMAGE_NAME="avey777/v-admin:$TAG"
LOCAL_IMAGE="localhost/avey777/v-admin:$TAG"

echo "=== 准备推送镜像 ==="
echo "最新标签: $IMAGE_NAME"

# 检查本地镜像
if ! podman image inspect "$LOCAL_IMAGE" > /dev/null 2>&1; then
    echo "错误: 镜像 $LOCAL_IMAGE 不存在，请先构建镜像"
    exit 1
fi

# -----------------------------
# 加载环境变量
# 优先使用环境变量，其次尝试加载本地 .env 文件
# -----------------------------
DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME:-}"
DOCKER_HUB_ACCESS_TOKEN="${DOCKER_HUB_ACCESS_TOKEN:-}"

if [[ -z "$DOCKER_HUB_USERNAME" || -z "$DOCKER_HUB_ACCESS_TOKEN" ]]; then
    ENV_FILE=".env"
    if [[ -f "$ENV_FILE" ]]; then
        echo "加载本地环境变量文件: $ENV_FILE"
        while IFS='=' read -r key value || [ -n "$key" ]; do
            # 跳过空行或注释
            [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
            # 去掉引号
            value="${value%\"}"
            value="${value#\"}"
            value="${value%\'}"
            value="${value#\'}"
            export "$key"="$value"
        done < "$ENV_FILE"

        # 重新读取
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
# 登录 Docker Hub
# -----------------------------
check_login() {
    podman login docker.io --get-login > /dev/null 2>&1
}

auto_login() {
    echo "=== Docker Hub 自动登录 ==="
    echo "$DOCKER_HUB_ACCESS_TOKEN" | podman login docker.io \
        -u "$DOCKER_HUB_USERNAME" \
        --password-stdin || {
        echo "Docker Hub 登录失败，请检查用户名/访问令牌或网络"
        exit 1
    }
    echo "登录成功"
}

if ! check_login; then
    auto_login
else
    CURRENT_USER=$(podman login docker.io --get-login 2>/dev/null)
    echo "已登录为: $CURRENT_USER"
fi

# -----------------------------
# 推送镜像
# -----------------------------
echo "=== 开始推送镜像 ==="

# 打标签
echo "重新标记镜像: $LOCAL_IMAGE -> $IMAGE_NAME"
podman tag "$LOCAL_IMAGE" "$IMAGE_NAME"

# 推送镜像
echo "推送镜像: $IMAGE_NAME"
podman push "$IMAGE_NAME" || {
    echo "推送失败: $IMAGE_NAME"
    exit 1
}

echo "镜像地址: docker.io/$IMAGE_NAME"
echo "=== 镜像推送成功 ==="
