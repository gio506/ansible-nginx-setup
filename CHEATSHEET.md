# Ansible Nginx Cheatsheet

## Install local tools
```bash
pip install ansible ansible-lint yamllint
```

## Run the playbook
```bash
ansible-playbook -i inventory/example playbook.yml
```

## Run without privilege escalation
```bash
ansible-playbook -i inventory/example playbook.yml -e nginx_become=false
```

## Container-friendly run
```bash
ansible-playbook -i inventory/example playbook.yml \
  -e nginx_become=false \
  -e nginx_manage_service=false
```

## Syntax and lint checks
```bash
yamllint .
ansible-lint
ansible-playbook -i inventory/example playbook.yml --syntax-check
```

## Smoke test
```bash
bash scripts/container_smoke.sh
```

## Git workflow
```bash
git switch dev
git pull origin main
git status
```

## Useful files
- `playbook.yml`: top-level play that applies `roles/nginx`.
- `roles/nginx/tasks/main.yml`: installs nginx and deploys the templates.
- `roles/nginx/templates/site.conf.j2`: nginx site configuration template.
- `scripts/container_smoke.sh`: repeatable runtime and idempotency check.
