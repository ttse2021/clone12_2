log "
     **********************************************
     *                                            *
     *        Recipe:#{recipe_name}                 *
     *                                            *
     **********************************************
    "

filesets = node[:clone12_2][:ebsprep][:ebs_filesets]
symlinks = node[:clone12_2][:ebsprep][:ebs_symlinks]

  # Check that all filesets are installed
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

