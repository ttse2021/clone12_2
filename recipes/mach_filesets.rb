log "
     **********************************************
     *                                            *
     *        Recipe:#{recipe_name}     *
     *                                            *
     **********************************************
    "

filesets = node[:clone12_2][:machprep][:chk_filesets]
symlinks = node[:clone12_2][:machprep][:chk_symlinks]


  # TODO: Make this a cookbook. version of xlc and AIX
  # Check version of xlC
  # CHefk version of AIX
  # AIX 7 (7.1)	
  #
  #    xlC.aix61.rte:11.1.0.1 or later1
  #    xlC.rte:11.1.0.1 or later1



  # Check that all filesets are installed
  # TODO: Make this a cookbook. Filesets installed
  #
filesets.each do |fset|
  execute "check_fileset_#{fset}" do
    user 'root'
    group node[:root_group]
    command "echo Fileset: #{fset} NOT FOUND ABORT; exit -1"
    not_if "lslpp -l #{fset}"
  end
end



symlinks.each do |fname|
  execute "utility_check_#{fname}" do
    user 'root'
    group node[:root_group]
    command "echo #{fname} NOT FOUND ABORT; exit -1"
    not_if { File.symlink?("#{fname}") }
  end
end

