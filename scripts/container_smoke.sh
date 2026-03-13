#!/usr/bin/env bash
set -euo pipefail

container_name="${CONTAINER_NAME:-ansible-nginx-smoke}"
test_image="${TEST_IMAGE:-python:3.11-slim-bookworm}"
host_port="${TEST_PORT:-8080}"

cleanup() {
  docker rm -f "$container_name" >/dev/null 2>&1 || true
}

trap cleanup EXIT

docker rm -f "$container_name" >/dev/null 2>&1 || true

docker run -d \
  --name "$container_name" \
  -p "${host_port}:80" \
  -v "$PWD":/work \
  -w /work \
  "$test_image" \
  sleep infinity >/dev/null

docker exec "$container_name" bash -lc "
  set -euo pipefail
  apt-get update
  apt-get install -y curl
  python -m pip install --no-cache-dir ansible
"

docker exec "$container_name" bash -lc "
  set -euo pipefail
  cd /work
  ansible-playbook -i inventory/example playbook.yml \
    -e nginx_become=false \
    -e nginx_manage_service=false \
    -e ansible_python_interpreter=/usr/local/bin/python
"

second_run="$(docker exec "$container_name" bash -lc "
  set -euo pipefail
  cd /work
  ANSIBLE_FORCE_COLOR=0 ansible-playbook -i inventory/example playbook.yml \
    -e nginx_become=false \
    -e nginx_manage_service=false \
    -e ansible_python_interpreter=/usr/local/bin/python
")"

printf '%s\n' "$second_run"
grep -q "changed=0" <<<"$second_run"

docker exec "$container_name" bash -lc "nginx"
curl --fail --retry 10 --retry-delay 2 "http://127.0.0.1:${host_port}" | grep -q "Welcome from Ansible"
