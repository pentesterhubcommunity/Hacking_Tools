#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder;
use Term::ANSIColor;

# Function to send requests and check for LFI vulnerability
sub test_lfi {
    my $url = shift;

    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    my $response = $ua->get($url);

    if ($response->is_success) {
        my $content = $response->decoded_content;

        # Check for common LFI indicators in HTML content
        if ($content =~ /Include Function Warning|Warning.*failed|<\?php include\(/) {
            print color('red');
            print "The target website may be vulnerable to LFI!\n";
            print "Further manual testing is recommended.\n";
            print color('reset');
            return;
        }

        # Check for LFI parameters in URLs
        my $tree = HTML::TreeBuilder->new->parse($content);
        my @links = $tree->look_down('_tag', 'a');
        foreach my $link (@links) {
            my $href = $link->attr('href');
            if ($href && $href =~ /(?:\?|&)file=([^&]+)/) {
                my $file_param = $1;
                print color('red');
                print "The target website may be vulnerable to LFI!\n";
                print "The 'file' parameter value is: $file_param\n";
                print "Check if the 'file' parameter is vulnerable to LFI.\n";
                print color('reset');
                return;
            }
        }

        # Check for potential directory traversal vulnerability in script URLs
        foreach my $link (@links) {
            my $href = $link->attr('href');
            if ($href && $href =~ /\.\.\//) {
                print color('yellow');
                print "The target website may be vulnerable to directory traversal!\n";
                print "Check if the script URLs allow directory traversal.\n";
                print color('reset');
                return;
            }
        }

        print color('green');
        print "The target website does not appear to be vulnerable to LFI or directory traversal.\n";
        print color('reset');
    } else {
        print color('yellow');
        print "Failed to connect to the target website: ", $response->status_line, "\n";
        print color('reset');
    }
}

# Main program
sub main {
    print "Enter your target website URL: ";
    my $target_url = <STDIN>;
    chomp $target_url;

    print "Testing for LFI vulnerability on: $target_url\n";
    print "Please wait...\n";

    test_lfi($target_url);
}

main();
