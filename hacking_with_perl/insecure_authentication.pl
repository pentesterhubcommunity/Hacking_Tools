#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Prompt user to enter target website URL
print color('bold cyan');
print "Enter your target website URL: ";
print color('reset');
my $target_url = <STDIN>;
chomp($target_url);

# Create a UserAgent object
my $ua = LWP::UserAgent->new;

# Send a HEAD request to the target URL
my $response = $ua->head($target_url);

# Check if the request was successful
if ($response->is_success) {
    # Check if the website is using HTTPS
    if ($response->request->uri->scheme eq 'https') {
        print color('bold green');
        print "The website is using HTTPS - Secure\n";
        print color('reset');
    } else {
        print color('bold red');
        print "The website is using HTTP - Insecure\n";
        print color('reset');
        print "\n";
        print color('bold yellow');
        print "Potential Risks:\n";
        print "* Credentials sent over unencrypted channels can be intercepted by attackers.\n";
        print "* Session hijacking attacks are more likely to succeed on insecure connections.\n";
        print "* Lack of transport layer security exposes sensitive data to eavesdropping.\n";
        print color('reset');
        
        # Check if the website accepts HTTPS connections
        if ($response->header('Accept-Encoding') =~ /https/i) {
            print color('bold yellow');
            print "The website supports HTTPS, but it's not enforced.\n";
            print "To mitigate the risk, enforce HTTPS by redirecting HTTP traffic to HTTPS.\n";
            print color('reset');
        }
        
        # Check if the website uses basic authentication
        if ($response->header('WWW-Authenticate') && $response->header('WWW-Authenticate') =~ /basic/i) {
            print color('bold yellow');
            print "The website uses Basic Authentication - Considered insecure as credentials are sent in base64 encoding.\n";
            print "Avoid using Basic Authentication for sensitive operations.\n";
            print color('reset');
        }
        
        # Check if the website uses HTTP Form authentication
        if ($response->header('WWW-Authenticate') && $response->header('WWW-Authenticate') =~ /form/i) {
            print color('bold yellow');
            print "The website uses HTTP Form Authentication - Ensure that the login page and submission form are served over HTTPS.\n";
            print "Implement additional security measures such as CSRF tokens to prevent session hijacking attacks.\n";
            print color('reset');
        }
    }
} else {
    print color('bold red');
    print "Failed to retrieve the website headers: " . $response->status_line . "\n";
    print color('reset');
}
