# Ansible Nginx Cheatsheet

A practical quick-reference for this repository.

## What each main file/folder is for
- `playbook.yml`: Main entry point; targets hosts in group `web` and applies role `nginx`.
- `inventory/example`: Example inventory for localhost testing.
- `roles/nginx/tasks/main.yml`: Role tasks (install package, deploy page, manage service).
- `roles/nginx/templates/index.html.j2`: HTML template rendered on target host.
- `roles/nginx/defaults/main.yml`: Default variables (safe to override).
- `roles/nginx/handlers/main.yml`: Handler to restart Nginx on template change.
- `roles/nginx/meta/main.yml`: Role metadata (platform/min version).
- `.yamllint`: YAML formatting/lint rules.
- `.ansible-lint`: ansible-lint profile and excluded paths.
- `.github/workflows/ci.yml`: 3 CI stages (YAML lint, ansible-lint, syntax-check).

## Core commands
```bash
# Run playbook
ansible-playbook -i inventory/example playbook.yml

# Show what would change (dry-run)
ansible-playbook -i inventory/example playbook.yml --check

# Show detailed task output
ansible-playbook -i inventory/example playbook.yml -vv

# Syntax check only
ansible-playbook -i inventory/example playbook.yml --syntax-check

# List hosts from inventory
ansible-inventory -i inventory/example --list

# Ping target hosts
ansible -i inventory/example web -m ping
```

## Lint and quality
```bash
# Lint all YAML files
yamllint .

# Lint Ansible role/playbook
ansible-lint

# Combined local validation
yamllint . && ansible-lint && ansible-playbook -i inventory/example playbook.yml --syntax-check
```

## Useful overrides (extra vars)
```bash
# Change page title/message
ansible-playbook -i inventory/example playbook.yml \
  -e 'nginx_page_title=Hello from Ansible' \
  -e 'nginx_page_message=This page is managed by a role'

# Disable service management (good for minimal containers)
ansible-playbook -i inventory/example playbook.yml -e nginx_manage_service=false

# Change output file path
ansible-playbook -i inventory/example playbook.yml -e nginx_index_path=/usr/share/nginx/html/index.html
```

## Beginner tips
- Start with `--syntax-check` before a full run.
- Use `--check` to preview changes safely.
- Keep variables in `defaults/main.yml` for easy overrides.
- When testing in containers without `systemd`, set `nginx_manage_service=false`.
