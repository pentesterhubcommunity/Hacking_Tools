#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to send HTTP request and capture response
sub send_request {
    my ($url) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    my $response = $ua->get($url);
    return $response->content;
}

# Function to test for session hijacking vulnerability
sub test_vulnerability {
    my ($url) = @_;
    my $response1 = send_request($url);
    my $response2 = send_request($url);

    if ($response1 eq $response2) {
        return 1; # Vulnerability detected
    } else {
        return 0; # No vulnerability detected
    }
}

# Function to print colored output
sub print_colored {
    my ($message, $color) = @_;
    print color($color), $message, color('reset');
}

# Main code
print_colored("Enter your target website URL: ", 'cyan');
my $target_url = <STDIN>;
chomp $target_url;

print_colored("Testing for session hijacking vulnerability on: $target_url\n", 'cyan');

if (test_vulnerability($target_url)) {
    print_colored("Vulnerability Detected: Session Hijacking Possible!\n", 'red');
} else {
    print_colored("No Vulnerability Detected: Session Hijacking Not Possible.\n", 'green');
}

print_colored("\nTo test the vulnerability, try logging in to the website in two different browsers or sessions. Then, compare the session IDs captured from both sessions. If they are the same, it indicates a session hijacking vulnerability.\n", 'yellow');
