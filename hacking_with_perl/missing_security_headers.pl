#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Parallel::ForkManager;
use Term::ANSIColor;

# Prompting user for the target website URL
print "Enter your target website URL (with 'https://'): ";
my $target_url = <STDIN>;
chomp $target_url;

# Validate URL
unless ($target_url =~ /^https:\/\//i) {
    die "Invalid URL. Please make sure to include 'https://' in the URL.\n";
}

# Creating a user agent object
my $ua = LWP::UserAgent->new;

# Setting up parallel processing
my $pm = Parallel::ForkManager->new(4); # Number of parallel processes

# List of security headers to check
my %security_headers = (
    "X-Content-Type-Options"    => "This header prevents MIME-sniffing attacks.",
    "X-Frame-Options"           => "This header prevents Clickjacking attacks.",
    "Content-Security-Policy"   => "This header helps prevent XSS, injection attacks, and other content-related attacks.",
    "Strict-Transport-Security" => "This header enforces the use of HTTPS for secure communication."
);

# Hash to store results
my %header_results;

# Sending parallel requests to the target URL
foreach my $header (keys %security_headers) {
    $pm->start and next;
    
    my $response = $ua->get($target_url);

    if ($response->is_success) {
        my %headers = $response->headers->flatten;
        $header_results{$header} = exists $headers{$header} ? 1 : 0;
    } else {
        $header_results{$header} = -1;
    }

    $pm->finish;
}

$pm->wait_all_children;

# Displaying results
print "\nChecking for Missing Security Headers:\n";

foreach my $header (keys %security_headers) {
    if ($header_results{$header} == 1) {
        print color("bold green"), "$header header is present.\n", color("reset");
    } elsif ($header_results{$header} == 0) {
        print color("bold red"), "Missing $header header!\n", color("reset");
        print color("yellow"), "Recommendation: $security_headers{$header}\n", color("reset");
    } else {
        print color("bold red"), "Failed to retrieve headers for $header.\n", color("reset");
    }
}

# Displaying how to fix the missing headers
print "\n";
print color("bold yellow"), "To fix the missing headers:\n", color("reset");
print "Ensure the web server configuration or application code includes the necessary headers:\n";
print "- X-Content-Type-Options: Add 'X-Content-Type-Options: nosniff' to the server response.\n";
print "- X-Frame-Options: Add 'X-Frame-Options: DENY' to prevent framing by other domains.\n";
print "- Content-Security-Policy: Implement a strict Content Security Policy to control resource loading and script execution.\n";
print "- Strict-Transport-Security: Enable HSTS by adding 'Strict-Transport-Security: max-age=31536000; includeSubDomains' to enforce HTTPS.\n";
