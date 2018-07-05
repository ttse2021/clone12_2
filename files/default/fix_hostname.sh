function cmd_to_exec {
  if test -z 'lsdev -C -S1 -F name -l inet0' ; then                                     
    mkdev -t inet                           
  fi                                     
  chdev -l inet0 -a hostname=$1         
  if [ -x /usr/sbin/hostid ]            ; then                                
    /usr/sbin/hostid `hostname`        
  if [ -x /usr/lib/lpd/pio/etc/piodmgr ]   ; then                                   
    /usr/lib/lpd/pio/etc/piodmgr -c > /dev/null 2>&1                                            
  fi                                           
  else                                        
    echo Could not find /usr/sbin/hostid       
  fi                                        
};
cmd_to_exec `hostname -s`
