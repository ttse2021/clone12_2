log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}     *
     *                                       *
     *****************************************
    "
  _maxuproc = node[:clone12_2][:machprep][:maxuproc]
  _ncargs   = node[:clone12_2][:machprep][:ncargs]


  # Typically the number of processes per user limit is small. fix
  #
  # /usr/sbin/chdev -l sys0 -a maxuproc=16384
  # /usr/sbin/lsattr -E -l sys0 | grep maxuproc
  # chdev -l sys0 -a ncargs=1024 
  # /usr/sbin/lsattr -E -l sys0 | grep ncargs
  # lsdev | grep iocp (should be available)
  # chdev -l iocp0 -P -a autoconfig=available

aix_chdev 'sys0' do
  attributes(maxuproc: _maxuproc, ncargs: _ncargs)
  need_reboot false
  action :update
end

  # This is needed for the Oracle DBMS install
  #
aix_chdev "iocp0" do
  attributes(:autoconfig => "available")
  need_reboot true
  action :update
end

