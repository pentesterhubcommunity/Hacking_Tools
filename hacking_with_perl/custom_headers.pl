#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to test for custom header vulnerability
sub test_custom_header_vulnerability {
    my $url = shift;

    # Create a UserAgent object
    my $ua = LWP::UserAgent->new;

    # Add custom headers to the request
    $ua->default_header('X-Test-Header' => 'Testing');

    # Send a GET request to the target URL
    my $response = $ua->get($url);

    # Check if the response includes the custom header
    if ($response->header('X-Test-Header')) {
        print colored("The target website is vulnerable to Custom Header Vulnerabilities.\n", 'green');
    } else {
        print colored("The target website is not vulnerable to Custom Header Vulnerabilities.\n", 'red');
    }
}

# Main program
print "Enter your target website URL: ";
my $target_url = <STDIN>;
chomp($target_url);

print "Testing for Custom Header Vulnerabilities on $target_url...\n";

# Call the function to test for vulnerability
test_custom_header_vulnerability($target_url);

# Explanation on how to test the vulnerability
print "\nTo test the vulnerability, you can use tools like curl or Postman to send a request with a custom header, ";
print "such as 'X-Test-Header: Testing', and observe if the header is reflected in the response.\n";
