#!/usr/bin/perl
#use strict;
#use warnings;

###################################################################
#
#   (C) Copyright IBM Corp. 2003 All rights reserved.
#
# This is an IBM Internal Tool developed to aid in managing
# and examining Siebel Applications.  There is no official IBM
# support.  Use at your own risk. Developed for Siebel 7.7 and v8.0
#
###################################################################


###################################################################
# cerrs.pl - Collate and summarize Siebel Application Server errors
###################################################################


###################################################################
# HISTORY
# Vers:   Date:     Description
# v3.0	  3/20/17   Original tracking
# v3.1	  3/22/17   gets rid of date stamps
# v3.2	  11/29/17  Converted to use with EBS.
###################################################################
my $VER = 3.2;


my $dbg=0;
my $IGFILE= "./iglist";
my $listoffiles="";
my $bleepat="UNSET";
my $acceptableerrno=0;
my $thisfile="";
my %deletes;
my %sblobjmgr;
my %bleeps;
my %errlist;
my %fnerrs;
my %numlist;
my @flist;
my $dflt_cols;
my $ferrcnt;
my $filecnt;
my $fn;
my $foundone;
my $getopts;
my $outf;
my $rest;
my $tmpfn;
my $tmpk;
my $totcnt;
my $bleepsub;
my $num;
my $nextline;
my $tmpmgr;
my $key;
my $SID;
my $HN;
my $SIDHOME;
my $erronly;


