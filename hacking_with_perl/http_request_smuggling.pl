#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to send HTTP request and check for response
sub check_vulnerability {
    my $url = shift;

    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($url);

    # Check if response contains any indication of vulnerability
    if ($response->is_success && $response->decoded_content =~ /smuggled/i) {
        return 1; # Vulnerable
    } else {
        return 0; # Not Vulnerable
    }
}

# Function to display colored output
sub print_colored {
    my ($text, $color) = @_;
    print color($color), $text, color('reset');
}

# Main program
sub main {
    # Ask for target website URL
    print "Enter your target website URL: ";
    my $target_url = <STDIN>;
    chomp($target_url);

    # Check for vulnerability
    print "Testing for HTTP Request Smuggling vulnerability on $target_url...\n";
    my $is_vulnerable = check_vulnerability($target_url);

    # Display results
    if ($is_vulnerable) {
        print_colored("The target is vulnerable to HTTP Request Smuggling!\n", 'green');
        print_colored("To test the vulnerability, you can try sending crafted requests to exploit it.\n", 'yellow');
        print_colored("Make sure to verify and validate the results carefully.\n", 'yellow');
    } else {
        print_colored("The target is not vulnerable to HTTP Request Smuggling.\n", 'red');
    }
}

# Execute main program
main();
