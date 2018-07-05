log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}             *
     *                                       *
     *****************************************
    "

orausr = node[:clone12_2][:user]
oragrp = node[:clone12_2][:group]
oracle_real_base = "#{node[:clone12_2][:fs___ebs][:name]}/oracle"

dirlist= [
   node[:clone12_2][:fs___ebs][:bin]             , orausr   , oragrp   , '0755',
   node[:clone12_2][:fs___ebs][:log]             , orausr   , oragrp   , '0755',
   node[:clone12_2][:fs_stage][:bin]             , orausr   , oragrp   , '0755',
   node[:clone12_2][:fs_stage][:log]             , orausr   , oragrp   , '0755',
   node[:clone12_2][:fs___ebs][:tmp]             , orausr   , oragrp   , '0755',
   node[:clone12_2][:fs_stage][:tmp]             , orausr   , oragrp   , '0755',
   node[:clone12_2][:fs_stage][:name]            , orausr   , oragrp   , '0755',
   node[:clone12_2][:fs___ebs][:name]            , orausr   , oragrp   , '0755',
   oracle_real_base                              , orausr   , oragrp   , '0755',
  ]

  # for each quadruplet, create the directory
  #
dirlist.each_slice(4) do | quadruplet |
  thisdir,thisusr,thisgrp,thismode = quadruplet

  directory thisdir do
    owner   thisusr
    group   thisgrp
    mode    thismode
    action  :create
  end

end
