#!/usr/bin/ksh

##########################################################################
# This script modifies sqlnet_ifile.ora to the value set according to
# DOC ID: 1383621.1 Section 3.2.3.1
# which wants us to make sure that this is set based on the value of
# show parameter sec_case_sensitive_logon
# within the dbms.
##########################################################################

. /home/oracle/homes/dbms/.profile

export CONTXT=VIS_`hostname`

# start the dbms if not started.
thisname=`basename $0`
TMPF=/tmp/$thisname.$$

export ORACLE_HOME=${ORACLE_HOME?"ORACLE_HOME is NOT set"}

typeset -u value 

#value=`sqlplus -s "/ as sysdba" <<EOF | perl -n -a -F, -e 'print "$F[2]\n"'
value=`sqlplus -s "/ as sysdba" <<EOF| awk '{print $3}'
SET HEADING OFF
SET PAGESIZE 0
SET feedback off
show parameter sec_case_sensitive_logon
quit;
EOF`

value="TRUE"
if [ "X$value" != "XFALSE" ] && [ "X$value" != "XTRUE" ] ; then
  echo "ERROR: value has incorrect value from sql statement: $value"
  echo "Aborting ..."
  exit -8
fi

ts=`date +%m%d%H%M`;

dir=$ORACLE_HOME/network/admin/VIS_`hostname`
echo cd  $dir
     cd  $dir

if [ ! -f sqlnet_ifile.ora.orig ] ; then
  echo mv sqlnet_ifile.ora sqlnet_ifile.ora.$ts
       mv sqlnet_ifile.ora sqlnet_ifile.ora.$ts
  echo cp sqlnet_ifile.ora.$ts sqlnet_ifile.ora
       cp sqlnet_ifile.ora.$ts sqlnet_ifile.ora
fi

fgrep ALLOWED_LOGON_VERSION_SERVER  sqlnet_ifile.ora > /dev/null
if [ $? != 0 ] ; then
  if [ "X$value" != "XTRUE" ] ; then
    echo 'echo "SQLNET.ALLOWED_LOGON_VERSION_SERVER = 8"  >> sqlnet_ifile.ora'
          echo "SQLNET.ALLOWED_LOGON_VERSION_SERVER = 8"  >> sqlnet_ifile.ora
  else
    echo 'echo "SQLNET.ALLOWED_LOGON_VERSION_SERVER = 10" >> sqlnet_ifile.ora'
          echo "SQLNET.ALLOWED_LOGON_VERSION_SERVER = 10" >> sqlnet_ifile.ora
  fi
else
  echo "FOUND IT already, ignoring..."
fi
