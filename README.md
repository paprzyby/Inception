*This project has been created as part of the 42 curriculum by paprzyby.*

"Inception"

## Description

Inception is a system administration project that sets up a small infrastructure
using Docker and Docker Compose inside a Virtual Machine. It consists of three
services running in dedicated containers: NGINX as the sole HTTPS entry point,
WordPress with php-fpm as the CMS, and MariaDB as the database. All containers
are connected via a Docker bridge network with persistent named volumes for data
storage.

### Docker usage
Each service has its own Dockerfile built from debian:bookworm. No pre-built
images are used except the base OS. Docker Compose orchestrates the three
containers, their volumes, network, and secrets.

### Design choices

**Virtual Machines vs Docker**
VMs virtualize hardware with a full OS per instance — higher isolation but heavy
resource usage. Docker virtualizes at the OS level using the host kernel — lightweight,
fast, and portable. This project runs Docker inside a VM to satisfy both requirements.

**Secrets vs Environment Variables**
Environment variables are used for non-sensitive configuration (domain name, database
name, usernames). Docker secrets are used for passwords — they are mounted as files
at /run/secrets/ inside containers and never appear in image layers or docker inspect.

**Docker Network vs Host Network**
A Docker bridge network isolates containers from the host while allowing inter-container
communication via service name DNS (e.g. wordpress:9000, mariadb:3306). Host network
removes that isolation and is forbidden by the project rules.

**Docker Volumes vs Bind Mounts**
Named volumes are managed by Docker and portable across environments. Bind mounts
directly expose a host path into a container. Named volumes are required by the subject
for the two persistent storages (WordPress files and MariaDB data).

## Instructions

```bash
# Clone the repo
git clone <repo_url> && cd inception

# Create secrets (do this on every new machine — never committed to git)
mkdir -p secrets
echo "paprzyby_wp:StrongWpPass42!" > secrets/credentials.txt
echo "StrongDbPass42!"             > secrets/db_password.txt
echo "StrongRootPass42!"           > secrets/db_root_password.txt

# Create .env (no passwords here — those go in secrets/)
cat > srcs/.env << 'EOF'
DOMAIN_NAME=paprzyby.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
WP_TITLE=Inception
WP_ADMIN_EMAIL=paprzyby@student.42heilbronn.de
WP_USER=john
WP_USER_PASS=JohnPass42!
WP_USER_EMAIL=john@paprzyby.42.fr
EOF

# Add domain to /etc/hosts
echo "127.0.0.1 paprzyby.42.fr" >> /etc/hosts

# Build and start
make
```

Site: https://paprzyby.42.fr
Admin panel: https://paprzyby.42.fr/wp-admin

## Resources

- https://docs.docker.com/
- https://nginx.org/en/docs/
- https://wp-cli.org/
- https://mariadb.com/kb/en/
- https://www.php.net/manual/en/install.fpm.configuration.php
- https://docs.docker.com/engine/swarm/secrets/

**AI usage:** Claude (claude.ai) was used to assist with writing the documentation files
(README.md, USER_DOC.md, DEV_DOC.md)
