log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}         *
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

stglog   =node[:clone12_2][:fs_stage][:log]
stgbin   =node[:clone12_2][:fs_stage][:bin]
oraenv   =node[:clone12_2][:oracle][:env]
orausr   =node[:clone12_2][:user] 
oragrp   =node[:clone12_2][:group]


fname="cookie_domain"
execute "check_section_4.5" do
  user  orausr
  group oragrp
  env  ( oraenv )
  cwd  stgbin
  creates     "#{stglog}/#{fname}.t"
  command "ksh #{stgbin}/#{fname}.sh > "\
              "#{stglog}/#{fname}.out 2>&1 && touch "\
              "#{stglog}/#{fname}.t"
end
