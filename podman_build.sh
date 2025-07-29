# 一次性命令，带缓存清理
podman build --no-cache --network=host -f Containerfile-podman -t avey777/v-admin || {
    echo "构建失败，执行清理..."
    buildah rm -a
    podman image prune -f
}
