log "
     *****************************************
     *                                       *
     *        Recipe:#{recipe_name}      *
     *                                       *
     *****************************************
    "

thisdir = node[:clone12_2][:ebsprep][:workingdir]

rootusr = 'root'
rootgrp = node[:root_group]

linkxlc="#{thisdir}/linkxlc"


fname="wget_linkxlc"
template "#{thisdir}/#{fname}.sh" do
  owner rootusr
  group rootgrp
  source "#{fname}.sh.erb"
  mode '770'
end

log "
     -----------------------------------
     - Installing linkxlc if needed    -
     -----------------------------------
    "

execute "download_linkxlc_files_to_#{linkxlc}" do
  user  rootusr
  group rootgrp
  creates        "#{thisdir}/#{fname}.t"
  command "ksh -x #{thisdir}/#{fname}.sh > "\
                 "#{thisdir}/#{fname}.out 2>&1 && touch "\
                 "#{thisdir}/#{fname}.t"
end

  # ok it exists, add to standard usr/bin driectory
thislnk = '/usr/vacpp/bin/linkxlC'
link '/usr/bin/linkxlC' do      #forward pointer
  to thislnk                    #actual  pointer
  only_if "test -f #{thislnk}"
end

