#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Prompt user to enter the target website URL
print "Enter your target website URL: ";
my $url = <STDIN>;
chomp $url;

# Create a user agent object
my $ua = LWP::UserAgent->new;
$ua->timeout(10);

# Send a GET request to the target website
my $response = $ua->get($url);

# Check if the request was successful
unless ($response->is_success) {
    print color('red'), "Failed to retrieve website: ", $response->status_line, "\n", color('reset');
    exit;
}

my $content = $response->decoded_content;

# Check for potential DOM Clobbering vulnerability
if ($content =~ /\<\!DOCTYPE html\>/i && $content =~ /document\.write/i) {
    print color('green'), "The target website is potentially vulnerable to DOM Clobbering!\n", color('reset');
    print color('yellow'), "To test the vulnerability, try injecting a script that overwrites existing DOM properties.\n", color('reset');
    print color('yellow'), "For example:\n", color('reset');
    print color('yellow'), "<script>document.domain='attacker.com';</script>\n", color('reset');
    print color('yellow'), "Replace 'attacker.com' with the attacker-controlled domain.\n", color('reset');
} else {
    print color('green'), "The target website does not appear to be vulnerable to DOM Clobbering.\n", color('reset');
}
