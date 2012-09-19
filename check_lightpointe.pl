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
use Net::SNMP;
use lib "/usr/lib/nagios/plugins";
use utils qw($TIMEOUT %ERRORS &print_revision &support &usage);
use vars qw($opt_V $opt_h $opt_H $PROGNAME $VERSION);

$PROGNAME   = 'check_lightpointe.pl';
$VERSION    = '0.01';

#MIBs from LIGHTPOINTE-AMG.mib v1.6.1
#RSSI is returned in mV. Low RSSI is triggered if below that, high clears a low state and a SNMP trap is generated
my $amgRssi = '1.3.6.1.4.1.9256.1.5.2.1.0';
my $amgLowRssiThreshold = '1.3.6.1.4.1.9256.1.5.2.2.0';
my $amgRssiHighThreshold ='1.3.6.1.4.1.9256.1.5.2.3.0';
my $amgRssiOverload = '1.3.6.1.4.1.9256.1.5.2.4.0';
# 1 = overload
# 2 = alarm
my $amgTrackerStatus = '1.3.6.1.4.1.9256.1.5.2.9.0';
# 1 = tracker is on
# 2 = tracker is off
# 3 = tracker is unavailable
my $myAmgTemperature = '1.3.6.1.4.1.9256.1.5.2.10.0';
#return and integer in Celsius
my $amgHeaterThreshold ='1.3.6.1.4.1.9256.1.5.2.11.0';
my $amgHeaterHyst = '1.3.6.1.4.1.9256.1.5.2.12.0';
my $amgHeaterStatus = '1.3.6.1.4.1.9256.1.5.2.13.0';
# 1 = heater on
# 2 = heater off


sub print_help ();
sub print_usage ();

$ENV{'PATH'}='';
$ENV{'BASH_ENV'}='';
$ENV{'ENV'}='';

my $opt_c = 'public';

Getopt::Long::Configure('bundling');
GetOptions
    ("V"=> \$opt_V, "version"   => \$opt_V,
    "h" => \$opt_h, "help"      => \$opt_h,
    "H=s" => \$opt_H, "hostname=s"  => \$opt_H,
    "c=s" => \$opt_c, "community=s" => \$opt_c,  
);

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


my ($session, $error) = Net::SNMP->session(hostname=>$opt_H, 
                                            community=>$opt_c);
die "Session error: $error" unless ($session);

#print $amgRssi;
my $result = $session->get_request($amgRssi);
die "error: ".$session->error unless (defined $result);

print "RSSI: " . $result->{$amgRssi} . "\n";
