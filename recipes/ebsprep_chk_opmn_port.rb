log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}          *
     *                                       *
     *****************************************
    "

thisdir = node[:clone12_2][:ebsprep][:workingdir]

rootusr = 'root'
rootgrp = node[:root_group]

#######################################################################
# Doc Id: 1330703.1
#
# Attention: By default, the OPMN service of the Application 
# Server technology stack listens on port 6000 when started up 
# during Rapid Install. This can conflict with the X11 port 
# used for the graphics console on AIX servers or other processes 
# and prevent Rapid Install from completing.
#

# Note: we decided not to automate this at this time. We havent
# found it on a newly installed system, and therefore dont
# believe we will ever see this. So Instead, we check and fail
# if it ever gets triggered
#
fname="chk_opmn_port"
execute "check_if_port_6000_in_use" do
  user  rootusr
  group rootgrp
  command "netstat -an | grep 6000 | fgrep LISTEN"
  returns 1
end
