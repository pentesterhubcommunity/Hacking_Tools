#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to check if the given URL is vulnerable to CSTI
sub check_vulnerability {
    my ($url) = @_;
    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($url);
    my $content = $response->decoded_content;
    
    if ($content =~ /{{.*?}}/) {
        return 1; # Vulnerable
    } else {
        return 0; # Not vulnerable
    }
}

# Function to display result with color
sub display_result {
    my ($url, $vulnerable) = @_;
    print "Target website: $url\n";
    if ($vulnerable) {
        print color('red'), "Vulnerable to Client-Side Template Injection!\n", color('reset');
        print "You can test the vulnerability by injecting {{alert('XSS')}} into input fields.\n";
    } else {
        print color('green'), "Not vulnerable to Client-Side Template Injection.\n", color('reset');
    }
}

# Main program
print "Enter your target website URL: ";
my $target_url = <STDIN>;
chomp $target_url;

print "Checking for vulnerability...\n";
my $is_vulnerable = check_vulnerability($target_url);

# Display result
display_result($target_url, $is_vulnerable);
