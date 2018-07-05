log "
     **********************************************
     *                                            *
     *        Recipe:#{recipe_name}     *
     *                                            *
     **********************************************
    "
   #####################################################################
   # This script instructions are defined in doc id: 1330703.1
   #
   # Context in file:
   #  Customers on existing 12.2 systems should already be running at 
   #  least Oracle Web Tier 11.1.1.7 (11gR1 PS6) or higher on the 
   #  source system. These customers must also apply patch 22761451 
   #  with the following steps prior to cloning.
   #
   #  If this triggers. Ack. it means the pre-clone phase wasn't done
   #  with this patch. You would need to go back and fix. Sigh
   #####################################################################


stgtmp   =node[:clone12_2][:fs_stage][:tmp] 
stglog   =node[:clone12_2][:fs_stage][:log]
stgbin   =node[:clone12_2][:fs_stage][:bin]
orausr   =node[:clone12_2][:user]
oragrp   =node[:clone12_2][:group]
oraenv   =node[:clone12_2][:oracle][:env]

fname="p22761451_111190_AIX64-5L"
execute "unzip_patch_#{fname}_2_tmp" do
  user  orausr
  group oragrp
  env  ( oraenv )
  cwd  stgtmp
  creates     "#{stglog}/#{fname}.t"
  command "unzip -o #{stgbin}/#{fname}.zip > "\
              "#{stglog}/#{fname}.out 2>&1 && touch "\
              "#{stglog}/#{fname}.t"
end

fname="chk_p22761451"
execute "dircmp_of_patch_with_image_#{fname}" do
  user  orausr
  group oragrp
  env  ( oraenv )
  cwd  stgtmp
  creates     "#{stglog}/#{fname}.t"
  command "ksh #{stgbin}/#{fname}.sh > "\
              "#{stglog}/#{fname}.out 2>&1 && touch "\
              "#{stglog}/#{fname}.t"
end
