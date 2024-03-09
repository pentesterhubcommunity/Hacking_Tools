#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to make HTTP requests and check for CMS information disclosure
sub check_vulnerability {
    my $url = shift;
    my $ua  = LWP::UserAgent->new;

    # Send request to the target website
    my $response = $ua->get($url);

    # Check if the response contains any CMS-related information
    if ($response->content =~ /<meta name="generator" content="([^"]+)"/i) {
        my $cms = $1;
        print colored("CMS Information Disclosure Vulnerability found!\n", 'red');
        print "Detected CMS: $cms\n";
        print "To test this vulnerability, try accessing sensitive URLs such as:\n";
        print "1. /wp-config.php (for WordPress)\n";
        print "2. /administrator/index.php (for Joomla)\n";
        print "3. /sites/default/settings.php (for Drupal)\n";
    } else {
        print colored("No CMS Information Disclosure Vulnerability found.\n", 'green');
    }
}

# Main program
print "Enter your target website URL: ";
my $target_url = <STDIN>;
chomp($target_url);

print "Checking for CMS Information Disclosure Vulnerabilities...\n";
print "This may take a moment...\n";

# Perform the vulnerability check
check_vulnerability($target_url);
