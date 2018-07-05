  #Wed Oct  5 12:06:27 PDT 2016


  #-------------------------------------------------------
  # hdisk SAS Attributes
  #-------------------------------------------------------
  #
  #   TBD
   
  #-------------------------------------------------------
  # FILE SYSTEMS REQUIRED
  #-------------------------------------------------------
  #
  
  #----------------------------------------------------
  # This cookbook installation follows:               #
  #   Cloning Oracle E-Business Suite Release 12.2    #
  #   with Rapid Clone (Doc ID 1383621.1)             #
  #   LAST UPDATED: 01-Aug-2016A                      #
  #                                                   #
  # If the document is updated, You'll have to review #
  # the cookbook for updates                          #
  #                                                   #
  #----------------------------------------------------

  #----------------------------------------------------------------
  # From: Doc ID 1383621.1                                        #
  # Note: When cloning, ensure that you specify the actual        #
  # locations for the directories involved, so that AD utilities  #
  # can properly identify the directories afterward. Do not use   #
  # symbolic links to specify directory locations.                #
  #----------------------------------------------------------------
  # THEREFORE: For this image of 12.2.6 clone Install, The paths  #
  # must not change. You must put this clone at /d01/oracle/VIS   #
  #----------------------------------------------------------------

default[:clone12_2][:fs___ebs][:name]     = '/d01'
default[:clone12_2][:fs_stage][:name]     = '/d02'


default[:clone12_2][:fs_stage][:bin]      = "#{node[:clone12_2][:fs_stage][:name]}/bin"
default[:clone12_2][:fs___ebs][:bin]      = "#{node[:clone12_2][:fs___ebs][:name]}/bin"
default[:clone12_2][:fs_stage][:log]      = "#{node[:clone12_2][:fs_stage][:name]}/log"
default[:clone12_2][:fs___ebs][:log]      = "#{node[:clone12_2][:fs___ebs][:name]}/log"
default[:clone12_2][:fs_stage][:tmp]      = "#{node[:clone12_2][:fs_stage][:name]}/tmp"
default[:clone12_2][:fs___ebs][:tmp]      = "#{node[:clone12_2][:fs___ebs][:name]}/tmp"


default[:clone12_2][:root][:env] = {
    'HOME'     => '/',
    'LOGIN'    => 'root',
    'LOGNAME'  => 'root',
    'USER'     => 'root',
    'ENV'      => '/.kshrc',
    'LOCPATH'  => '/usr/lib/nls/loc:/usr/vacpp/bin',
    'NLSPATH'  => '/usr/lib/nls/msg/%L/%N:/usr/lib/nls/msg/%L/%N.cat:'\
                  '/usr/lib/nls/msg/%l.%c/%N:/usr/lib/nls/msg/%l.%c/%N.cat:'\
                  '/usr/vacpp/bin',
    'PATH'     => '/usr/bin:/etc:/usr/sbin:/usr/ucb:/usr/bin/X11:/sbin:'\
                  '/usr/java5/jre/bin:/usr/java5/bin:/usr/vacpp/bin:'\
                  '/usr/lpp/ssp/bin:/usr/lib/instl/:/usr/sbin:/usr/bin:'\
                  '/usr/lpp/ssp/rcmd/bin:/var/sysman:/etc/auto:/usr/lpp/csd/bin:'\
                  '/usr/lpp/mmfs/bin:/opt/ibmll/LoadL/full/bin:/usr/sbin/rsct/bin:'\
                  '/usr/lpp/LoadL/full/bin:/usr/bin/lsf/bin:/usr/bin/lsf/etc:'\
                  '/opt/csm/bin:/usr/lpp/ssp/local/bin:/vol/local/sbin:'\
                  '/vol/local/etc:/vol/local/bin::/usr/opt/ifor/ls/os/aix/bin:'\
                  '/opt/LicenseUseManagement/bin',
    'SHELL'    => '/usr/bin/ksh',
    'DSH_PATH' => '/bin:/usr/bin:/usr/bin:/etc:/usr/sbin:/usr/ucb:/usr/bin/X11:'\
                  '/sbin:/usr/java5/jre/bin:/usr/java5/bin:/usr/vacppDSH_PATH=/bin:'\
                  '/usr/bin:/usr/bin:/etc:/usr/sbin:/usr/ucb:/usr/bin/X11:/sbin:'\
                  '/usr/java5/jre/bin:/usr/java5/bin:/usr/vacpp/bin:'\
                  '/usr/lpp/ssp/bin:/usr/lib/instl/:/usr/sbin:/usr/bin:'\
                  '/usr/lpp/ssp/rcmd/bin:/var/sysman:/etc/auto:/usr/lpp/csd/bin:'\
                  '/usr/lpp/mmfs/bin:/opt/ibmll/LoadL/full/bin:/usr/sbin/rsct/bin:'\
                  '/usr/lpp/LoadL/full/bin:/usr/bin/lsf/bin:/usr/bin/lsf/etc:'\
                  '/opt/csm/bin:/usr/lpp/ssp/local/bin:/vol/local/sbin:'\
                  '/vol/local/etc:/vol/local/bin:',
    'LANG'     => 'en_US',
    'LANGUAGE' => 'en_US',
    'LC_ALL'   => 'en_US',
    'TERM'     => 'vt100'
    }

