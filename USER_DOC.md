## Services

| Service   | Description                    | Port |
|-----------|--------------------------------|------|
| NGINX     | HTTPS reverse proxy            | 443  |
| WordPress | CMS with php-fpm               | —    |
| MariaDB   | Database                       | —    |

## Start / Stop

```bash
make        # build images and start all containers
make down   # stop all containers
make re     # stop and rebuild everything from scratch
make fclean # stop, remove all containers, images and data
```

## Access

- Website: https://paprzyby.42.fr
- Admin panel: https://paprzyby.42.fr/wp-admin

Accept the certificate warning in your browser — the TLS certificate is
self-signed.

## Credentials

Credentials are stored in `secrets/` on the host machine and are never
committed to Git. They must be recreated manually on each new machine.

| File                         | Contains                    |
|------------------------------|-----------------------------|
| secrets/credentials.txt      | WordPress admin user:pass   |
| secrets/db_password.txt      | MariaDB wp_user password    |
| secrets/db_root_password.txt | MariaDB root password       |

WordPress admin username: pprzyby2_wp
Second user username: john (role: author)

## Health Check

```bash
# Check all containers are running
docker ps

# Check logs of a specific container
docker logs nginx
docker logs wordpress
docker logs mariadb

# Test HTTPS connection
curl -k https://paprzyby.42.fr
```

All three containers should show status `Up` in `docker ps`.
