#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use Term::ANSIColor;

# Prompt user for target website URL
print color('bold cyan'), "Enter your target website URL: ", color('reset');
my $url = <STDIN>;
chomp $url;

# Set timeout for HTTP requests (in seconds)
my $timeout = 10;

# Create a UserAgent object with custom User-Agent string
my $ua = LWP::UserAgent->new(agent => 'Mozilla/5.0');

# Set timeout for HTTP requests
$ua->timeout($timeout);

# Perform asynchronous HTTP requests
my @requests = (
    HTTP::Request->new(GET => $url),
    # Add more requests if needed
);

# Array to store responses
my @responses;

foreach my $request (@requests) {
    push @responses, $ua->request($request);
}

# Process responses
foreach my $response (@responses) {
    if ($response->is_success) {
        my $content = $response->decoded_content;
        
        # Test for Unencrypted Data Storage vulnerability
        if ($content =~ /\b(?:password|credit card|social security number)\b/i) {
            print color('bold red'), "Vulnerability Found: Unencrypted Data Storage\n";
            print color('bold yellow'), "How to test for this vulnerability: ";
            print "Look for any sensitive information (e.g., passwords, credit card numbers, social security numbers) being transmitted or stored in plain text format within the website's source code or HTTP responses.\n";
            
            # Log the vulnerability
            open(my $log_fh, '>>', 'vulnerability_log.txt') or die "Error: $!";
            print $log_fh "Vulnerability Found: Unencrypted Data Storage on $url\n";
            close($log_fh);
        } else {
            print color('bold green'), "No Unencrypted Data Storage vulnerability found on $url\n";
        }
    } else {
        print color('bold red'), "Error: Unable to retrieve content from $url\n";
        print color('bold yellow'), "HTTP Status Code: ", $response->code, "\n";
        print color('bold yellow'), "Error Message: ", $response->status_line, "\n";
    }
}
