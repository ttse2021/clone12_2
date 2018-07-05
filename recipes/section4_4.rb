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
   # Section Section 4.4
   # Verify the APPLCSF variable setting
   # Source the APPS environment and confirm that the variable APPLCSF
   # (identifying the top-level directory for concurrent manager log
   # and output files) points to a suitable directory. To modify,
   # change the value of the <s_applcsf> variable in the context file
   # and then run AutoConfig.
   ##########################################################################

stglog   =node[:clone12_2][:fs_stage][:log]
stgbin   =node[:clone12_2][:fs_stage][:bin]
oraenv   =node[:clone12_2][:oracle][:env]
orausr   =node[:clone12_2][:user] 
oragrp   =node[:clone12_2][:group]


fname="applcsf"
execute "check_applcsf_directory_is_there" do
  user  orausr
  group oragrp
  env  ( oraenv )
  cwd  stgbin
  creates     "#{stglog}/#{fname}.t"
  command "ksh #{stgbin}/#{fname}.sh > "\
              "#{stglog}/#{fname}.out 2>&1 && touch "\
              "#{stglog}/#{fname}.t"
end
