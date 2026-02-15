# Ansible Nginx Cheatsheet

## What each main file/folder is for
- `playbook.yml`: Entry point; targets `web` hosts and calls role `nginx`.
- `inventory/example`: Example inventory for local execution.
- `roles/nginx/tasks/main.yml`: Main role logic (install package, deploy page, manage service).
- `roles/nginx/templates/index.html.j2`: HTML template rendered to the server.
- `roles/nginx/defaults/main.yml`: Default variables you can override.
- `roles/nginx/handlers/main.yml`: Service restart handler.
- `roles/nginx/meta/main.yml`: Role metadata for Ansible Galaxy and linting.
- `.yamllint`: Rules for YAML formatting checks.
- `.ansible-lint`: Rules/profile for ansible-lint.
- `.github/workflows/ci.yml`: CI jobs run on push/PR.

## Most useful commands
```bash
# Run the playbook locally
ansible-playbook -i inventory/example playbook.yml

# Syntax check only
ansible-playbook -i inventory/example playbook.yml --syntax-check

# Lint YAML files
yamllint .

# Lint Ansible content
ansible-lint

# Override page title/message at runtime
ansible-playbook -i inventory/example playbook.yml \
  -e 'nginx_page_title=Hello' \
  -e 'nginx_page_message=Configured via extra vars'

# Container-friendly run (skip service management)
ansible-playbook -i inventory/example playbook.yml -e nginx_manage_service=false
```
