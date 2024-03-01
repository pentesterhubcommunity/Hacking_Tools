#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Headers;
use HTTP::Cookies;

# Define ANSI escape sequences for color formatting
my $color_red = "\e[31m";
my $color_green = "\e[32m";
my $color_reset = "\e[0m";

# Prompt for target website URL
print "Enter your target website URL: ";
my $url = <STDIN>;
chomp($url);

# Create user agent object with SSL certificate verification
my $ua = LWP::UserAgent->new(
    ssl_opts => {
        verify_hostname => 1,
    }
);
$ua->timeout(10);  # Set timeout to 10 seconds
$ua->agent("Mozilla/5.0");  # Set a custom User-Agent string

# Enable cookie handling
$ua->cookie_jar(HTTP::Cookies->new);

# Create HTTP request object
my $request = HTTP::Request->new(GET => $url);
$request->header('Accept' => 'text/html');  # Specify accepted content type

# Send request to target URL
my $response = $ua->request($request);

# Check for redirections
if ($response->is_redirect) {
    my $redirect_url = $response->header('Location');
    print "Redirected to: $redirect_url\n";
    $request = HTTP::Request->new(GET => $redirect_url);
    $response = $ua->request($request);
}

# Check for errors
if ($response->is_success) {
    # Check for Web Cache Deception vulnerability
    if ($response->header('X-Cache')) {
        print $color_red, "The website is vulnerable to Web Cache Deception.\n", $color_reset;
        print "X-Cache Header: ", $response->header('X-Cache'), "\n";
    } else {
        print $color_green, "The website is not vulnerable to Web Cache Deception.\n", $color_reset;
    }
    # Print response details
    print "HTTP Response Code: ", $response->code, "\n";
    print "Response Headers:\n", $response->headers_as_string, "\n";
} else {
    print $color_red, "Error: ", $response->status_line, "\n", $color_reset;
}
