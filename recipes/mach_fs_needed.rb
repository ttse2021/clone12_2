log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "
thisdir = node[:clone12_2][:machprep][:workingdir]
fslist  = node[:clone12_2][:machprep][:fs_sizes] 


  # download the grow_fs.pl file to the machine
  #
cookbook_file "#{thisdir}/grow_fs.pl" do
  user 'root'
  group node[:root_group]
  mode '0775'
  source 'grow_fs.pl'
end

  # for each triplet, create the file system
fslist.each_slice(3) do | triplet |
  mnt,minsiz,wanted = triplet

  fname="grow_fs"
  execute "grow_filesystem_#{mnt}" do
    user 'root'
    group node[:root_group]
  command "perl #{thisdir}/#{fname}.pl --filesystem #{mnt} --free #{wanted}"
  end 
end
