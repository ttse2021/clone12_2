log "
     ***************************************
     *                                     *
     *        Recipe:#{recipe_name}     *
     *                                     *
     ***************************************
    "

  # Create users
  #
  ulists=node[:clone12_2][:machprep][:mkusers] 

  # for each user, handle group, user, ulimits
  #
  ulists.each_slice(7) do | myslice |
    thisusr, thisuid, thisgroup, thisgid, thispw, thishome, theselimits = myslice

    # create group if doesnt exists
    group "Create_group_#{thisgroup}" do
      group_name thisgroup
      gid        thisgid.to_i
    end

    # create user if doesnt exists
    user thisusr  do
      uid         thisuid.to_i
      gid         thisgid.to_i
      shell       '/usr/bin/ksh'
      home        thishome
      manage_home true
    end
            
    
    # set password for user
    execute "change_passw_for_#{thisusr}" do
      user 'root'
      group node[:root_group]
      command "echo #{thisusr}:#{thispw} | /usr/bin/chpasswd"
      not_if { thispw.eql?("NOCHG") }
    end
            
    # set unlimited ulimits for user
    execute "unlimited_ulimit_for_#{thisusr}" do
      user 'root'
      group node[:root_group]
      command "chuser #{theselimits} #{thisusr}"
    end
            
    # dont check to change password for this user
    execute "change_pwadm_NOCHECK_for_#{thisusr}" do
      user 'root'
      group node[:root_group]
      command "pwdadm -f NOCHECK #{thisusr}"
    end
  end
