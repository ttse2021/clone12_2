log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "

   ##########################################################################
   # This script instructions are defined in doc id: 1383621.1
   #
   # Section Section 4.5
   # Update the SESSION_COOKIE_DOMAIN value in ICX_PARAMETERS
   # If the Target System is in a different domain name from the Source System
   # and SESSION_COOKIE_DOMAIN is not null in the Source System, update the
   # value of SESSION_COOKIE_DOMAIN to reflect the new domain name.
   ##########################################################################

ebslog   =node[:clone12_2][:fs___ebs][:log]
ebsbin   =node[:clone12_2][:fs___ebs][:bin]
ebsdir   =node[:clone12_2][:fs___ebs][:name]
oraenv   =node[:clone12_2][:oracle][:env]
orausr   =node[:clone12_2][:user] 
oragrp   =node[:clone12_2][:group]


fname="adop"


  #install missing linux tools that chef may need
  #
phaselist= [ "prepare","finalize","cutover","cleanup" ]
phaselist.each do |phase|
  execute "run_this_phase_under_adop_#{phase}" do
    user  orausr
    group oragrp
    env  ( oraenv )
    cwd  ebsbin
    creates     "#{ebslog}/#{fname}_#{phase}.t 2>&1"
    command "ksh #{ebsbin}/#{fname}.sh -p #{phase} > "\
                "#{ebslog}/#{fname}_#{phase}.out 2>&1 && touch "\
                "#{ebslog}/#{fname}_#{phase}.t"
  end
  execute "STATUS_For__#{phase}" do
    user  orausr
    group oragrp
    env  ( oraenv )
    cwd  ebsbin
    creates     "#{ebslog}/#{fname}_#{phase}.status.t 2>&1"
    command "ksh #{ebsbin}/#{fname}.sh -s > "\
                "#{ebslog}/#{fname}_#{phase}.status 2>&1 && touch "\
                "#{ebslog}/#{fname}_#{phase}.status.t"
  end
end
