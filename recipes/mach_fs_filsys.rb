log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "
fslist=node[:clone12_2][:machprep][:newfs]


opts  = "-Ayes -prw -a agblksize=4096 -a isnapshot=no"
                               #options for the file system creation

  # for each quints, create the file system
  #
fslist.each_slice(5) do | quints |
  fs_mount, fs_size, vol_group, fs_log, fs_logsiz = quints

  execute "make_filesystem_#{fs_mount}" do
    user 'root'
    group node[:root_group]
    command "/usr/sbin/crfs -v jfs2 -g#{vol_group} -a size=#{fs_size} -m#{fs_mount} "\
                            "-a logname=#{vol_group}_loglv #{opts}"
    not_if "lsfs #{fs_mount} | fgrep #{fs_mount} > /dev/null 2>&1"
  end

  execute "mount_the_fs_#{fs_mount}" do
    user 'root'
    group node[:root_group]
    command "/usr/sbin/mount #{fs_mount}"
    not_if "/usr/bin/df #{fs_mount} | grep -q #{fs_mount} > /dev/null 2>&1"
  end


end

