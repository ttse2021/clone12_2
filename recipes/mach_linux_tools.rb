log "
     ******************************************
     *                                        *
     *        Recipe:#{recipe_name}     *
     *                                        *
     ******************************************
    "


  #install missing linux tools that chef may need
  #
node[:clone12_2][:machprep][:linux][:tools].each do |pack|
  aix_toolboxpackage pack do
    action :install
  end
end

