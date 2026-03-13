# ansible-nginx-setup

Ansible Nginx role with a testable playbook workflow, container smoke test, and PR-focused CI checks.

## What this project does
- Installs Nginx with a reusable `roles/nginx` role.
- Deploys a custom landing page and a managed site config template.
- Uses OS-aware defaults so Debian and Red Hat families write to the correct docroot.
- Keeps service management optional for container-based tests.
- Verifies syntax, linting, idempotency, and a runtime HTTP check in CI.

## Repo map
```text
.
├── .ansible-lint                       # ansible-lint rules used locally and in CI
├── .github/workflows/ci.yml            # 4-stage pipeline: yamllint, ansible-lint, syntax-check, smoke
├── .gitkeep                            # placeholder file from the original repo
├── .yamllint                           # yamllint configuration
├── CHEATSHEET.md                       # quick Ansible commands and workflow notes
├── FILES_EXPLAINED.md                  # file-by-file explanation for the whole repo
├── inventory/example                   # localhost inventory for local runs and CI syntax checks
├── playbook.yml                        # playbook that applies the nginx role to the web group
├── README.md                           # setup, testing, CI, and PR flow guide
├── roles/nginx/defaults/main.yml       # user-tunable defaults for package, paths, and page content
├── roles/nginx/handlers/main.yml       # restart handler for config changes
├── roles/nginx/meta/main.yml           # role metadata and supported platforms
├── roles/nginx/tasks/main.yml          # package install, config templating, and service tasks
├── roles/nginx/templates/index.html.j2 # custom landing page template
├── roles/nginx/templates/site.conf.j2  # nginx server block template
├── roles/nginx/vars/main.yml           # platform-aware docroot, site config, and runtime user defaults
└── scripts/container_smoke.sh          # docker-based smoke and idempotency test
```

## Prerequisites
- Python 3.10+
- `ansible`, `ansible-lint`, and `yamllint`
- Docker for the smoke test

## Local run
```bash
ansible-playbook -i inventory/example playbook.yml
```

Then verify the page:

```bash
curl http://localhost
```

## Local validation
```bash
yamllint .
ansible-lint
ansible-playbook -i inventory/example playbook.yml --syntax-check
bash scripts/container_smoke.sh
```

## Idempotency
The smoke script runs the playbook twice in a disposable Docker container. The second run must report `changed=0`.

## Why the smoke test disables service management
Minimal Docker containers usually do not run `systemd`. The smoke test sets `nginx_manage_service=false`, starts `nginx` directly, and then curls the page. Normal host runs still use the default service management path.

## CI pipeline
`.github/workflows/ci.yml` defines 4 required jobs:
1. YAML lint
2. Ansible lint
3. Syntax check
4. Container smoke test with idempotency verification and `curl`

## Dev to main flow
- Create and update changes on `dev`.
- Open a pull request from `dev` into `main`.
- Mark all 4 CI jobs as required checks in GitHub branch protection before merging.
