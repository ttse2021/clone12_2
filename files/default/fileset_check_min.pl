#!/usr/bin/perl -w

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

use strict;
use warnings;
use Getopt::Std;


###################################################################
# HISTORY
# Vers:   Date:     Description
# v1.1	  11/18/15   Original tracking
###################################################################

my $dbg="";
my $fileset="not_set";
my $minver="not_set";

#----------------------------------------------------------------
#--  OPTION HANDLING  -------------------------------------------
#----------------------------------------------------------------
sub do_opts {
  my $man = 0, my $help = 0;
  my $version;

  use Getopt::Long;
  my $retval=GetOptions( 
            "fileset=s"    =>\$fileset,
            "minimum=s"    =>\$minver,
            "dbg"         =>\$dbg,
            "version"     =>\$version,
            'help|?'      =>\$help,
            'man'         =>\$man
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

&do_opts or pod2usage(1) or die "do_opts failed\n" ;

if ( $minver  eq "not_set" ) { pod2usage(-verbose => 1); }
if ( $fileset eq "not_set" ) { pod2usage(-verbose => 1); }
#----------------------------------------------------------------
#--  FUNCTIONS        -------------------------------------------
#----------------------------------------------------------------

sub turn_into_number{
  my $wxyz=$_[0];
  my $numflds=0;
  my $multiplier=1;
  my $mintotal=0;
  my @fields=split('\.',$wxyz);

  $numflds=@fields;

  #print("numflds: $numflds\n");
  if ($numflds != 4 )  {
    print("ERROR: minimum field must be of format: x.x.x.x.",
          " where x can be a number between 0 and 99\n");
    exit -1;
  }

  # turn minversion into a number. Like this
  #  Suppose you have WW.XX.YY.ZZ
  #  1M*WW + 10K*XX + 100*YY +1*ZZ"
  foreach my $val ( reverse @fields )  {
    $mintotal=($val*$multiplier)+$mintotal;
    $multiplier=$multiplier*100;
  }
  
  return($mintotal);
  
}

#----------------------------------------------------------------
#----------------------------------------------------------------
# Main Program
#----------------------------------------------------------------
#----------------------------------------------------------------


my $value;
my $ver;
my $techlvl;
my $svcpack;
my $tlsp;
my $min72;
my $CMD;
my $cmd;
my $dc; # dc - dont care
my $thisfs;
my $thisver;
my $os_num;

# this version value was found from the Oracle Doc ID: 1330703.1
#

my $minnum=turn_into_number($minver);

$cmd="lslpp -lc $fileset";
open ($CMD, "$cmd |")  or die("Cant open $cmd\n");
while ( <$CMD> ) {
  next if ( /#Fileset:Level:/ );
  # example: /usr/lib/objrepos:xlC.rte:13.1.3.1::COMMITTED:I:IBM XL C++ Runtime for AIX :
  ($dc,$thisfs,$thisver,$dc,$dc,$dc,$dc)=split(':');
  if ($thisfs eq $fileset) {
     $os_num=turn_into_number($thisver);    
  }
}
close($CMD);


print("\nTesting Fileset:      $fileset\n");
print("OS Version:      $thisver\tinNumber: $os_num\n");
print("Minimum Version: $minver\tinNumber: $minnum  \n");
if ($os_num < $minnum ) {
  print("ERROR::   OS Ver:   $thisver is lower than the Minimum required version.\n\n");
  exit 64;
}

print("OS Ver: $thisver passes minimum version check.\n\n");

exit 0;
#===========================================================
#===========================================================
#===========================================================
#EVERYTHING after __END__ is ignored by perl, below is the
#help info used by pod_usage
#===========================================================

use Pod::Usage;
__END__

=head1 NAME

fileset_check_min.pl - Check if the OS meets minimum OS level

=head1 SYNOPSIS

fileset_check_min.pl -fileset <fileset_prefix> -minimum <W.X.Y.Z>
                        [-help|?] [-man]

 Options:
   -help                 brief help message
   -man                  full documentation
   -fileset              fileset_name without version_info
   -minimum <W.X.Y.Z>    version number in 4 tuplets.


=head1 DESCRIPTION

B<This program> checks the os level of an AIX file set and errors
if the AIX fileset level is less than the minimum level.

The Oracle Document ID: 1330703.1 defines the Xlc versions required.

Example: 
    perl fileset_check_min.pl --fileset='xlC.rte'  --minimum='13.1.2.0'

Testing Fileset:      xlC.rte
OS Version:      13.1.3.1       inNumber: 13010301
Minimum Version: 13.1.2.0       inNumber: 13010200  
OS Ver: 13.1.3.1 passes minimum version check.

=cut
