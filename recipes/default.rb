log "
  *****************************************
  *                                       *
     *        Recipe:#{recipe_name}     *
  *                                       *
  *****************************************
 "

  #####################################################
  # Machine preparation:                              #
  #                                                   #
  #####################################################
include_recipe 'clone12_2::mach_default'


  #####################################################
  # EBS  preparation:                                 #
  #                                                   #
  #####################################################
include_recipe 'clone12_2::ebsprep_default'


  #####################################################
  # This cookbook installation follows:               #
  #   Cloning Oracle E-Business Suite Release 12.2    #
  #   with Rapid Clone (Doc ID 1383621.1)             #
  #   LAST UPDATED: 01-Aug-2016A                      #
  #                                                   #
  # If the document is updated, You'll have to review #
  # the cookbook for updates                          #
  #                                                   #
  #####################################################

  #-------------------------------------------------------------#
  #                                                             #
  # NOTE FROM AUTHOR                                            #
  #   This cloning cookbook begins at the section 3.2 step 2    #
  #   It is assumed that all the operations from Section 1 to   #
  #   Section 3.2 Step 1 have been completed on the SOURCE      #
  #   machine and that then the backup                          #
  #   image was taken at this step. This is true of the backup  #
  #   files that are part of this cookbook.                     #
  #                                                             #
  #-------------------------------------------------------------#

  #################################################################
  # From: Doc ID 1383621.1                                        #
  # The instructions in this document are only for use with an    #
  # Oracle E-Business Suite Release 12.2 system that is on the    #
  # AD-TXK Delta 7 codelevel.                                     #
  #################################################################

  #################################################################
  # From: Doc ID 1383621.1                                        #
  # Note: An Oracle E-Business Suite system can only be cloned    #
  # to the same, or a higher, major release of a platform         #
  # (operating system). For example, you can clone a system       #
  # running on Oracle Solaris 10 to run on Oracle Solaris 11,     #
  # but it is not supported to clone a system running on          #
  # Solaris 11 to run on Solaris 10.                              #
  #################################################################

  ###########################
  #File System Preparation  #
  ###########################

  # prepare stage 
include_recipe 'clone12_2::mk_dirs'
include_recipe 'clone12_2::mk_cookbks'
include_recipe 'clone12_2::mk_tmplts'

  # put down oracle home
include_recipe 'clone12_2::oracle_home'

  # downloading into stage and file systems.
include_recipe 'clone12_2::download_stage'

  # section 2 prerequisites
include_recipe 'clone12_2::section2'

  # prepare for dbms clone
include_recipe 'clone12_2::prep_dbms_clone'

  # do the dbms clone
include_recipe 'clone12_2::adcfgclone_dbms'

  # post dbms commands
include_recipe 'clone12_2::sqlnet_fix'

 # do the app server clone
include_recipe 'clone12_2::adcfgclone_apps'

  # downloading into stage and file systems.
include_recipe 'clone12_2::chk_p22761451'

  # updates the Forms web names
include_recipe 'clone12_2::section4_3'

  # Verify the APPLCSF setting
include_recipe 'clone12_2::section4_4'

  # Update the SESSION_COOKIE_DOMAIN
include_recipe 'clone12_2::section4_5'

  # SSL And SSO configuration
include_recipe 'clone12_2::section4_6'

  # Acvanced Cloning options
include_recipe 'clone12_2::section5'

  # Automating Rapid CLone
include_recipe 'clone12_2::section6'

  # Other Cloning Procedures
include_recipe 'clone12_2::section7'

  # Known Issues
include_recipe 'clone12_2::section8'

include_recipe 'clone12_2::cert_install'

include_recipe 'clone12_2::cert_run'
