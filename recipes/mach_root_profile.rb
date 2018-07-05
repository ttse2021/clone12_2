log "
     ***************************************
     *                                     *
     *        Recipe:#{recipe_name}     *
     *                                     *
     ***************************************
    "

rhome          = node[:etc][:passwd][:root][:dir]
b4dir          = "#{rhome}/.root_b4_chef"

  # Make a dir to save the previous environment for root
  #
directory "Make_the_root_b4_chef_dir" do
  owner 'root'
  group  node[:root_group]
  path   b4dir
  mode  '0755'
  action :create
end



profiles = [ 'profile' , 'profile.local', 'kshrc', 'kshrc.local' ]

  #For each profile, save it and put down new one.
  #
touchf="#{rhome}/.chef_root"
unless File.file?( touchf )

  profiles.each do |thisfile|
    fpfile="#{rhome}/.#{thisfile}"

    execute "move_#{fpfile}_to_#{b4dir}" do
      user 'root'
      group node[:root_group]
      # if profile file exists, we move it.
      command "mv #{fpfile}  #{b4dir}/#{thisfile}"
      only_if  { File.file?( "#{fpfile}" ) } 
    end
  
    # put down the new one.
    #
    cookbook_file "#{fpfile}" do
      user 'root'
      group node[:root_group]
      mode '0740'
      source  "root.#{thisfile}"
    end

  end
end

  # Touch a file to represent that we have completed this work
  #
execute "installed_root_profiles" do
  user 'root'
  group node[:root_group]
  command "touch #{touchf}"
  creates       "#{touchf}"
end

