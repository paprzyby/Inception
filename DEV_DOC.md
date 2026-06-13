## Prerequisites

- Debian Bullseye VM
- Docker and docker-compose installed
- `paprzyby.42.fr` pointing to `127.0.0.1` in `/etc/hosts`

## Setup From Scratch

```bash
# 1. Clone the repository
git clone <repo_url> && cd inception

# 2. Create secrets — never committed to Git
mkdir -p secrets
echo "paprzyby_wp:StrongWpPass42!" > secrets/credentials.txt
echo "StrongDbPass42!"             > secrets/db_password.txt
echo "StrongRootPass42!"           > secrets/db_root_password.txt

# 3. Create .env
cp srcs/.env.example srcs/.env

# 4. Add domain to /etc/hosts
echo "127.0.0.1 paprzyby.42.fr" >> /etc/hosts

# 5. Build and start
make
```

## Useful Commands

```bash
# List running containers
docker ps

# Follow logs of all containers
docker-compose -f srcs/docker-compose.yml logs -f

# Shell into a container
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash

# Rebuild a single service
docker-compose -f srcs/docker-compose.yml build wordpress
docker-compose -f srcs/docker-compose.yml up -d --no-deps wordpress

# List volumes
docker volume ls

# Full reset
make fclean && make
```

## Data Locations

| Data            | Host path                       |
|-----------------|---------------------------------|
| WordPress files | /home/paprzyby/data/wordpress   |
| MariaDB data    | /home/paprzyby/data/mariadb     |

Both are named Docker volumes using a local bind driver. The data persists
across container restarts. Deleting these directories destroys all data.

## Secrets

Secrets are plain text files mounted by Docker at `/run/secrets/` inside
containers. They are read by the setup scripts with `cat /run/secrets/<name>`.
They must be recreated manually on each new machine — they are gitignored
and never leave the host.

## Network

All containers communicate over a Docker bridge network called `inception`.
Docker's internal DNS resolves service names automatically:
- NGINX reaches WordPress at `wordpress:9000`
- WordPress reaches MariaDB at `mariadb:3306`

No external ports are exposed except 443 on NGINX.
