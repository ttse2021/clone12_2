log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "

vglist=node[:clone12_2][:machprep][:newvgs]

  # triplets of file system space req's
  #
vglist.each_slice(3) do | triplet |
  vg_name, vg_pps, vg_disks = triplet
  
  DISKS=vg_disks.join(" ")
  loglv="#{vg_name}_loglv"

  execute "make_volume_group_#{vg_name}" do
    user 'root'
    group node[:root_group]
    command "/usr/sbin/mkvg -S -y#{vg_name} -s#{vg_pps} -f #{DISKS}"
    not_if "lsvg #{vg_name} | fgrep #{vg_name} > /dev/null 2>&1"
  end

  execute "make_loglv_for_#{vg_name}" do
    user 'root'
    group node[:root_group]
    command "/usr/sbin/mklv -y#{loglv} -t'jfs2log' #{vg_name} 32 #{DISKS}"
    not_if "lsvg -l #{vg_name} | fgrep #{loglv} > /dev/null 2>&1"
  end
end
