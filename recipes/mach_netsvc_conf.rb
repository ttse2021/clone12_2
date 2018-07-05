log "
     **********************************************
     *                                            *
     *        Recipe:#{recipe_name}     *
     *                                            *
     **********************************************
    "

cookbook_file '/etc/netsvc.conf' do
  mode '0664'
  source 'netsvc.conf'
end

