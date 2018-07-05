#!/usr/bin/ksh


ts=`date +%m%d%H%M`;
env > /tmp/envout
pwd > /tmp/pwdout
id > /tmp/idout

echo mv /home/oracle /home/oracle.$ts
     mv /home/oracle /home/oracle.$ts

echo "cat /d02/bin/home_oracle.tgz | gunzip | (cd /home; tar xpf - )"
      cat /d02/bin/home_oracle.tgz | gunzip | (cd /home; tar xpf - )
