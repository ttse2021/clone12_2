log "
     ***************************************
     *                                     *
     *        Recipe:#{recipe_name}           *
     *                                     *
     ***************************************
    "

thisdir = node[:clone12_2][:machprep][:workingdir]

  #

  # download the mknfsmount.sh file to the machine
  #
cookbook_file "#{thisdir}/fix_hostname.sh" do
  user 'root'
  group node[:root_group]
  mode '0775'
  source 'fix_hostname.sh'
end

execute "shorten_hostname_without_fqdn" do
  user 'root'
  group node[:root_group]
  command "#{thisdir}/fix_hostname.sh"
end
  
