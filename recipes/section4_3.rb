log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}          *
     *                                       *
     *****************************************
    "


stglog   =node[:clone12_2][:fs_stage][:log]
stgbin   =node[:clone12_2][:fs_stage][:bin]
oraenv   =node[:clone12_2][:oracle][:env]
orausr   =node[:clone12_2][:user] 
oragrp   =node[:clone12_2][:group]

fname="txkwfclone"
execute "change_forms_host_name_with_#{fname}" do
  user  orausr
  group oragrp
  env  ( oraenv )
  cwd  stgbin
  creates     "#{stglog}/#{fname}.t"
  command "ksh #{stgbin}/#{fname}.sh > "\
              "#{stglog}/#{fname}.out 2>&1 && touch "\
              "#{stglog}/#{fname}.t"
end
