log '
     ***************************************
     *                                     *
     *        EBS Recipe:#{recipe_name}          *
     *                                     *
     ***************************************
    '

  ######################################
  # Review doc: 1330703.1 for changes!
  ######################################

  ######################################
  # Install OS specific customizations #
  ######################################


  ####################################################
  # Creates the working dir directory, default is /tmp/ebsprep
  #
include_recipe 'clone12_2::ebsprep_workingdir'

  ####################################################
  # Checks os requirements
  #
include_recipe 'clone12_2::ebsprep_opsys_reqmts'

  ####################################################
  # Doc Id: 1330703.1
  # permissions on /tmp/.oracle
  #
include_recipe 'clone12_2::ebsprep_dot_oracle'

  #####################################################
  # we end up installing this alot. so we automated it.
  #
include_recipe 'clone12_2::ebsprep_linkxlc'

  #####################################################
  # Check filesets.
  #
include_recipe 'clone12_2::ebsprep_ebs_filesets'

  ####################################################
  # check if port 6000 is in use.
  #
include_recipe 'clone12_2::ebsprep_chk_opmn_port'

  ####################################################
  # Looks for problems with /etc/hosts.
  # EBS has some specific rules.
  #
include_recipe 'clone12_2::ebsprep_etchosts'

  #####################################################
  # Reboot machine:                                   #
  #                                                   #
  #####################################################
include_recipe 'clone12_2::ebsprep_reboot'


