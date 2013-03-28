push-server-data
================

Basic script used to push the data on a Unix type servers to a backup location.

Installation
============

Set up an account on the backup server to receive the backup data.

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
to a file on the server at

```
# /home/servername/.ssh/authorized_keys

```

If you have restrictions on SSH on the backup server change the configuration to allow the server to log in.




This script should normally be copied to /usr/local/sbin and made runnable by root.  It can be run via cron and would normally be run once per day when the server is quiet.


