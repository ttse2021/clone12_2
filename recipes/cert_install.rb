log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "
stglog   =node[:clone12_2][:fs_stage][:log]
stgbin   =node[:clone12_2][:fs_stage][:bin]
stgtmp   =node[:clone12_2][:fs_stage][:tmp] 
orausr   =node[:clone12_2][:user] 
oragrp   =node[:clone12_2][:group]
rootusr  = 'root'
rootgrp  =node[:root_group]
oraenv   =node[:clone12_2][:oracle][:env]
orabas   =node[:clone12_2][:orabase]

thisfs=node[:clone12_2][:fs___ebs][:name]

log "
     -----------------------------------
     - Installing cert tools           -
     -----------------------------------
    "

fname="wget_cert"
execute "download_cert_install_files_to_stgbin" do
  user  rootusr
  group rootgrp
  cwd  stgtmp
  creates     "#{stglog}/#{fname}.t"
  command "ksh #{stgbin}/#{fname}.sh > "\
              "#{stglog}/#{fname}.out 2>&1 && touch "\
              "#{stglog}/#{fname}.t"
end

fname="inst_cert"
execute "unpack_CERT_scripts_to_#{thisfs}" do
  user  rootusr
  group rootgrp
  cwd  stgtmp
  creates     "#{stglog}/#{fname}.t"
  command "ksh #{stgbin}/#{fname}.sh > "\
              "#{stglog}/#{fname}.out 2>&1 && touch "\
              "#{stglog}/#{fname}.t"
end
