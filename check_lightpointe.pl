#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#Author: John Lowry <johnlowry@gmail.com>
#Date: Sept. 18 , 2011
#Version: 0.01
#Description: 
#License: GPLv3
#-----------------------------------------------------------------------------

use strict;
use Getopt::Long;
use lib "/usr/lib/nagios/plugins";
use utils qw($TIMEOUT %ERRORS &print_revision &support &usage);
use vars qw($opt_V $opt_h $PROGNAME $VERSION);

$PROGNAME   = 'check_lightpointe.pl';
$VERSION    = '0.01';

sub print_help ();
sub print_usage ();

$ENV{'PATH'}='';
$ENV{'BASH_ENV'}='';
$ENV{'ENV'}='';

Getopt::Long::Configure('bundling');
GetOptions
        ("V"   => \$opt_V, "version"            => \$opt_V,
         "h"   => \$opt_h, "help"               => \$opt_h);

if ($opt_V){
        print_revision($PROGNAME, $VERSION); 
        exit $ERRORS{'OK'};
}

if ($opt_h){
        print_help();
        exit $ERRORS{'OK'};
}

sub print_usage() {
    print "Usage: $PROGNAME\n";
}    

sub print_help() {
    print_revision($PROGNAME, $VERSION);
    print "Copyright (c) 2011 John Lowry. 
This plugin reports the status of a Lightpointe freespace optics system.";
    print_usage();
    support();
};

