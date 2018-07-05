log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}         *
     *                                       *
     *****************************************
    "

rootusr  = 'root'
rootgrp  =node[:root_group]
rootenv  =node[:clone12_2][:root][:env]
stgbin   =node[:clone12_2][:fs_stage][:bin]
stglog   =node[:clone12_2][:fs_stage][:log]

fname="mv_oracle_home"
execute "put_down_oracle_home" do
  user   rootusr
  group  rootgrp
  environment ( rootenv )
  creates        "#{stglog}/#{fname}.t"
  command "ksh -x #{stgbin}/#{fname}.sh > "\
                 "#{stglog}/#{fname}.out 2>&1 && touch "\
                 "#{stglog}/#{fname}.t"
end
