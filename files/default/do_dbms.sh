#!/usr/bin/ksh

##########################################################################
# This script modifies sqlnet_ifile.ora to the value set according to
# DOC ID: 1383621.1 Section 3.2.3.1
# which wants us to make sure that this is set based on the value of
# show parameter sec_case_sensitive_logon
# within the dbms.
##########################################################################

export CONTXT=VIS_`hostname`

. /home/oracle/.profile

cp /d02/bin/adcfgclone_dbms.exp /d01/oracle/VIS/12.1.0/appsutil/clone/bin

cd  /d01/oracle/VIS/12.1.0/appsutil/clone/bin
expect ./adcfgclone_dbms.exp