default[:clone12_2][:user]        = 'oracle'
default[:clone12_2][:group]       = 'oinstall'
default[:clone12_2][:sid]         = 'VIS'
default[:clone12_2][:orabase]     = "#{node[:clone12_2][:fs___ebs][:name]}/oracle/"\
                                    "#{node[:clone12_2][:sid]}"

  #---------------------------------------------------------------
  # this is the position within the UTL_FILE_DIR within the dbms
  # to see: 
  # SELECT value FROM V$PARAMETER WHERE NAME = 'utl_file_dir';
  # Count the directories from left to right starting at 1
  # in this dbms the /tmp is in the 2nd position
  #
default[:clone12_2][:appltmppos]  = '2'
default[:clone12_2][:appltmpdir]  = '/tmp'


default[:clone12_2][:oracle][:env] = {
    'LANG'            => "en_US",
    'LOGIN'           => "oracle",
    'CLCMD_PASSTHRU'  => "1",
    'PATH'            => "/usr/ccs/bin:/usr/bin:/etc:/usr/sbin:/usr/ucb:"\
                         "/home/oracle/bin:/usr/bin/X11:/sbin:.",
    'LC__FASTMSG'     => "true",
    'LOGNAME'         => "oracle",
    'MAIL'            => "/usr/spool/mail/oracle",
    'LOCPATH'         => "/usr/lib/nls/loc:/opt/IBM/xlC/13.1.3/bin:"\
                         "/opt/IBM/xlc/13.1.3/bin",
    'USER'            => "oracle",
    'AUTHSTATE'       => "files",
    'SHELL'           => "/usr/bin/ksh",
    'ODMDIR'          => "/etc/objrepos",
    'HOME'            => "/home/oracle",
    'HOMES'            => "/home/oracle/homes",
    'TERM'            => "vt100",
    'TZ'              => "America/Los_Angeles",
    'ORABASE'         => "#{node[:clone12_2][:orabase]}",
    'NLSPATH'         => "/usr/lib/nls/msg/%L/%N:/usr/lib/nls/msg/%L/%N.cat"\
                         ":/usr/lib/nls/msg/%l.%c/%N"\
                         ":/usr/lib/nls/msg/%l.%c/%N.cat"\
                         ":/opt/IBM/xlC/13.1.3/bin"\
                         ":/opt/IBM/xlc/13.1.3/bin",
    'EDITOR'          => "/usr/bin/vi",
    'AIXTHREAD_SCOPE' => "s",
    'EXINIT'          => "set showmode showmatch dir=/tmp",
    'HHOME'           => "/home/oracle/homes",
    'HOSTN'           => "#{node[:hostname]}",
    'MAILMSG'         => "[YOU HAVE NEW MAIL]",
    'WHOME'           => "oracle",
    'SID'             => "#{node[:clone12_2][:sid]}",
    }

default[:clone12_2][:runfs]     = "#{node[:clone12_2][:fs_stage][:log]}/RUNFS"
default[:clone12_2][:patchfs]   = "#{node[:clone12_2][:fs_stage][:log]}/PATCHFS"
default[:clone12_2][:dbms_oh]   = "#{node[:clone12_2][:orabase]}/12.1.0"

  #------------------------------------------
  # passwords used
  #
