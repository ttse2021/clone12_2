log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "


rootenv  =node[:clone12_2][:root][:env]
rootgrp  =node[:root_group]
rootusr  ='root'

stglog   =node[:clone12_2][:fs_stage][:log]
stgbin   =node[:clone12_2][:fs_stage][:bin]


fname="fix_port_9008"
execute "fix_port_conflict_9008" do
  user  rootusr
  group rootgrp
  cwd   stgbin
  environment ( rootenv )
  creates        "#{stglog}/#{fname}.t"
  command "ksh -x #{stgbin}/#{fname}.sh > "\
                 "#{stglog}/#{fname}.out 2>&1 && touch "\
                 "#{stglog}/#{fname}.t"
end

