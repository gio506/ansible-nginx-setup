# Ansible Nginx Setup — Ops Runbook

This playbook configures Nginx as a web server on target Linux VMs. This runbook documents real operational scenarios.

## Initial Setup

```bash
# 1. Test connectivity to all target hosts
ansible -i inventory/example web -m ping

# 2. Run syntax check before applying
ansible-playbook -i inventory/example playbook.yml --syntax-check

# 3. Dry-run (check mode)
ansible-playbook -i inventory/example playbook.yml --check --diff

# 4. Apply with verbose output
ansible-playbook -i inventory/example playbook.yml -v
```

---

## Common Scenarios

### SSL Certificate Renewal

When a certificate expires on a managed host:

```bash
# 1. Copy new cert to managed host
ansible -i inventory/example web -m copy \
  -a "src=/local/certs/site.crt dest=/etc/ssl/certs/site.crt owner=root mode=0644"

# 2. Reload nginx config without downtime
ansible -i inventory/example web -m service \
  -a "name=nginx state=reloaded"

# 3. Verify the new cert is served
ansible -i inventory/example web -m shell \
  -a "openssl s_client -connect localhost:443 </dev/null 2>/dev/null | openssl x509 -noout -dates"
```

### Vhost Troubleshooting

If a vhost returns 502 Bad Gateway:

```bash
# Check nginx error logs remotely
ansible -i inventory/example web -m shell \
  -a "tail -n 50 /var/log/nginx/error.log"

# Check nginx config syntax
ansible -i inventory/example web -m shell \
  -a "nginx -t"

# Check upstream connection from the server
ansible -i inventory/example web -m shell \
  -a "curl -v http://127.0.0.1:8080/health"
```

### Config Drift Detection

```bash
# See what changed before applying
ansible-playbook -i inventory/example playbook.yml --check --diff 2>&1 | grep -E "TASK|changed|diff"
```

---

## Rollback

If a deployment breaks the site:

```bash
# Redeploy with the previous known-good tag
git checkout v1.0.0
ansible-playbook -i inventory/example playbook.yml

# Or manually restore a backup config
ansible -i inventory/example web -m copy \
  -a "src=/backup/site.conf.bak dest=/etc/nginx/sites-available/site.conf"
ansible -i inventory/example web -m service \
  -a "name=nginx state=reloaded"
```

---

## Variable Override Reference

| Variable | Default | Override in |
|---|---|---|
| `nginx_package_name` | `nginx` | `roles/nginx/vars/` |
| `nginx_docroot` | `/var/www/html` | `roles/nginx/vars/` |
| `nginx_become` | `true` | inventory `host_vars` |
| `nginx_manage_service` | `true` | `group_vars/web.yml` |

---

## Troubleshooting Quick Reference

| Problem | Likely Cause | Resolution |
|---|---|---|
| `UNREACHABLE` | SSH key not accepted | Check `ansible_ssh_private_key_file` |
| `permission denied` | `become` not set | Set `nginx_become: true` or pass `--become` |
| Nginx fails to start | Config syntax error | Run `nginx -t` on host |
| Template not rendering | Jinja2 variable undefined | Verify all vars in `defaults/main.yml` |