default[:clone12_2][:apps_usr]     = 'apps'
default[:clone12_2][:apps_pw]      = 'apps'
default[:clone12_2][:weblogic_pw]  = 'welcome1'
default[:clone12_2][:system_pw]    = 'manager'  #dbms system/manager account


  #------------------------------------------
  # wget directories and paths
  #
default[:clone12_2][:wget_head] ="129.40.71.31/CHEF/link.CHEF/staging_dirs/12_2_clone"
default[:clone12_2][:wget_version]  ="1227"
default[:clone12_2][:wget_cert] ="#{node[:clone12_2][:wget_head]}/cert_kit/"

  #------------------------------------------
  # download directories and paths
  #
  # versions are 1226 and 1227
default[:clone12_2][:tgz_dir] = "file:///repos/CHEF/staging_dirs/12_2_clone/"\
                                 "#{node[:clone12_2][:wget_version]}"
default[:clone12_2][:tgz_file] = "oracle_VIS.tgz"


  #Wed Oct  5 12:06:27 PDT 2016

     #***********************************************#
     #**                                          ***#
     #**          Machine Prepartion Vars         ***#
     #**                                          ***#
     #***********************************************#

  #----------------------------------------
  # temp dir where we run jobs during prep
  #----------------------------------------
  #
default[:clone12_2][:machprep][:workingdir] = '/tmp/machprep'

  #----------------------------------------
  # nfs mounts we want permanent
  #
  # Add in triplets, with form as 
  #    localmnt,remote_mount, remote_host"
  # for each triplet
  #----------------------------------------
default[:clone12_2][:machprep][:mounts] = [ '/repos','/repos','p134n31' ]


  #----------------------------------------
  # kernel attributes that will be changed
  #----------------------------------------
  #
default[:clone12_2][:machprep][:ncargs]   = 1024
default[:clone12_2][:machprep][:maxuproc] = 16384

  #---------------------------------------------------
  # Minimum memory requirements
  #---------------------------------------------------
  #
default[:clone12_2][:machprep][:minimum_memory]         = 16384      # in Megabytes

  #---------------------------------------------------
  # Swap/paging space requirements with ability to ignore.
  # if :swapspace_ignore is set to true
  #---------------------------------------------------
  #
default[:clone12_2][:machprep][:swapspace_ignore]  = false
default[:clone12_2][:machprep][:swapspace]         = 16384      # in Megabytes


  #------------------------------------
  # Kernel required filesets
  #------------------------------------
  # Note: IF YOU ADD HERE. UPDATE THE PRECHECK SCRIPTS!
  #
  # #EBS - denotes required for EBS 12.2.6
default[:clone12_2][:machprep][:chk_filesets] = [
   'bos.adt.base',         # /usr/bin/make                      #EBS
   'bos.adt.lib',                                               #EBS
   'bos.adt.libm',                                              #EBS
   'bos.perf.libperfstat',                                      #EBS
   'bos.perf.perfstat',                                         #EBS
   'bos.perf.proctools',                                        #EBS
   'rsct.basic.rte',                                            #EBS
   'rsct.compat.clients.rte',                                   #EBS
   'X11.motif.lib',                                             #EBS
#   'vacpp.cmp.tools',      #/usr/vacpp/bin/linkxlC              #EBS
   'openssh.base.server',  #chef needs
   'expect.base',          #cookbook needs
   'bos.rte.security',     #/usr/bin/chpasswd
   'bos.rte.bind_cmds',    #/usr/bin/ar, /usr/bin/ld
   'bos.loc.com.utf',      #chef needs THESE are en_US.UTF-8
   'bos.loc.utf.EN_US',    #chef needs THESE ARE en_US.UTF-8
  ]

default[:clone12_2][:machprep][:chk_symlinks]       = [ '/usr/bin/ar',   '/usr/bin/ld',
                                            '/usr/bin/make', ]

