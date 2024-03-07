#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to send HTTP request and print response headers
sub check_security_headers {
    my $url = shift;

    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($url);

    if ($response->is_success) {
        print colored("HTTP Security Headers for $url:\n", 'blue');
        print "=========================================================\n";
        print colored("X-XSS-Protection: " . $response->header('X-XSS-Protection') . "\n", 'yellow');
        print colored("X-Content-Type-Options: " . $response->header('X-Content-Type-Options') . "\n", 'yellow');
        print colored("X-Frame-Options: " . $response->header('X-Frame-Options') . "\n", 'yellow');
        print colored("Content-Security-Policy: " . $response->header('Content-Security-Policy') . "\n", 'yellow');
        print "=========================================================\n";

        # Check for missing or insecure headers
        my $vulnerable = 0;
        unless ($response->header('X-XSS-Protection') && $response->header('X-Content-Type-Options') &&
                $response->header('X-Frame-Options') && $response->header('Content-Security-Policy')) {
            $vulnerable = 1;
        }

        if ($vulnerable) {
            print colored("Target website is vulnerable to HTTP Security Headers Misconfiguration!\n", 'red');
        } else {
            print colored("Target website is not vulnerable to HTTP Security Headers Misconfiguration.\n", 'green');
        }
    } else {
        print colored("Failed to retrieve headers for $url: " . $response->status_line . "\n", 'red');
    }
}

# Main
print "Enter your target website URL: ";
my $target_url = <STDIN>;
chomp($target_url);

print colored("\nTesting HTTP Security Headers Misconfiguration for: $target_url\n", 'green');
check_security_headers($target_url);

print colored("\nHow to Test HTTP Security Headers Misconfiguration:\n", 'blue');
print "1. Open your browser's developer tools (usually F12).\n";
print "2. Navigate to the 'Network' tab.\n";
print "3. Load the target website.\n";
print "4. Inspect the response headers for 'X-XSS-Protection', 'X-Content-Type-Options', 'X-Frame-Options', and 'Content-Security-Policy'.\n";
print "5. Ensure that these headers are correctly configured to prevent common security vulnerabilities.\n";
