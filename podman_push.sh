#!/bin/bash

set -e

# 支持传参自定义 TAG，如果没有传，默认 latest
TAG="${1:-latest}"
IMAGE_NAME="avey777/v-admin:$TAG"

echo "=== 准备推送镜像 ==="
echo "最新标签: $IMAGE_NAME"

# 检查镜像是否存在
LOCAL_IMAGE="localhost/avey777/v-admin:latest"
if ! podman image inspect "$LOCAL_IMAGE" > /dev/null 2>&1; then
    echo "错误: 镜像 $LOCAL_IMAGE 不存在"
    echo "请先构建镜像"
    exit 1
fi

# 加载环境变量文件
load_env() {
    local env_file=".env"
    echo "当前目录: $(pwd)"
    echo "检查环境变量文件: $env_file"

    if [[ -f "$env_file" ]]; then
        echo "找到环境变量文件: $env_file"

        # 安全地加载环境变量
        while IFS='=' read -r key value || [ -n "$key" ]; do
            # 跳过空行和注释
            if [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]]; then
                continue
            fi
            # 移除值中的引号
            value="${value%\"}"
            value="${value#\"}"
            value="${value%\'}"
            value="${value#\'}"
            # 导出变量
            export "$key"="$value"
            echo "已设置环境变量: $key=***"
        done < "$env_file"
        echo "环境变量加载完成"
    else
        echo "错误: 未找到环境变量文件 $env_file"
        exit 1
    fi
}

# 加载环境变量
load_env

# 使用正确的环境变量名称
DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME}"
DOCKER_HUB_ACCESS_TOKEN="${DOCKER_HUB_ACCESS_TOKEN}"

# 调试：检查环境变量是否设置成功
echo "=== 环境变量检查 ==="
echo "用户名: ${DOCKER_HUB_USERNAME:-未设置}"
echo "密码: ${DOCKER_HUB_ACCESS_TOKEN:+已设置（隐藏）}"

# 检查是否已登录到 Docker Hub
check_login() {
    podman login docker.io --get-login > /dev/null 2>&1
}

# 自动登录函数
auto_login() {
    echo "=== Docker Hub 自动登录 ==="

    if [[ -z "$DOCKER_HUB_ACCESS_TOKEN" ]]; then
        echo "错误: DOCKERHUB_PASSWORD 环境变量未设置"
        echo "请检查 .env 文件"
        exit 1
    fi

    if [[ -z "$DOCKER_HUB_USERNAME" ]]; then
        echo "错误: DOCKER_HUB_USERNAME 环境变量未设置"
        echo "请检查 .env 文件"
        exit 1
    fi

    echo "使用用户名: $DOCKER_HUB_USERNAME"
    echo "登录到 Docker Hub..."

    echo "$DOCKER_HUB_ACCESS_TOKEN" | podman login docker.io \
        -u "$DOCKER_HUB_USERNAME" \
        --password-stdin || {
        echo "Docker Hub 登录失败"
        echo "请检查："
        echo "1. 用户名和密码是否正确"
        echo "2. 是否使用了 Docker Hub 的访问令牌（而不是密码）"
        echo "3. 网络连接是否正常"
        exit 1
    }

    echo "登录成功"
}

# 检查并执行登录
if ! check_login; then
    auto_login
else
    CURRENT_USER=$(podman login docker.io --get-login 2>/dev/null)
    echo "已登录为: $CURRENT_USER"
fi

echo "=== 开始推送镜像 ==="

# 首先给镜像打标签（从 localhost 命名空间改为 Docker Hub 命名空间）
echo "重新标记镜像..."
podman tag "$LOCAL_IMAGE" "$IMAGE_NAME"

# 推送 latest 标签
echo "推送最新标签: $IMAGE_NAME"
podman push "$IMAGE_NAME" || {
    echo "推送失败: $IMAGE_NAME"
    exit 1
}

echo "=== 镜像推送成功 ==="
echo "镜像地址:"
echo " - docker.io/$IMAGE_NAME"

# 清理临时标签
echo "清理临时标签..."
podman untag "$LOCAL_IMAGE" "$IMAGE_NAME" 2>/dev/null || true

echo "=== 推送完成 ==="
