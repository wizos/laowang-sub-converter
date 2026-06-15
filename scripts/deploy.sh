#!/usr/bin/env bash
set -Eeuo pipefail

APP_NAME="${APP_NAME:-laowang-sub-converter}"
IMAGE="${IMAGE:-ghcr.io/tony-wang1990/laowang-sub-converter:latest}"
INSTALL_DIR="${INSTALL_DIR:-/opt/${APP_NAME}}"
PORT="${PORT:-3000}"
DATA_DIR="${DATA_DIR:-${INSTALL_DIR}/data}"
ALLOW_PRIVATE_SUBSCRIPTION_URLS="${ALLOW_PRIVATE_SUBSCRIPTION_URLS:-0}"
ACTION="${1:-install}"

log() {
  printf '\033[1;32m[deploy]\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33m[warn]\033[0m %s\n' "$*"
}

fail() {
  printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2
  exit 1
}

need_root() {
  if [ "$(id -u)" -ne 0 ]; then
    fail "Please run as root, for example: curl -fsSL <url> | sudo bash"
  fi
}

install_docker() {
  if command -v docker >/dev/null 2>&1; then
    return
  fi

  need_root
  log "Docker is not installed. Installing Docker Engine..."

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://get.docker.com | sh
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- https://get.docker.com | sh
  else
    fail "curl or wget is required to install Docker"
  fi

  systemctl enable --now docker >/dev/null 2>&1 || service docker start >/dev/null 2>&1 || true
}

compose_cmd() {
  if docker compose version >/dev/null 2>&1; then
    echo "docker compose"
    return
  fi

  if command -v docker-compose >/dev/null 2>&1; then
    echo "docker-compose"
    return
  fi

  fail "Docker Compose is not available. Please install Docker Compose plugin."
}

write_compose() {
  need_root
  mkdir -p "$INSTALL_DIR" "$DATA_DIR"

  cat >"${INSTALL_DIR}/docker-compose.yml" <<EOF
services:
  ${APP_NAME}:
    image: ${IMAGE}
    container_name: ${APP_NAME}
    environment:
      NODE_ENV: production
      PORT: 3000
      DATA_DIR: /app/data
      ALLOW_PRIVATE_SUBSCRIPTION_URLS: "${ALLOW_PRIVATE_SUBSCRIPTION_URLS}"
    ports:
      - "${PORT}:3000"
    volumes:
      - "${DATA_DIR}:/app/data"
    restart: unless-stopped
EOF
}

remove_conflicting_container() {
  local container_id
  container_id="$(docker ps -aq --filter "name=^/${APP_NAME}$" | head -n 1 || true)"

  if [ -z "$container_id" ]; then
    return
  fi

  warn "Removing existing container with the same name: ${APP_NAME} (${container_id})"
  docker rm -f "$container_id" >/dev/null
}

wait_for_health() {
  local url="http://127.0.0.1:${PORT}/healthz"
  for _ in $(seq 1 30); do
    if command -v curl >/dev/null 2>&1 && curl -fsS "$url" >/dev/null 2>&1; then
      log "Health check passed: ${url}"
      return
    fi
    if command -v wget >/dev/null 2>&1 && wget -qO- "$url" >/dev/null 2>&1; then
      log "Health check passed: ${url}"
      return
    fi
    sleep 2
  done
  warn "Container started, but health check did not pass yet. Check logs with: $0 logs"
}

install_or_update() {
  install_docker
  local compose
  compose="$(compose_cmd)"

  write_compose
  log "Using image: ${IMAGE}"
  log "Install dir: ${INSTALL_DIR}"
  log "Data dir: ${DATA_DIR}"

  cd "$INSTALL_DIR"
  $compose pull
  remove_conflicting_container
  $compose up -d
  wait_for_health

  log "Done. Open: http://YOUR_SERVER_IP:${PORT}"
}

status_app() {
  install_docker
  local compose
  compose="$(compose_cmd)"
  if [ ! -f "${INSTALL_DIR}/docker-compose.yml" ]; then
    fail "No installation found at ${INSTALL_DIR}. Run install first."
  fi
  cd "$INSTALL_DIR"
  $compose ps
}

logs_app() {
  install_docker
  local compose
  compose="$(compose_cmd)"
  if [ ! -f "${INSTALL_DIR}/docker-compose.yml" ]; then
    fail "No installation found at ${INSTALL_DIR}. Run install first."
  fi
  cd "$INSTALL_DIR"
  $compose logs -f --tail=200
}

uninstall_app() {
  need_root
  install_docker
  local compose
  compose="$(compose_cmd)"

  if [ -f "${INSTALL_DIR}/docker-compose.yml" ]; then
    cd "$INSTALL_DIR"
    $compose down
  fi
  remove_conflicting_container

  warn "App stopped. Data is kept at: ${DATA_DIR}"
  warn "Remove data manually if needed: rm -rf ${INSTALL_DIR}"
}

case "$ACTION" in
  install|update|up)
    install_or_update
    ;;
  status)
    status_app
    ;;
  logs)
    logs_app
    ;;
  uninstall|remove)
    uninstall_app
    ;;
  *)
    cat <<EOF
Usage:
  $0 [install|update|status|logs|uninstall]

Environment variables:
  PORT=3000
  INSTALL_DIR=/opt/laowang-sub-converter
  DATA_DIR=/opt/laowang-sub-converter/data
  IMAGE=ghcr.io/tony-wang1990/laowang-sub-converter:latest
  ALLOW_PRIVATE_SUBSCRIPTION_URLS=0
EOF
    exit 1
    ;;
esac
