log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "
orausr   =node[:clone12_2][:user] 
oragrp   =node[:clone12_2][:group]
stglog   =node[:clone12_2][:fs_stage][:log]
stgbin   =node[:clone12_2][:fs_stage][:bin]

thisfs    =node[:clone12_2][:fs___ebs][:name]
cert_home ="#{thisfs}/CERT"

log "
     -----------------------------------
     - Installing cert tools           -
     -----------------------------------
    "

thisenv = { 'HOME'            => "/home/#{orausr}", 
            'USER'            => "#{orausr}",
            'PATH'            => "/usr/ccs/bin:/usr/bin:/etc:/usr/sbin:/usr/ucb:$HOME/bin:/usr/bin/X11:/sbin:.",
            'AIXTHREAD_SCOPE' => "s",
            'HOMES'           => "$HOME/homes",
            'CERTDIR'         => "/d01/CERT",
          }

fname="fix_ebsappsenv"
execute "run_#{fname}_SCRIPT" do
  user  orausr
  group oragrp
  environment ( thisenv )
  cwd  cert_home
  command ". /home/#{orausr}/.profile;  ksh #{stgbin}/#{fname}.sh > "\
              "#{stglog}/#{fname}.log 2>&1"
end

fname="DRIVER"
execute "run_#{fname}_SCRIPT" do
  user  orausr
  group oragrp
  environment ( thisenv )
  cwd  cert_home
  timeout 28000
  creates     "#{stglog}/#{fname}.t"
  command ". /home/#{orausr}/.profile;  ksh #{cert_home}/#{fname} -c > "\
              "#{cert_home}/DOUT 2>&1 && touch "\
              "#{stglog}/#{fname}.t"
end
