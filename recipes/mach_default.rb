log "
     ***************************************
     *                                     *
     *        Recipe:#{recipe_name}     *
     *                                     *
     ***************************************
    "


  ######################################
  # Review doc: 1330703.1 for changes!
  #   Oracle E-Business Suite Installation and Upgrade 
  #   Notes Release 12 (12.2) for IBM AIX on Power 
  #  Systems (64-bit) (Doc ID 1330703.1)
  ######################################

  ######################################
  # Install OS specific customizations #
  ######################################


  ####################################################
  # Creates the working dir directory, default is /tmp/clone12_2
  #
include_recipe 'clone12_2::mach_workingdir'


  ####################################################
  # Replaces the root environment files with our own.
  #                Puts the original in .root_b4_chef
  #
include_recipe 'clone12_2::mach_root_profile'


  ####################################################
  # sets root ulimit to unlimimted
  #
include_recipe 'clone12_2::mach_root_ulimit'

  ####################################################
  # change ncargs and maxuproc
  #
include_recipe 'clone12_2::mach_chdev'

 
  ####################################################
  # adds netsvc_conf, making it local,then bind4
  #
include_recipe 'clone12_2::mach_netsvc_conf'

  ####################################################
  # shortens the hostname, so without FQDN
  #
include_recipe 'clone12_2::mach_shorthn'

  ####################################################
  # Checks to see if filesets are installed
  # also checks for symlinks exists for linkxlc etc
  #
include_recipe 'clone12_2::mach_filesets'

  ####################################################
  # volume groups
  #
include_recipe 'clone12_2::mach_fs_volgrp'


  ####################################################
  #
  # file systems.
  #
  #
include_recipe 'clone12_2::mach_fs_filsys'

  ####################################################
  # Checks if file systems are sized correctly
  #
include_recipe 'clone12_2::mach_fs_needed'


 ####################################################
 # Changes no tunables
 #
include_recipe 'clone12_2::mach_tunables'

 ####################################################
 # adds  pagespace if necessary
 #
include_recipe 'clone12_2::mach_pagespace'

 ####################################################
 # Create users and groups
 #
include_recipe 'clone12_2::mach_mkusers'

  ####################################################
  # Make sure linux tools are there.
  #
include_recipe 'clone12_2::mach_linux_tools'

  ####################################################
  # Allow these binaries to be runnable by others
  #
include_recipe 'clone12_2::mach_chmods'
