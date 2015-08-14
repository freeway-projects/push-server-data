#!/bin/bash
#===================================================================================
#
# FILE: create_rdiffbackup_copies.sh
#
# USAGE: create_rdiffbackup_copies.sh
#
# DESCRIPTION: This will make rdiffbackup copies of the home directories.  These can
# be used to retrieve older copies of the data.
#
# OPTIONS: none
# NOTES: ---
# AUTHOR: Kevin Bailey, kbailey@freewayprojects.com
# COMPANY: Freeway Projects Limited
#===================================================================================

echo
echo `date`
echo "Looping through the home directories to make rdiffbackup copies..."

for dir in $(find /home/ -maxdepth 1 -mindepth 1 -type d)
do

    if [ ${dir} != '/home/lost+found' ] ; then

        echo
        echo `date`
        echo "Making rdiffbackups for $(basename ${dir}) ..."

        mkdir -p /rdiffbackups/$(basename ${dir})
        rdiff-backup --print-statistics ${dir}/backups /rdiffbackups/$(basename ${dir})

        echo "Tell the server to delete rdiff-backups which are too old to prevent the server filling up..."
        rdiff-backup --remove-older-than 3M --force /rdiffbackups/$(basename ${dir})

    fi


done
