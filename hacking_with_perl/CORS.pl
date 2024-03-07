#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use Term::ANSIColor;

# Prompt user for target website URL
print "Enter your target website URL: ";
my $target_url = <STDIN>;
chomp $target_url;

# Verify HTTPS protocol
if ($target_url !~ /^https:/) {
    print color('bold red'), "Error: Target website URL must use HTTPS.\n";
    exit;
}

# Initialize UserAgent
my $ua = LWP::UserAgent->new;
$ua->timeout(10); # Set timeout to 10 seconds
$ua->max_redirect(5); # Follow up to 5 redirects

# Array to hold multiple requests
my @requests = ();

# Add requests with different Origin headers for parallel testing
push @requests, HTTP::Request->new(GET => $target_url, ['Origin' => 'https://evil.com']);
push @requests, HTTP::Request->new(GET => $target_url, ['Origin' => 'https://attacker.com']);

# Send requests in parallel
my @responses = $ua->request(@requests);

# Check responses for CORS misconfiguration vulnerability
my $vulnerability_found = 0;
for my $response (@responses) {
    if ($response->is_success) {
        # Check if 'Access-Control-Allow-Origin' header exists
        if ($response->header('Access-Control-Allow-Origin')) {
            # Check if CORS misconfiguration vulnerability exists
            if ($response->header('Access-Control-Allow-Origin') eq '*') {
                print color('bold green'), "CORS Misconfiguration Vulnerability Found!\n";
                print "Access-Control-Allow-Origin header allows requests from any origin.\n";
                $vulnerability_found = 1;
                last; # Exit loop if vulnerability found
            }
        } else {
            print color('bold yellow'), "Warning: 'Access-Control-Allow-Origin' header not found in response.\n";
        }
    } else {
        print color('bold red'), "Error: Unable to fetch response from $target_url.\n";
        print "HTTP Status: ", $response->status_line, "\n";
    }
}

# If vulnerability not found, display message
if (!$vulnerability_found) {
    print color('bold red'), "No CORS Misconfiguration Vulnerability Found.\n";
}

# Instructions on how to check for CORS vulnerability
print color('bold blue'), "\nTo check for CORS vulnerability, inspect the response headers of your website's HTTP responses.\n";
print "Look for the 'Access-Control-Allow-Origin' header. If it allows requests from all origins ('*') or from untrusted sources, it's vulnerable.\n";
print "Additionally, test the website using different origins to see if the header is properly restricted.\n";
