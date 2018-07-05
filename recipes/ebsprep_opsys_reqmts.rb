log "
     **********************************************
     *                                            *
     *        Recipe:#{recipe_name}                  *
     *                                            *
     **********************************************
    "

workdir        = node[:clone12_2][:ebsprep][:workingdir]
fils2check     = node[:clone12_2][:ebsprep][:filesets2check]

rootusr        ='root'
rootgrp        =node[:root_group]



  ######################################
  # OS level must be 7200.01.01 or later
  #
cookbook_file "#{workdir}/oslevel_check_aix7.pl" do
  user    rootusr
  group   rootgrp
  mode    '0775'
  source 'oslevel_check_aix7.pl'
end
fname="oslevel_check_aix7"
execute   "Checking_oslevel_for minimum_requirements" do
  user     rootusr
  group    rootgrp
  command "perl #{workdir}/#{fname}.pl >#{workdir}/#{fname}.out 2>&1"
end 

  ######################################
  # Java Requirements
  #
log "
     **********************************************
     *  Nothing to do here. If the version of Java
     *  came with AIX 7.2 TL1 or better, It is fine
     *
     *  CURRENTLY CANNOT BE AUTOMATED.
     **********************************************
    "
  ######################################
  # XlC min versions
  #
  # xlC.aix61.rte:13.1.2.0 or later
  # xlC.rte.13.1.2.0 or later
  #

  ######################################
  # OS level must be 7200.01.01 or later
  #
cookbook_file "#{workdir}/fileset_check_min.pl" do
  user    rootusr
  group   rootgrp
  mode    '0775'
  source 'fileset_check_min.pl'
end

  #maybe multiple, we put in 2 field loop
  #
fils2check.each_slice(2) do | doublet |
  thisfs, thisver = doublet

  fname=thisfs
  execute "check_fileset_min_for_#{thisfs}" do
    user  rootusr
    group rootgrp
    command "perl #{workdir}/fileset_check_min.pl "\
            "--fileset=#{thisfs}  --minimum=#{thisver}"
  end 
end
