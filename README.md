## push-server-data

Basic script used to push the data on a Unix type servers to a backup location.

The principle behind backups should be that the server can be rebuilt from a vanilla server if needed.  There should be a server document which holds the full details of how the server has been configured.

Therefore, by using the server document and the backups the server it should be possible to rebuild the server completely.

## Installation

Basically the backup server will have a local account on it which will used to hold the backup data.  Data will be sent to this account from the server which is being backed up via SSH.

### Set up an account

First up an account on the backup server to receive the backup data.

```
# adduser --disabled-password --gecos "" servername
# mkdir /home/servername/backups
# chown servername:servername /home/servername/backups
```

On the server to be backed up create a key and install the public key on to the backup server.  This means that the server can log in to the backup server without being prompted for a password.

```
# ssh-keygen -t dsa
```

Then copy the public key which is in
```
~/.ssh/id_dsa.pub
```
to a file on the backup server at

```
# /home/servername/.ssh/authorized_keys

```

If you have restrictions on SSH on the backup server change the configuration to allow the server to log in.

### Install the script

This script should normally be copied to /usr/local/sbin and made runnable by root.  It can be run via cron and would normally be run once per day when the server is quiet.

The backup script will need to run mysql, mysqldump and pg_dump without being prompted for a password.  This can be achieved by using a ~/.my.cnf file.

### Set up rdiffbackup on the backup server

On the backup server data is rsync'd over from the server being backed up.  To make safety copies of this data it is copied to another location using rdiffbackup.  To make this automatic the script create_rdiffbackup_copies.sh is run regularly on the backup server itself.


