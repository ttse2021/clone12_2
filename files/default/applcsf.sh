#!/usr/bin/ksh

##########################################################################
# This script instructions are defined in doc id: 1383621.1
#
# Section Section 4.4
# Verify the APPLCSF variable setting 
# Source the APPS environment and confirm that the variable APPLCSF 
# (identifying the top-level directory for concurrent manager log 
# and output files) points to a suitable directory. To modify, 
# change the value of the <s_applcsf> variable in the context file 
# and then run AutoConfig.
##########################################################################


export ORABASE=${ORABASE?"ORABASE is NOT set"}
export EAPPSenv=$ORABASE/EBSapps.env 	
		
if [ "X${FILE_EDITION}" == "X" ] ; then
  echo ". $EAPPSenv RUN"
        . $EAPPSenv RUN
fi

export APPLCSF=${APPLCSF?"APPLCSF is NOT set"}

if [ -d $APPLCSF ] ; then
   (cd $APPLCSF; \
   for dir in  inbound log out outbound ;
   do
     if [ ! -d $dir ] ; then
       echo "ERROR: Directory $dir does NOT exist. Aborting .."
       exit -8
     fi
   done )
fi

