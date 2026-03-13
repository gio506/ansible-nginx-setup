# Files Explained

- `.ansible-lint`: keeps linting rules consistent between local runs and CI.
- `.github/workflows/ci.yml`: runs the 4 validation stages required before merge.
- `.gitkeep`: placeholder file retained from the original starter repository.
- `.yamllint`: sets the YAML lint policy for playbooks and workflow files.
- `CHEATSHEET.md`: short command reference for local work.
- `FILES_EXPLAINED.md`: quick description of every tracked file.
- `inventory/example`: localhost inventory for syntax and smoke tests.
- `playbook.yml`: applies the `nginx` role to the `web` host group.
- `README.md`: main documentation, repo map, run steps, and PR flow.
- `roles/nginx/defaults/main.yml`: default paths, page content, and service options.
- `roles/nginx/handlers/main.yml`: restarts nginx after config changes when service management is enabled.
- `roles/nginx/meta/main.yml`: role metadata and supported platforms.
- `roles/nginx/tasks/main.yml`: package installation, config templating, and service tasks.
- `roles/nginx/templates/index.html.j2`: custom HTML landing page.
- `roles/nginx/templates/site.conf.j2`: server block config for nginx.
- `roles/nginx/vars/main.yml`: platform-aware runtime user mapping.
- `scripts/container_smoke.sh`: disposable Docker-based smoke test with an idempotency check.
