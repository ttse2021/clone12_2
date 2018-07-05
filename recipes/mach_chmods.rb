log "
     **********************************************
     *                                            *
     *        Recipe:#{recipe_name}     *
     *                                            *
     **********************************************
    "

  # make slibclean available to all
file '/usr/sbin/slibclean' do
  mode '6555'
end