default[:clone12_2][:machprep][:fs_sizes]   = [ 

     #Doc Id: 1383621.1 Verify disk space requirements on Source System 
     #    Ensure the Source System has enough free disk space. Oracle Fusion 
     #    Middleware cloning tools require 6GB in /tmp and 6GB under $COMMON_TOP.
     # So i'm assuming the target will someday be the source, and want 6GB free

   # mount, total(GB), Needed(GB)
       '/',    '256M',     '256M',
    '/usr',      '2G',       '1G',
    '/var',    '512M',     '512M',
    '/tmp',      '1G',       '5G',
    '/opt',      '1G',     '512M',
   '/home',    '512M',     '512M',
    ]

  # Note: password of 'NOCHG' makes the password not changed at all. see mkusers.rb for details
  # Note: dont put root in here!
  # There is two linew per user. starts with 'user' and must also have the ulimits even if you want defaults
  # So make sure you have both. So far, just one user is being created.
  #
default[:clone12_2][:machprep][:mkusers] = [ 
     #      user,    uid,        grp,     gid,   password,   home_directory,
        'oracle', '1201', 'oinstall',  '1000',   'oracle',   '/home/oracle',
        # -- 2nd line --                                     ulimits Fields,
            'fsize=-1 data=-1 stack=-1 rss=-1 core=-1 cpu=-1 nofiles=65536',
  ]

        
default[:clone12_2][:machprep][:newvgs] = [ 
                                 #vgname,     ppsiz(MB),                hdisks [,,]
                             #----------      ----------     -----------------------
                             'clonevg',           '128',     [ 'hdisk1', 'hdisk2', ] 
  ]

default[:clone12_2][:machprep][:newfs] = [
                             #mountpoint         size        volgroup  logfile   logsize(MB)
                             #__________   __________      __________  _______   ___________
                                  '/d01',      '395G',      'clonevg', 'd01log', '800',
                                  '/d02',      '395G',      'clonevg', 'd02log', '800',
  ]


default[:clone12_2][:machprep][:linux][:tools] = [ 
   'bash'               ,
   'binutils'           ,
   'curl'               ,
   'diffutils'          ,
   'findutils'          ,
   'hexedit'            ,
   'less'               ,
   'mawk'               ,
   'p7zip'              ,
   'rxvt'               ,
   'screen'             ,
   'sudo'               ,
   'tar'                ,
   'unzip'              ,
   'vnc'                , 
   'wget'               ,
   'zip'                , 
  ]


     #***********************************************#
     #**                                          ***#
     #**          ebsprep Variables               ***#
     #**                                          ***#
     #***********************************************#

default[:clone12_2][:ebsprep][:workingdir] = '/tmp/ebsprep'

  #----------------------------------------
  # Minimum filesets for EBS. Needs checking
  #----------------------------------------
default[:clone12_2][:ebsprep][:filesets2check] = [
    #FILESET:           #MIN VERSION
    'xlC.aix61.rte',    '13.1.2.0',
    'xlC.rte',          '13.1.2.0',
   ]

default[:clone12_2][:ebsprep][:fs_stage][:name]     = '/d02'

default[:clone12_2][:ebsprep][:wget_xlinkxlc]="129.40.71.31/CHEF/link.CHEF/staging_dirs/12_2_clone/linkxlc/"


# from man page of /etc/host:
#   format should be:   IP_address canonical_hostname [aliases...]
default[:clone12_2][:ebsprep][:etchosts][:triplets] = [
    '127.0.0.1',        'localhost.localdomain',        [ 'localhost', 'loopback',],
    '129.40.105.161',     'nim1.pbm.ihost.com',         [ 'nim1',],
    '129.40.71.51',    'p135n51.pbm.ihost.com',         [ 'p135n51',],
]

  #------------------------------------
  # Kernel required filesets
  #------------------------------------
  # Note:
  #  this check is also within machprep. But here are the ones specific to EBS
  #  ASSUMES machprep check of filesets have been done!!!!
  #
default[:clone12_2][:ebsprep][:ebs_filesets] = [
   'vacpp.cmp.tools',      #/usr/vacpp/bin/linkxlC              #EBS
  ]

  # Note:
  #  this check is also within machprep. But here we keep linkxlC here
  #  WARNING: ASSUMES machprep check of filesets have been done!!!!
  #
default[:clone12_2][:ebsprep][:ebs_symlinks]       = [ '/usr/bin/linkxlC' ]
