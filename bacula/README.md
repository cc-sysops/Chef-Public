# Description

Tested on Ubuntu 12.04 server (should also work on Debian - please report!)

Supports File backup on a dedicated storage server with a single bacula director and multiple clients to be backed up.

Painlessly autoconfigures itself and the Jobs to be done.
Backs up daily incremental, full weekly. (see usage)
Also supports installation of bacula console to observe your backup progresses.

## Autogenerated Jobs

- Files
- Mysql
- LDAP
- Chef server


## Recipes
### Bacula Director (bacula-dir)
```ruby
bacula::server 
```
Central backup server 

### Bacula File Daemon (bacula-fd)
```ruby
bacula::client
```
Used by each client to be backed up

### Bacula Storage Daemon (bacula-sd)
```ruby
bacula::storage (bacula-sd)
```
For use on storage system

### Bacula Administration Tool BAT (bacula-console-qt)
```ruby
bacula::bat
```
Used for Systems with graphic environment - installs and configures "bat" Bacula qt-console

# Requirements

Cookbooks:
```ruby
mysql
database
openssl #for password generation
```

#Attributes

**default.rb**

Configure the bacula user
```ruby
node['bacula']['user']
node['bacula']['group']
```

**server.rb**

Set properties for File based backup
```ruby
node['bacula']['volume_size'] = "1G"
node['bacula']['volume_max'] = 20
node['bacula']['label_format'] = "BaculaFile"
```

**client.rb**

Set files to be backed up (see Usage below)
```ruby
node['bacula']['fd']['files']
```

**storage.rb**

Set up destination of File-Storage
```ruby
default['bacula']['sd']['backup_dir'] = "/backup"
```

# Usage


## Backup Job generation

To autogenerate jobs the following expressions need to be ```true``` on ```bacula::client``` machine:

**Mysql**

```ruby
node['mysql'] && node['mysql']['server_root_password']
```

**Ldap**

```ruby
node['openldap'] && node['openldap']['slapd_type'] == "master"
```

**Chef Server**

```ruby
node['fqdn'] == "chef.#{node['domain']}"
```

## Default deployment
- node A => bacula::server
- node B => bacula::storage (with much storage)
- node C-Z => bacula::client

# Examples

## Howto backup files (do not use in production)
Set on your ```bacula::client``` node
```ruby
node.set['bacula']['fd']['files'] = {
  'includes' => ['/']],
  'excludes' => [ '/dev','sys']
}
```


## Howto change the backup cycle
To change the backup cycle make changes in templates/default/bacula-dir.conf


# Todo/Ideas
- Add restore jobs
- more datastores (postgresql, sqlite)
- make attributes out of the listening port
- make mailing work

# Contact
see metadata.rb