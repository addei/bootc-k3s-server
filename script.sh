#!/bin/bash

B_DATE=$(date +%Y%m%d)

if [[ -z "$REGISTRY" ]]; then
    read -rp "Enter registry address: " REGISTRY
fi

podman login "$REGISTRY"

set -a
source k3s.env
set +a
podman build --platform linux/amd64 --jobs 1         --secret id=K3S_TOKEN,src=k3s_token.txt         --build-arg INSTALL_K3S_SKIP_DOWNLOAD="$INSTALL_K3S_SKIP_DOWNLOAD"         --build-arg INSTALL_K3S_SYMLINK="$INSTALL_K3S_SYMLINK"         --build-arg INSTALL_K3S_SKIP_ENABLE="$INSTALL_K3S_SKIP_ENABLE"         --build-arg INSTALL_K3S_SKIP_START="$INSTALL_K3S_SKIP_START"         --build-arg INSTALL_K3S_VERSION="$INSTALL_K3S_VERSION"         --build-arg INSTALL_K3S_BIN_DIR="$INSTALL_K3S_BIN_DIR"         --build-arg INSTALL_K3S_BIN_DIR_READ_ONLY="$INSTALL_K3S_BIN_DIR_READ_ONLY"         --build-arg INSTALL_K3S_SYSTEMD_DIR="$INSTALL_K3S_SYSTEMD_DIR"         --build-arg INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC"         --build-arg INSTALL_K3S_NAME="$INSTALL_K3S_NAME"         --build-arg INSTALL_K3S_TYPE="$INSTALL_K3S_TYPE"         --build-arg INSTALL_K3S_SELINUX_WARN="$INSTALL_K3S_SELINUX_WARN"         --build-arg INSTALL_K3S_SKIP_SELINUX_RPM="$INSTALL_K3S_SKIP_SELINUX_RPM"         --build-arg INSTALL_K3S_CHANNEL_URL="$INSTALL_K3S_CHANNEL_URL"         --build-arg INSTALL_K3S_CHANNEL="$INSTALL_K3S_CHANNEL"         --build-arg K3S_SELINUX="$K3S_SELINUX"         -t k3s-server:$B_DATE .
podman tag localhost/k3s-server:$B_DATE "$REGISTRY/bootc-images/k3s-server:$B_DATE"
podman push "$REGISTRY/bootc-images/k3s-server:$B_DATE"
podman tag "$REGISTRY/bootc-images/k3s-server:$B_DATE" "$REGISTRY/bootc-images/k3s-server:latest"
podman push "$REGISTRY/bootc-images/k3s-server:latest"
