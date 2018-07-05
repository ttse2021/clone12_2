#!/usr/bin/ksh

##########################################################################
# This script instructions are defined in doc id: 1383621.1
#
# Section Section 4.5
# Update the SESSION_COOKIE_DOMAIN value in ICX_PARAMETERS
# If the Target System is in a different domain name from the Source System 
# and SESSION_COOKIE_DOMAIN is not null in the Source System, update the 
# value of SESSION_COOKIE_DOMAIN to reflect the new domain name.
##########################################################################

export ORABASE=${ORABASE?"ORABASE is NOT set"}
export EAPPSenv=$ORABASE/EBSapps.env 	
		
if [ "X${FILE_EDITION}" == "X" ] ; then
  echo ". $EAPPSenv RUN"
        . $EAPPSenv RUN
fi

value=`sqlplus -s "apps/apps" <<EOF
SET HEADING OFF
SET PAGESIZE 0
SET feedback off
select 'X', SESSION_COOKIE_DOMAIN, 'Y' from ICX_PARAMETERS;
quit;
EOF`

echo $value
if [ "X$value" != "XX Y" ] ; then
  echo "'SESSION_COOKIE_DOMAIN' is null" 
  echo 'We can IGNORE THIS TASK. We Are OK.'
else
  echo "####################################################################"
  echo "FROM DOC ID: 1383621.1"
  echo "5. Update the SESSION_COOKIE_DOMAIN value in ICX_PARAMETERS"
  echo "If the Target System is in a different domain name from the Source"
  echo "System and SESSION_COOKIE_DOMAIN is not null in the Source"
  echo "System, update the value of SESSION_COOKIE_DOMAIN to reflect"
  echo " the new domain name."
  echo "####################################################################"

  echo "Cookbook hasn't been programed to handle this. You must fix manually"
  exit -8
fi
exit 0
