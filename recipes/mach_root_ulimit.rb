log "
     ***************************************
     *                                     *
     *        Recipe:#{recipe_name}     *
     *                                     *
     ***************************************
    "


execute "unlimited_root_profile" do
  user 'root'
  group node[:root_group]
  command "chuser cpu=-1 fsize=-1 data=-1 stack=-1 core=-1 rss=-1 nofiles=65537 root"
end


