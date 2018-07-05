log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}          *
     *                                       *
     *****************************************
    "

orausr  = node[:clone12_2][:user]
oragrp  = node[:clone12_2][:group]
rootusr = 'root'
rootgrp = node[:root_group]

stgbin = node[:clone12_2][:fs_stage][:bin]
ebsbin = node[:clone12_2][:fs___ebs][:bin]

filelist= [
   "#{stgbin}/do_dbms.sh"                      , orausr   , oragrp   , '0755',
   "#{stgbin}/mv_oracle_home.sh"               , orausr   , oragrp   , '0755',
   "#{stgbin}/home_oracle.tgz"                 , orausr   , oragrp   , '0755',
   "#{stgbin}/txkwfclone.sh"                   , orausr   , oragrp   , '0755',
   "#{stgbin}/sqlnet_fix.sh"                   , orausr   , oragrp   , '0755',
   "#{stgbin}/fix_port_9008.sh"                , orausr   , oragrp   , '0755',
   "#{stgbin}/applcsf.sh"                      , orausr   , oragrp   , '0755',
   "#{stgbin}/cookie_domain.sh"                , orausr   , oragrp   , '0755',
   "#{stgbin}/cerrs.pl"                        , orausr   , oragrp   , '0755',
   "#{stgbin}/wget_iglist"                     , orausr   , oragrp   , '0755',
   "#{stgbin}/p22761451_111190_AIX64-5L.zip"   , orausr   , oragrp   , '0755',
   "/etc/oraInst.loc"                          , orausr   , oragrp   , '0755',
  ]

  # for each quadruplet, create the cookbook
  #
filelist.each_slice(4) do | quadruplet |
  thisfile,thisusr,thisgrp,thismode = quadruplet
  cookbook_file thisfile do
    owner       thisusr
    group       thisgrp
    mode        thismode
  end
end

