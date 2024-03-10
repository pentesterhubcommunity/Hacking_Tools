#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to make HTTP requests and check for CSP headers
sub check_csp {
    my $url = shift;
    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($url);
    
    unless ($response->is_success) {
        print color('red'), "Failed to fetch $url: ", $response->status_line, "\n";
        return;
    }

    my $csp_header = $response->header('Content-Security-Policy');
    if ($csp_header) {
        print color('green'), "CSP header found: $csp_header\n";
        print color('yellow'), "Target website might be using CSP.\n";
        print color('reset');
    } else {
        print color('red'), "No CSP header found.\n";
        print color('yellow'), "Target website might not be using CSP.\n";
        print color('reset');
        return;
    }

    # Perform additional checks here to test for CSP bypass vulnerabilities
    # For example, injecting inline scripts or styles, loading external resources

    # Example of how to test for inline script execution
    my $test_script = "<script>alert('CSP bypassed!')</script>";
    my $test_response = $ua->post($url, Content => $test_script);
    if ($test_response->decoded_content =~ /CSP bypassed/) {
        print color('red'), "Vulnerable to inline script execution!\n";
        print color('reset');
    } else {
        print color('green'), "Not vulnerable to inline script execution.\n";
        print color('reset');
    }

    # Add more tests for other potential CSP bypass vectors

}

# Main program
print "Enter your target website url: ";
my $target_url = <STDIN>;
chomp($target_url);

print "Checking CSP for $target_url...\n";
check_csp($target_url);
