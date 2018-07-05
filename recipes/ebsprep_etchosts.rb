log '**********************************************
     *                                            *
     *        Recipe:#{recipe_name}          *
     *                                            *
     **********************************************
    '
list    = node[:clone12_2][:ebsprep][:etchosts][:triplets]
thisdir = node[:clone12_2][:ebsprep][:workingdir]


execute "save_etchosts_file_2_b4chef" do
  user  'root'
  group node[:root_group]
  creates               "/etc/hosts.b4chef"
  command "mv /etc/hosts /etc/hosts.b4chef && touch /etc/hosts"
end


list.each_slice(3) do | triplet |
  ipaddr,chostn,akas  = triplet
  aix_etchosts chostn do
    ip_address ipaddr
    aliases akas
    action :add
  end
end

  # get the machine host, ipaddress and fully qualified domain name fqdn

cookbook_file "#{thisdir}/chk_hosts.pl" do
  owner 'root'
  group node[:root_group]
  mode '0755'
  source 'chk_hosts.pl'
end

execute "Check_that_etc_hosts_is_valid" do
  user  'root'
  group node[:root_group]
  command "perl #{thisdir}/chk_hosts.pl > #{thisdir}/out.chk_hosts 2>&1 && "\
                "touch #{thisdir}/t.chk_hosts"
   creates            "#{thisdir}/t.chk_hosts"
end

template "#{thisdir}/chk_hostname.pl" do
  source 'chk_hostname.pl.erb'
  owner 'root'
  group node[:root_group]
  mode '770'
end

execute "Check_that_hosts_is_without_fqdn" do
  user  'root'
  group node[:root_group]
  command "perl #{thisdir}/chk_hostname.pl > #{thisdir}/out.chk_hostname 2>&1 && "\
                "touch #{thisdir}/t.chk_hostname"
   creates            "#{thisdir}/t.chk_hostname"
end

