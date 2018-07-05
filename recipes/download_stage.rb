log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "


  #################################################################
  # From: Doc ID 1383621.1                                        #
  # Section 3.2 step 2:                                           #
  # "paraphrasing: tar over the image to the Target directory     # 
  #################################################################

orausr  = node[:clone12_2][:user]
oragrp  = node[:clone12_2][:group]
oraenv  = node[:clone12_2][:oracle][:env]

stglog   =node[:clone12_2][:fs_stage][:log]
stgbin   =node[:clone12_2][:fs_stage][:bin]
ebsdir   =node[:clone12_2][:fs___ebs][:name]
runfs    =node[:clone12_2][:runfs] 
patchfs  =node[:clone12_2][:patchfs] 
zip_dir  =node[:clone12_2][:tgz_dir]
zip_file =node[:clone12_2][:tgz_file]


log "
     *****************************************************************
     *                                                               *
     * Downloading #{stgbin}/#{zip_file} ...                            *
     * THIS  will take many minutes or hours                         *
     *                                                               *
     *****************************************************************
    "

remote_file "#{stgbin}/#{zip_file}" do
  source "#{zip_dir}/#{zip_file}"
  owner 'root'
  group node[:root_group]
  mode '755'
  action :create_if_missing
end

log "
     *****************************************************************
     *                                                               *
     * Unzipping #{stgbin}/#{zip_file} to #{ebsdir} ...                            *
     * THIS  will take many minutes or hours                         *
     *                                                               *
     *****************************************************************
    "

fname="unzipped_tgz_completed"
execute "unzip_tgz_to_target_filesystem_#{ebsdir}" do
  user 'root'
  group node[:root_group]
  timeout 7200
  creates      "#{stglog}/#{fname}.t"
  command "cat  #{stgbin}/#{zip_file} | gunzip | (cd #{ebsdir}; tar xpf - ) > "\
               "#{stglog}/#{fname}.out 2>&1 && touch "\
               "#{stglog}/#{fname}.t"
end

fname="find_runfs"
execute "identify_the_run_fs_directory_into_#{runfs}" do
  user          orausr
  group         oragrp
  environment ( oraenv )
  creates        "#{runfs}"
  command "ksh #{stgbin}/#{fname}.sh > #{runfs} 2>&1"
end

log '
     *************************************************************************
     *                                                                       *
     * Removing directories that must be removed                             *
     * This will take many minutes                                           *
     *  what to clean:                                                       *
     *                                                                       *
     *  You want to clean:                                                   *
     *   a) the patch fs_ directory, keeping the RUN fs_ directory.          *
     *   b) You want to cldean /d01/oraInventory                             *
     *   c) Within the RUN fs_, you want to get rid of inst and FMW_HOME     *
     *   d) Remove fs_ne as well                                             *
     *                                                                       *
     *************************************************************************
    '
fname="clean_trees"
execute "cleaning directories on #{ebsdir}" do
  user          orausr
  group         oragrp
  environment ( oraenv )
  creates        "#{stglog}/#{fname}.t"
  command "ksh -x #{stgbin}/#{fname}.sh && touch "\
                 "#{stglog}/#{fname}.t"
end
