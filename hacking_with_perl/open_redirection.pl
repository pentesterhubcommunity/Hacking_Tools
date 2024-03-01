#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;

print "Enter your target website link: ";
my $target_url = <STDIN>;
chomp($target_url);

my $redirect_url = "https://www.bbc.com";

# Initialize LWP UserAgent
my $ua = LWP::UserAgent->new;

# Send a request with the redirection URL
my $response = $ua->get("$target_url?redirect=$redirect_url");

# Extract status code and effective URL from the response
my $status_code = $response->code;
my $effective_url = $response->request->uri;

# Color codes
my $RED = "\033[0;31m";
my $GREEN = "\033[0;32m";
my $NC = "\033[0m"; # No Color

# Check if the response status code indicates a successful redirection
if ($status_code >= 300 && $status_code < 400 && $effective_url eq $redirect_url) {
  print "${GREEN}Vulnerable: Open Redirection exists${NC}\n";
} elsif ($status_code >= 300 && $status_code < 400) {
  print "${RED}Potentially Vulnerable: Redirection occurred but not to the specified URL${NC}\n";
} elsif ($status_code < 200 || $status_code >= 400) {
  print "${RED}Not Vulnerable: HTTP request failed with status code $status_code${NC}\n";
} else {
  print "${RED}Not Vulnerable: Redirection did not occur${NC}\n";
}
