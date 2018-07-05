log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "


stglog   =node[:clone12_2][:fs_stage][:log]
stgbin   =node[:clone12_2][:fs_stage][:bin]
oraenv   =node[:clone12_2][:oracle][:env]
orausr   =node[:clone12_2][:user] 
oragrp   =node[:clone12_2][:group]
runfs    =node[:clone12_2][:runfs] 

fname="adcfgclone_apps"
execute "run_apps_clone_adcfg_script" do
  user  orausr
  group oragrp
  env  ( oraenv )
  cwd  stgbin
  timeout 144000
  creates        "#{stglog}/#{fname}.t"
  command "expect #{stgbin}/#{fname}.exp `cat #{runfs}` "\
              " > #{stglog}/#{fname}.out 2>&1 && touch "\
                 "#{stglog}/#{fname}.t"
end
