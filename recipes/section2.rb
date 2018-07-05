log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}            *
     *                                       *
     *****************************************
    "

log '
     *****************************************
     * NOTHING TO DO HERE. Skipping          #
     *****************************************
    '


  ########################################
  # From: Doc ID 1383621.1               #
  #   Section 2: Prerequisite Tasks      #
  ########################################

  #################################################################
  # From: Doc ID 1383621.1                                        #
  # Note: If your E-Business Suite Release 12.2 Source instance   #
  #  is integrated with Oracle Access Manager 11gR2 (11.1.2)      #
  # and Oracle E-Business Suite AccessGate, refer to My Oracle    #
  # Support Knowledge Document 1614793.1, Cloning Oracle          #
  # E-Business Suite Release 12.2 Environments integrated with    #
  # Oracle Access Manager 11gR2 (11.1.2) and Oracle E-Business    #
  # Suite AccessGate.                                             #
  #################################################################

  #################################################################
  # From: Doc ID 1383621.1                                        #
  # Note:                                                         #
  # Before cloning a system with Rapid Clone, be sure to allow    #
  # any active online patching cycles to run all the way through  #
  # the final (cleanup) phase. In case patches are applied in     #
  # hotpatch or downtime mode, then you must run cleanup          #
  # phase of adop. For more information, refer to Oracle          #
  # E-Business Suite Maintenance Guide.  Then run fs_clone        #
  # to synchronize with the other file system, to avoid the       #
  # need for synchronization to be performed in the next          #
  # patching cycle. For more information, refer to Oracle         #
  # E-Business Suite Maintenance Guide.                           #
  #################################################################
