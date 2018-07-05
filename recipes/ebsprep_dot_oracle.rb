log "
     **********************************************
     *                                            *
     *        Recipe:#{recipe_name}                  *
     *                                            *
     **********************************************
    "

thisdir        = '/tmp/.oracle'

#per doc id: 1330703.1
# Net Service Listeners in Multi-user Installations

directory "Make_the_dir_#{thisdir}" do
  path thisdir
  owner 'root'
  group node[:root_group]
  mode '0777'
  action :create
end

