#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to check if a header is present in the response
sub check_header {
    my ($response, $header) = @_;
    return $response->header($header) ? 1 : 0;
}

# Function to print colored output
sub print_colored {
    my ($message, $color) = @_;
    print color($color), $message, color('reset');
}

# Prompt for the target website URL
print_colored("Enter your target website URL: ", 'bold');
my $target_url = <STDIN>;
chomp $target_url;

# Initialize UserAgent
my $ua = LWP::UserAgent->new;

# Send request to the target URL
my $response = $ua->get($target_url);

# Check if the request was successful
unless ($response->is_success) {
    print_colored("[!] Failed to retrieve response from $target_url\n", 'red');
    exit;
}

# Extract headers from the response
my $headers = $response->headers_as_string;

# Check for potential data leakage vulnerabilities
my @vulnerabilities;
push @vulnerabilities, "Server" if check_header($response, 'Server');
push @vulnerabilities, "X-Powered-By" if check_header($response, 'X-Powered-By');

# Display vulnerability results
if (@vulnerabilities) {
    print_colored("[!] Potential data leakage vulnerabilities found:\n", 'red');
    foreach my $vuln (@vulnerabilities) {
        print_colored("    - $vuln header is present\n", 'red');
    }
} else {
    print_colored("[*] No evidence of data leakage vulnerabilities found.\n", 'green');
}

# Display testing instructions
print_colored("\n[*] Testing Instructions:\n", 'blue');
print_colored("    - Check for the presence of sensitive information in HTTP response headers, such as 'Server' and 'X-Powered-By'.\n", 'blue');
print_colored("    - Analyze response bodies for unintentionally exposed data.\n", 'blue');
