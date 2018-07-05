#!/usr/bin/ksh

netstat -an | fgrep LISTEN | fgrep 9008 > /dev/null 2>&1
if [ $? != 0 ] ; then
  echo stopsrc -s pconsole
       stopsrc -s pconsole
  echo "perl -pi.`date +"%Y%m%d"`.save -e 's/pconsole:2/:pconsole:2/g' /etc/inittab"
        perl -pi.`date +"%Y%m%d"`.save -e 's/pconsole:2/:pconsole:2/g' /etc/inittab
fi

#netstat -an | fgrep 9008
#if There is a conflict with the clone image and port 9008.
#Port 9008 is: IBM System Director Console for AIX (pconsole) for AIX 6.1 and 7.1 
#To DISABLE:
#
#stopsrc -s pconsole
#2) Verify the services are inoperative:
#AIX 5.3, 6.1 and 7.1:
#lssrc -a | egrep "pconsole|webserverstart"
#lssrc -a | egrep "pconsole|webserverstart"
#3) To prevent the service from restarting after reboot, remove or comment out each entry for the command(s) from /etc/inittab
#perl -pi.`date +"%Y%m%d"`.save -e 's/pconsole:2/:pconsole:2/g' /etc/inittab


