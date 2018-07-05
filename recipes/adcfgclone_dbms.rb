log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "


stglog   =node[:clone12_2][:fs_stage][:log]
stgbin   =node[:clone12_2][:fs_stage][:bin]
orausr   =node[:clone12_2][:user] 
oragrp   =node[:clone12_2][:group]
rootusr  = 'root'
rootgrp  =node[:root_group]
oraenv   =node[:clone12_2][:oracle][:env]
orabas   =node[:clone12_2][:orabase]



arg1=node[:clone12_2][:appspw]
arg2=node[:clone12_2][:sid]
arg3="#{orabas}"
arg4="/tmp"

# How To Run Rapid Clone (adcfgclone.pl) Non-Interactively (Doc ID 375650.1)
# Can the Database Tier Context File Store More Than 4 S_dbhomes In R12 Allowing To Automate It? (Doc ID 1528241.1)
  ################################################################
  # NOTE: This is required fix.
  # Sigh, the only way to get this script to work was to use
  # su - oracle. It fails when i run it as user oracle under
  # chef. Not sure why. You would think it would be the same.
  #
fname="do_dbms"
execute "run_do_dbms" do
  user  rootusr
  group rootgrp
  cwd   "#{orabas}/12.1.0/appsutil/clone/bin"
  creates        "#{stglog}/#{fname}.t"
  command "su - oracle -c \"ksh #{stgbin}/#{fname}.sh "\
               "> #{stglog}/#{fname}.out 2>&1 && touch "\
                 "#{stglog}/#{fname}.t\""
end
