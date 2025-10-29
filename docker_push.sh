#!/bin/bash

set -e

# 支持传参自定义 TAG，如果没有传，默认 latest
TAG="${1:-latest}"
IMAGE_NAME="avey777/v-admin:$TAG"

echo "=== 准备推送镜像 ==="
# echo "镜像标签: $TAG"
echo "最新标签: $IMAGE_NAME"

# 检查镜像是否存在
if ! docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    echo "错误: 镜像 $IMAGE_NAME 不存在"
    echo "请先构建镜像"
    exit 1
fi


# 加载环境变量文件
load_env() {
    local env_file=".env"
    if [[ -f "$env_file" ]]; then
        echo "加载环境变量文件: $env_file"
        # 安全地加载环境变量，避免执行代码
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
        done < "$env_file"
        echo "环境变量加载完成"
    else
        echo "警告: 未找到环境变量文件 $env_file"
    fi
}

# 加载环境变量
load_env

# 检查是否已登录
check_login() {
    docker login docker.io --get-login > /dev/null 2>&1
}

# 自动登录函数
auto_login() {
    echo "=== Docker Hub 自动登录 ==="

    # 从环境变量获取凭证
    DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME:-avey777}"
    DOCKER_HUB_ACCESS_TOKEN="${DOCKER_HUB_ACCESS_TOKEN}"

    if [[ -z "$DOCKER_HUB_ACCESS_TOKEN" ]]; then
        echo "错误: DOCKER_HUB_ACCESS_TOKEN 环境变量未设置"
        echo "请检查 .env 文件或设置: export DOCKER_HUB_ACCESS_TOKEN='your_api_token'"
        echo "或手动执行: docker login docker.io"
        exit 1
    fi

    echo "使用用户名: $DOCKER_HUB_USERNAME"
    echo "$DOCKER_HUB_ACCESS_TOKEN" | docker login docker.io \
        -u "$DOCKER_HUB_USERNAME" \
        --password-stdin || {
        echo "Docker Hub 登录失败"
        exit 1
    }

    echo "登录成功"
}

# 检查并执行登录
if ! check_login; then
    auto_login
else
    CURRENT_USER=$(docker login docker.io --get-login 2>/dev/null)
    echo "已登录为: $CURRENT_USER"
fi

echo "=== 开始推送镜像 ==="

# 推送 latest 标签
echo "推送最新标签: $IMAGE_NAME"
docker push "$IMAGE_NAME" || {
    echo "推送失败: $IMAGE_NAME"
    exit 1
}

echo "=== 镜像推送成功 ==="
echo "镜像地址:"
echo " - docker.io/$IMAGE_NAME"

echo "=== 推送完成 ==="
