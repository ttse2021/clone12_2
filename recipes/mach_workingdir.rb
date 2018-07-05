log "
     **********************************************
     *                                            *
     *        Recipe:#{recipe_name}               *
     *                                            *
     **********************************************
    "
thisdir        = node[:clone12_2][:machprep][:workingdir]

directory "Make_the_dir_#{thisdir}" do
  path thisdir
  owner 'root'
  group node[:root_group]
  mode '0755'
  action :create
end

