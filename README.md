# ansible-nginx-setup

Beginner-friendly Ansible project that uses a reusable role (`roles/nginx`) to install and configure Nginx.

## What this project does
- Installs Nginx.
- Deploys a simple HTML landing page from a Jinja2 template.
- Enables and starts the Nginx service (optional in container tests).

## Project tree
```text
.
├── .ansible-lint                  # ansible-lint config used by CI and local linting
├── .github/
│   └── workflows/
│       └── ci.yml                 # 3-stage CI: YAML lint, ansible-lint, syntax-check
├── .yamllint                      # yamllint configuration
├── CHEATSHEET.md                  # quick command + file purpose reference
├── inventory/
│   └── example                    # sample inventory using localhost
├── playbook.yml                   # main playbook applying the nginx role to [web]
├── README.md                      # setup and usage guide
└── roles/
    └── nginx/
        ├── defaults/
        │   └── main.yml           # default variables (package, service, page content)
        ├── handlers/
        │   └── main.yml           # handler to restart nginx when template changes
        ├── meta/
        │   └── main.yml           # role metadata (platforms, min ansible version)
        ├── tasks/
        │   └── main.yml           # installs nginx, deploys template, manages service
        └── templates/
            └── index.html.j2      # Jinja2 HTML template for landing page
```

## Prerequisites
- Python 3.10+
- Ansible (`pip install ansible`)
- Optional local container test: Docker

## Quick start (localhost)
```bash
ansible-playbook -i inventory/example playbook.yml
```

Open `http://localhost` (or your VM/server IP) to check the page.

## Local checks
```bash
yamllint .
ansible-lint
ansible-playbook -i inventory/example playbook.yml --syntax-check
```

## Optional Docker-based local run
Useful when you do not want to touch your host machine.

```bash
docker run --rm -it -v "$PWD":/work -w /work ubuntu:22.04 bash
apt-get update && apt-get install -y python3 python3-pip
pip3 install ansible
ansible-playbook -i inventory/example playbook.yml -e nginx_manage_service=false
```

> Why `nginx_manage_service=false` in Docker? Minimal containers usually do not run `systemd`, so service tasks may fail.

## CI pipeline (GitHub Actions)
Defined in `.github/workflows/ci.yml` with 3 stages:
1. **YAML lint** (`yamllint` action)
2. **ansible-lint**
3. **syntax-check** (`ansible-playbook --syntax-check`)
