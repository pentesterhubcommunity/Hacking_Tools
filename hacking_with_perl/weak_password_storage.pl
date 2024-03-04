#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;
use threads;
use Thread::Queue;

# Maximum number of threads to run simultaneously
my $max_threads = 5;

# Initialize thread queue
my $queue = Thread::Queue->new();

# Prompt user for target website URLs
print "Enter target website URLs (one per line, empty line to finish):\n";
my @urls;
while (my $url = <STDIN>) {
    chomp $url;
    last if $url eq ''; # Stop input when empty line is entered
    push @urls, $url;
}

# Function to check for weak password storage vulnerability
sub check_vulnerability {
    my ($url) = @_;

    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->agent("Mozilla/5.0");

    my $response = $ua->get($url);
    my $result;

    if ($response->is_success) {
        my $content = $response->decoded_content;

        # Example check: analyzing HTTP headers for secure password storage practices
        if ($response->header('X-Content-Hash') && $response->header('X-Content-Hash') eq 'SHA256') {
            $result = "$url: Secure password storage practices detected.";
        } else {
            $result = "$url: Potential weak password storage vulnerability detected.";
        }
    } else {
        $result = "$url: Failed to retrieve website content.";
    }

    return $result;
}

# Worker thread subroutine
sub worker {
    while (my $url = $queue->dequeue_nb()) {
        my $result = check_vulnerability($url);
        print_result($result);
    }
}

# Function to print result with appropriate color
sub print_result {
    my ($result) = @_;

    if ($result =~ /Failed/) {
        print color('yellow');
    } elsif ($result =~ /Potential weak password storage/) {
        print color('red');
    } else {
        print color('green');
    }

    print $result, "\n";
    print color('reset');
}

# Create and start worker threads
my @threads;
for (1 .. $max_threads) {
    push @threads, threads->create('worker');
}

# Enqueue URLs
$queue->enqueue(@urls);

# Wait for all threads to finish
$_->join() foreach @threads;
