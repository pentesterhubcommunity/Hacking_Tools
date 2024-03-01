#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;

# Create a new user agent object
my $ua = LWP::UserAgent->new;

# Prompt the user to enter the target website URL
print "Enter your target website URL: ";
my $url = <STDIN>;
chomp $url;

# Make a GET request to the URL
my $response = $ua->get($url);

# Check if the response was successful
if ($response->is_success) {
    print "SSRF Vulnerability found! Able to access: $url\n";
    print "Response:\n", $response->decoded_content, "\n";
} else {
    print "No SSRF Vulnerability found. Unable to access: $url\n";
    print "Response status: ", $response->status_line, "\n";
}
