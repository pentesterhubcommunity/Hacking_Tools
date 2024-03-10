#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to test if a debug endpoint exists
sub test_debug_endpoint {
    my $url = shift;

    my @debug_endpoints = (
        "debug",
        "debug.php",
        "debug.jsp",
        "debug.aspx",
        "debug.txt",
        "debug.log",
        "trace",
        "trace.php",
        "trace.jsp",
        "trace.aspx",
        "trace.txt",
        "trace.log",
        "info",
        "info.php",
        "info.jsp",
        "info.aspx",
        "info.txt",
        "info.log"
    );

    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);

    foreach my $endpoint (@debug_endpoints) {
        my $target_url = $url . "/" . $endpoint;
        my $response = $ua->get($target_url);

        if ($response->is_success) {
            print colored("[+] Vulnerable: $target_url\n", 'green');
            return 1;
        }
    }

    print colored("[-] Not vulnerable: No debug endpoints found\n", 'red');
    return 0;
}

# Main program
sub main {
    print "Enter your target website url: ";
    my $target_website = <STDIN>;
    chomp $target_website;

    print "Testing for Exposed Debug Endpoints on $target_website...\n";

    if (test_debug_endpoint($target_website)) {
        print "\nTo further test the vulnerability, try accessing the debug endpoints listed above in a web browser or using a tool like curl.\n";
    }
}

main();
