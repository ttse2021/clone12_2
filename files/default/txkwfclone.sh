#!/usr/bin/ksh

##########################################################################
# This script instructions are defined in doc id: 387337.1
##########################################################################

export ORABASE=${ORABASE?"ORABASE is NOT set"}
export EAPPSenv=$ORABASE/EBSapps.env 	
		
. $EAPPSenv RUN

export INST_TOP=${INST_TOP?"INST_TOP is NOT set"}

sh $INST_TOP/admin/install/txkWfClone.sh -nopromptmsg <<EOF
apps
apps
EOF
