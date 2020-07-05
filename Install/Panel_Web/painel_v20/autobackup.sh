#!/bin/bash
clear
varDir="banco28653"
rm /var/www/admin/pages/apis/$varDir/sshplus.sql > /dev/null 2>&1
senha=$(cat /var/www/pages/system/pass.php |cut -d"'" -f2)
mysqldump -u root -p$senha sshplus > /var/www/admin/pages/apis/$varDir/sshplus.sql
