log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}           *
     *                                       *
     *****************************************
    "

orausr  = node[:clone12_2][:user]
oragrp  = node[:clone12_2][:group]
stgbin  = node[:clone12_2][:fs_stage][:bin]
ebsbin  = node[:clone12_2][:fs___ebs][:bin]
rootusr = 'root'
rootgrp = node[:root_group]

templates= [
   "adop.sh"               , ebsbin,   orausr  ,  oragrp   , '0755', 
   "adcfgclone_dbms.exp"   , stgbin,   orausr  ,  oragrp   , '0755',
   "adcfgclone_apps.exp"   , stgbin,   orausr  ,  oragrp   , '0755',
   "chk_p22761451.sh"      , stgbin,   orausr  ,  oragrp   , '0755',
   "clean_trees.sh"        , stgbin,   orausr  ,  oragrp   , '0755',
   "find_runfs.sh"         , stgbin,   orausr  ,  oragrp   , '0755', 
   "fix_ebsappsenv.sh"     , stgbin,   orausr  ,  oragrp   , '0755',
   "wget_cert.sh"          , stgbin,  rootusr  , rootgrp   , '0755', 
   "inst_cert.sh"          , stgbin,  rootusr  , rootgrp   , '0755', 
  ]

  # for each quadruplet, create the cookbook
  #
templates.each_slice(5) do | quadruplet |
  thisfile,targetdir,thisusr,thisgrp,thismode = quadruplet
  template    "#{targetdir}/#{thisfile}" do
    owner     thisusr
    group     thisgrp
    mode      thismode
    source "#{thisfile}.erb"
  end
end
