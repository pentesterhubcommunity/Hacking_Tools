#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to test for Session Fixation vulnerability
sub test_session_fixation {
    my $url = shift;

    my $ua = LWP::UserAgent->new;
    $ua->cookie_jar({});

    # Perform two requests, one without a session and one with a session
    my $response1 = $ua->get($url);
    my $response2 = $ua->get($url);

    # Extract session IDs from both responses
    my $session_id1 = extract_session_id($response1->decoded_content);
    my $session_id2 = extract_session_id($response2->decoded_content);

    # Check if the session IDs are the same
    if ($session_id1 && $session_id2 && $session_id1 eq $session_id2) {
        print color('red'), "Session Fixation Vulnerability Detected!\n", color('reset');
    } else {
        print color('green'), "No Session Fixation Vulnerability Detected.\n", color('reset');
    }
}

# Function to extract session ID from response content
sub extract_session_id {
    my $content = shift;

    # Regular expression to find session ID (example regex, adjust as needed)
    if ($content =~ /(?:sessionid|sid)=(\w+)/i) {
        return $1;
    }

    return undef;
}

# Main
print "Enter your target website URL: ";
my $target_url = <STDIN>;
chomp($target_url);

print "Testing for Session Fixation vulnerability on $target_url...\n";

test_session_fixation($target_url);
