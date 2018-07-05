#!/usr/bin/perl

###################################################################
#
# (C) COPYRIGHT International Business Machines Corp. 1985, 1989
# All Rights Reserved
# Licensed Materials - Property of IBM
#
# This is an IBM Internal Tool delevoped to aid in understanding
# and examining Siebel Applications.  There is No official support.
# Use at your own risk. Developed for Siebel 7.7
###################################################################

# Oracle DocId: 1330701.1
# >> Networking
# >> 
# >> The key networking requirement is for the hosts file to 
# >> include an entry for the installation machine, 
# >> formatted as follows:
# >> 
# >> <IP address> <host name>.<domain name> <host name>

###################################################################
# HISTORY
# VER:         Date:     Description
#$VER="1.1"; # 10/06/16  Original tracking 
 $VER="1.2"; # 06/29/17  Fix issue with 127.0.0.1 and mluitiple lines
###################################################################


#----------------------------------------------------------------
#--  OPTION HANDLING  -------------------------------------------
#----------------------------------------------------------------
sub do_opts {
  my $man = 0, $help = 0;

  use Getopt::Long;
  $retval=GetOptions( 
            "view"      =>\$view,
            "u"         =>\$used,
            "f=s"       =>\$ifile,
            "dbg"       =>\$dbg,
            'help|?'    =>\$help,
            'man'       =>\$man
            ) ;

  # handles unknown options. (ARGV isnt empty!)
  if ( $ARGV[0] ) {
    print "Unprocessed by Getopt::Long\n";
    foreach (@ARGV) { print "$_\n"; }
    pod2usage(-message => "Unprocessed by Getopt::Long",
              -exitval => 2,
              -verbose => 0,
              -output  => \*STDERR);
  }

  #- Parse options and print usage if there is a syntax error,
  #- or if usage was explicitly requested.
  pod2usage(1)             if $help;
  pod2usage(-verbose => 2) if $man;

# #- If no arguments were given, then allow STDIN to be used only
# #- if it's not connected to a terminal (otherwise print usage)
#   pod2usage("$0: No files given.")  if ((@ARGV == 0) && (-t STDIN));

  return $retval;
}

# &do_opts or pod2usage(1) or die "do_opts failed\n" ;

#--------------------------------------------
#--  Main MAIN Program  ---------------------
#--------------------------------------------

# make sure that this host is in /etc/hosts file
#
$thishost=`hostname`;
chomp($thishost);
$thishost =~s/\..*$//;
$foundhost="false";

$hnfile="/etc/hosts";
if (defined($ifile) ) { $hnfile="$ifile"; }

$cmd="cat $hnfile";

sub prterr {
  $msg=$_[0];
  print; 
  print("$msg. Not Allowed\n"); 
}

open (CMDO, "$cmd |" ) or die ("Cannot open pipe on \'$cmd\' \n") ;
while ( <CMDO> ) {

  # skip comments
  next if ( /^\s*#/ ) ; # ignore comments
  next if ( /^\s*$/ ) ; # ignore white space lines

  ($ipaddr,$fqdn,$hostname,$other) = split;

#  next if ( $ipaddr =~ "127.0.0.1" );
  next if ( $ipaddr =~ "::1" );

  if ( $thishost eq $hostname ) { $foundhost="true"; }
  if ( /#/ )             { prterr("Comments within line. "); $failed="true"; next; }
  if ( $fqdn eq "" )     { prterr("Found only ipaddress. "); $failed="true"; next; }
  if ( $hostname eq "" ) { prterr("No hostname field.    "); $failed="true"; next; }
    

  #################################################################
  # Check 1
  # fqdn, remove the domain and fqdn should match the hostname
  $fqhostname = $fqdn;
  $fqhostname =~s/\..*$//;
  if ( $fqhostname ne $hostname ) {
    prterr("Fully qualified domain name does not match hostname");
    $failed="true";
  }

  #################################################################
  # Check 2
  # Only one line per ip address allowed. if need multiple they should
  # be of format: 
  # 127.0.0.1 <localhost1.localdomain1> <localhost1> <localhost2.localdomain2> <localhost2> ...
  if ( defined($registered{$ipaddr}) ) {
    prterr("multiple lines for same ipaddress"); 
    $failed="true";
  }
  $registered{$ipaddr}++;
}
close(CMDO);

if ( $foundhost ne "true" ) { 
  print("This host is not found in the $hnfile. Not allowed.\n");
  $failed="true";
}

if ( $failed eq "true" ) { exit(8); }

# Ok no errors. Cools
print("$hnfile checks out as valid for EBS\n");
exit(0);