#----------------------------------------------------------------
#--  OPTION HANDLING  -------------------------------------------
#----------------------------------------------------------------
sub do_opts {
  my $man = 0;
  my $help = 0;
  my $retval=0;

  use Getopt::Long;
  $retval=GetOptions(
            "view"      =>\$view,
            "dbg=i"     =>\$dbg,
            "merge"     =>\$merge,
            "l=s"       =>\$listoffiles,
            "f=s"       =>\$thisfile,
            "bleep=s"   =>\$bleepat,
            "a=i"       =>\$acceptableerrno,
            "ign=s"     =>\$useigfile,
            "c=i"       =>\$scols,
            "erronly=i" =>\$erronly,
            "version"  =>\$version,
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

&do_opts or pod2usage(1) or die "do_opts failed\n" ;



#----------------------------------------------------------------
#-- USED IN SORTING HASH ARRAYS NUMERICALLY ---------------------
#----------------------------------------------------------------
sub numerically { $a <=> $b }


sub consume_file {

  # called with consume_file(fn,\%param)
  my $_fn=$_[0];
  my $_hashtbl = $_[1];
  my $_errc;
  my $_toterrs=0;
  my $f1;
  my $f2;
  my $f3;
  my $f4;
  my $f5;
  my $thispat;
  my $found1;

  open (_FN, $_fn) or die "Cannot open $_fn to read\n" ;
  while ( <_FN> ) {

    #lines that are not errors, so ignore
    next if ( /^\s*$/ ) ;
    next if ( /^\s*\)\s*$/ ) ; # skip symantic info

    # skip if matches deleted lines
    undef($nextline);
    for $thispat (keys %deletes) {
	if ( /$thispat/ ) { $nextline=1; last; }
    }
    next if ($nextline==1) ;

    # Fix bleeps.
    for $thispat (keys %bleeps) {
      my @count = $thispat =~ /\(\.\*\)/g;
      my $numpat=scalar @count;
      #print("Dollar1 is: $1 Numpat: $numpat\n");


      if ( /$thispat/ )                      { 
        #print("Dollar1 is: $1 Numpat: $numpat\n");
         $_ =~s ^$1^$bleepsub^; 
      }
      if ( $numpat >=2 ) { if ( /$thispat/ ) { $_ =~s /$2/$bleepsub/; } }
      if ( $numpat >=3 ) { if ( /$thispat/ ) { $_ =~s /$3/$bleepsub/; } }
    }

    #--------------------------------------------------------
    # Lets get rid of src code location info in all errlines
    #--------------------------------------------------------
    chomp;

    # Print if matches triggers
    $found1="false";
    for $thispat (keys %triggers) {
      if ( /\b${thispat}\b/i ) {
	$found1="true";
        if ( $dbg > 0 ) { print(" FOUND: $thispat in TRIGGERS\n"); }
        last;
      }
#      if ( /^$thispat\s+/i ) {
#	$found1="true";
#        if ( $dbg > 0 ) { print(" FOUND: $thispat in TRIGGERS\n"); }
#        last;
#      }
#      if ( /\s+$thispat$/i ) {
#	$found1="true";
#        if ( $dbg > 0 ) { print(" FOUND: $thispat in TRIGGERS\n"); }
#        last;
#      }
    }

   

    next if ( $found1 eq "false" ) ;

    # ok rest of lines are errors.
    $_toterrs++;
    next if ( $erronly > 0 );


    #----------------------------------------------------------------
    # If we opted for viewing the file in VI. save each line for later
    #----------------------------------------------------------------
    if ( defined ($view) ) {
      if ( ! defined ($fnerrs{$_fn}) ) {
        # first time save file name...
        $fnerrs{$_fn} = "\n$_fn:\n\n" ;
      }
      $fnerrs{$_fn} .= "$_\n";
    }

    #---------------------------------------------------------------
    # No, then for rest we use
    #---------------------------------------------------------------
    ($f1,$f2,$f3,$f4,$f5,$rest) = split(/\t/,$_,6);

    if ( $rest ne '' ) {
      $_errc = substr($rest,0,$scols);
      $$_hashtbl{$_errc} += 1;
      next;
    }

    #---------------------------------------------------------------
    # This catches everything else
    #---------------------------------------------------------------
    $$_hashtbl{$_} += 1;
  }

  close (_FN);

  return $_toterrs;

} # consume_file

sub read_actions{
  my $loc=$_[0];
  my $section="";

  open (FIL, "$loc") or die ("Cannot open file $loc \n") ;
  while ( <FIL> ) {
    
    $section="", next if ( /^}/ )     ; # skip symantic info

    if ( $section eq "" ) {
      next if ( /^\s*#/ )     ;   # skip comments
      next if ( /^\s*$/ )     ;   # skip blank lines
    }
  
    $section="TRIGGERS",next if ( /TRIGGERS{/ ) ; # skip semantic lines
    $section="DELETE",  next if ( /DELETE{/   ) ; # skip semantic lines
    $section="BLEEP",   next if ( /BLEEP{/    ) ; # skip semantic lines

    chomp($_);
    if ($section eq "DELETE") {
      $deletes{$_}=1;
      next;
    }
    if ($section eq "BLEEP") {
      $bleeps{$_}=1;
      next;
    }
    if ($section eq "TRIGGERS") {
      $triggers{$_}=1;
      next;
    }
    print "INVALID line found: $_\n";
  }
  close(FIL);
}

#----------------------------------------------------------------
#-- Main Section   ----------------------------------------------
#----------------------------------------------------------------

$HN=`hostname`; chomp($HN);

if ( defined($version) ) { die "$0\t\t\tVersion: $VER\n"; }

#----------------------------------------------------------------
#-- INITIALIZATON  ----------------------------------------------
#----------------------------------------------------------------


# Column Width...
$dflt_cols=70;
if (! defined($scols) ) { $scols = $dflt_cols; }

# CUTE TRICK. Allow opts to be specified via env var.
$getopts=$ENV{'GETERR_OPTS'};
if ( $getopts ne '') {
  @ARGV = split(/ /,$getopts);
  &do_opts or pod2usage(1) or die "do_opts failed\n" ;
}

if ( ($listoffiles eq "") && ($thisfile eq "") ) {
  die "Must use -f or -listfile\n" ;
}

#----------------------------------------------------------------
# WE SUPPORT AIX
#----------------------------------------------------------------
if ( $dbg > 0 ) { print "OS is $^O\n"; }


#QQ #----------------------------------------------------------------
#QQ # Read commone prefix file        -------------------------------
#QQ #----------------------------------------------------------------
#QQ if (! defined $ENV{'CERTDIR'}) { die "Cannot find ENV: $CERTDIR\n"; }
#QQ $CERTDIR=$ENV{'CERTDIR'};
#QQ 
#QQ $igfile_pfx="$CERTDIR/bin/IGLIST.prefix";
#QQ if ( ! -f $igfile_pfx ) { die "Cannot find $igfile_pfx\n"; }
#QQ &read_actions($igfile_pfx); 

#----------------------------------------------------------------
# Read in the ignore list         -------------------------------
#----------------------------------------------------------------

if (defined($useigfile)) { $IGFILE=$useigfile; }
&read_actions($IGFILE); 


$bleepsub="bleep";
#----------------------------------------------------------------
# Let bleep be an option
#----------------------------------------------------------------
if ($bleepat ne "UNSET") { $bleepsub=$bleepat; }

$outf    = "/tmp/cerrs.tmp.$$";


#----------------------------------------------------------------
# We write everything to outfile. then show it to user
#----------------------------------------------------------------
open (OUTF,"> $outf") or die "Cannot open $outf for write\n" ;


#----------------------------------------------------------------
# OK, go to log dir and for each log file....
#----------------------------------------------------------------
if ( $thisfile ne "" )    { push(@flist,$thisfile); }

if ( $listoffiles ne "" ) { 
  my $TMPF;
  open  (  $TMPF, $listoffiles) or die "Cannot open $listoffiles to read\n" ;
  while ( <$TMPF> ) {
    chomp;
    push(@flist,$_); }
  close($TMPF);
}

$filecnt = scalar(@flist); #number of files found...

foreach $fn ( @flist ) {
  print "FILENAME: $fn\n";

  #---------------------------------------------------------------
  # Save the error count using just the COMPNAME.
  #---------------------------------------------------------------
  $tmpfn = $fn;
  $tmpfn =~ s/\.log$// ;

  if (!defined($merge)) {
    $ferrcnt = &consume_file($fn,\%{$tmpfn});
  } else {
    $ferrcnt = &consume_file($fn,\%errlist);
  }

  $sblobjmgr{$tmpfn} += $ferrcnt;
  if ( $dbg > 0 ) { print "Objmgr: $tmpfn ERRORS: $ferrcnt\n"; }

  # save total error count too
  $totcnt += $ferrcnt;

}

#---------------------------------------------------------------
### END File processing
#---------------------------------------------------------------
#---------------------------------------------------------------
# NOW ON TO FORMATTING AND DISPLAYING
#---------------------------------------------------------------


if ( $erronly > 0 ) {
  print OUTF "\tTOTAL NUMBER OF FILES WITH ERRORS:\t $totcnt (Logfiles: $filecnt) \n\n" ;
} else {
  print OUTF "\tTOTAL NUMBER OF ERRORS:\t $totcnt (Logfiles: $filecnt) \n\n" ;
}

#---------------------------------------------------------------
# We want the compnames sorted by error count
#---------------------------------------------------------------
foreach $tmpk ( keys %sblobjmgr) {
  $numlist{$sblobjmgr{$tmpk}} = $tmpk;
}
# ok problem. that it removed duplicates. so we will lose info.
# need to now use the unique values to find the objmgrs...
#
foreach $num ( reverse sort numerically keys %numlist ) {
  if ( $dbg > 0 ) { print "Num: $num\n"; }
  next if ( $num == 0 ) ; # skip if no errors
  foreach $tmpmgr ( keys %sblobjmgr ) {
    if ( $dbg > 0 ) { print "252:Num: $sblobjmgr{$tmpmgr} for $tmpmgr\n"; }
    if ( $num == $sblobjmgr{$tmpmgr} ) {
      if ( $dbg > 0 ) { print "$num equals $sblobjmgr{$tmpmgr}\n"; }
      $foundone=1;
      printf OUTF "  %s: %d", $tmpmgr, $sblobjmgr{$tmpmgr};
    }
  }
}
if ($foundone == 1 ) { print OUTF "\n\n"; }


if (! ($erronly > 0) ) {
  if (!defined($merge)) {
    foreach $tmpmgr ( keys %sblobjmgr ) {
      if ( $sblobjmgr{$tmpmgr} == 0 ) {
        next;
      } else {
        print OUTF "$tmpmgr:\n";
        &do_errsumary(\%{$tmpmgr});
      }
    }
  } else {
    &do_errsumary(\%errlist);
  }
}


sub do_errsumary {
  my $tmpelist = $_[0];
  my $ec;
  my $fmtp1;

    #------------------------------------------------
    # Ok Now Put out the error summary, again sorted
    #------------------------------------------------
    foreach $ec ( keys %$tmpelist) { $numlist{$$tmpelist{$ec}} +=1; }
    foreach $num ( reverse sort numerically keys %numlist ) {
      foreach $ec ( keys %$tmpelist) {
        if ( $num == $$tmpelist{$ec} ) {
          $fmtp1="%-6ld %.${scols}s\n";
          printf OUTF $fmtp1, $$tmpelist{$ec}, $ec;
        }
      }
    }
    print OUTF "\n" ;
}

#---------------------------------
#--- Ok Lets display the results
#---------------------------------
if ( defined ($view) ) {
  # Ok. User wants to see errors in VI file...
  foreach $key (keys %fnerrs) { print OUTF $fnerrs{$key} ; }
}

# ok we're done with output file
close (OUTF);

if ( defined ($view) ) {
  system "vi $outf" ;
} else {
  #Dislay to stdout
  open  (  READF, $outf) or die "Cannot open $outf to read\n" ;
  while ( <READF> ) { print ; }
  close   (READF) ;
}



# ok get rid of temp file
unlink($outf);

if ( $totcnt != $acceptableerrno ) {
  print("Errors found. totcnt: $totcnt Acceptable: $acceptableerrno : Aborting...\n");
  exit(-99); 
} 

if ( $acceptableerrno != 0 ) {
  print("INFO: Used Acceptable Error Count to bypass Failure\n");
}

#===========================================================
#===========================================================
#===========================================================
#EVERYTHING after __END__ is ignored by perl, below is the
#help info used by pod_usage
#===========================================================

use Pod::Usage;
__END__

=head1 NAME

cerrs.pl - Collate and summarize Siebel Application Server errors

=head1 SYNOPSIS

cerrs.pl
[-help|?]
[-man]
[-version]
[-view]
[-c colwidth]
[-erronly]
[-ign]
[-dir dirpath]
[-s  server_name]
[-r  siebel_dir]
[-e  siebel_enterprise]

 Options:
   -help            brief help message
   -man             full documentation
   -version         Displays the version number
   -view            Create a text file of actual errors.
   -c               Sets the size of the width
   -erronly=#       Just shows a count of files with errors if num > 0
   -ign             Use the ignore file list to ignore these errors
   -dir             Override and use this directory to file logfiles
   -dbg=#           Print errors if number is greater than 0
   -r               Override environement variable SIEBEL_ROOT
   -s               Override environement variable _IBM_SERVER_NAME
   -e               Override environement variable _IBM_ENTERPRISE_NAME
   -bleep="pattern" Used with ign. Pattern for bleeping
   -logs="file_pat" Use file_pat for identifying target log files

=head1 DESCRIPTION

B<This program> will find *_enu*.log files within the directory:
${SIEBEL_ROOT}.${_IBM_ENTERPRISE_NAME}.${_IBM_SERVER_NAME}/log

It produces a summary of errors.  Actual errors can
be seen with the [-view] option, which creates a temporary file.

By default, no options are needed, and assumes that you are running
as the siebel user. IT looks for the following environment variables
to be defined and correct for default execution:

	SIEBEL_ROOT
	_IBM_ENTERPRISE_NAME
	_IBM_SERVER_NAME

If these environment variables are not found, it is still
possible to use the command, by providing the directory
location using the -dir option, or overriding the environment variables

Environment Variables

GETERR_OPTS environment variable can be used to fix the default
options, rather than to add them to the command line. For example,
if you wish each invocation of cerr.pl to use a 50 column width, and
to use the ignore file then,
you could set GETERR_OPTS="-c 50 -ign"

Ignore File Syntax

The perl variable $IGFILE defines the location of the ignore file.
If the file exists and cerrs.pl is invoked with -ign, then the file
is used to filter which errors to ignore. The format of the IGFILE
is a list of patterns to ignore, using section identifiers.
There is a DELETE{ section identifier, and a BLEEP{ section
identifier. The DELETE section is for deleting lines you wish to ignore.
example:
DELETE{
insert_your_patterns_here
}
The BLEEP section uses (.*) pattern matching to remove detail.
This removal then allows the line to match others without detail.

example:
BLEEP{
Cannot resume process (.*)
/files/siebelfs/userpref/EMPL(.*)
}

=cut
