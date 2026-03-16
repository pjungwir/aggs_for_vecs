# Debian Package Build Support

To setup to build for multiple Postgres releases:

```sh
sudo apt install debhelper

# Add Postgres Debian repository key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Add Debian repository
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
sudo apt update

# Install server support
sudo apt -y install \
  postgresql-9.6 postgresql-client-9.6 postgresql-server-dev-9.6 \
  postgresql-10 postgresql-client-10 postgresql-server-dev-10 \
  postgresql-11 postgresql-client-11 postgresql-server-dev-11 \
  postgresql-12 postgresql-client-12 postgresql-server-dev-12 \
  postgresql-13 postgresql-client-13 postgresql-server-dev-13
```

Then edit `/etc/postgresql-common/supported_versions` to replace contents with

```
pgdg
``` 

From that point you can build all supported packages with:

```sh
make deb
```
