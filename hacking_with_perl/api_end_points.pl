#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Headers;
use HTTP::Response;
use threads;
use Term::ANSIColor;

# Function to make HTTP requests
sub make_request {
    my ($url, $method) = @_;
    my $ua = LWP::UserAgent->new;
    my $request = HTTP::Request->new($method => $url);
    my $response = $ua->request($request);
    return $response;
}

# Function to test unprotected API endpoints
sub test_api_endpoints {
    my ($target_url) = @_;

    print "Testing for Unprotected API Endpoints vulnerability on: $target_url\n";

    # List of common and additional API endpoint paths to test
    my @api_endpoints = (
        '/api',
        '/api/v1',
        '/api/v2',
        '/api/v1/users',
        '/api/v1/products',
        '/api/v2/customers',
        '/api/v2/orders',
        '/api/v1/inventory',
        '/api/v1/payments',
        '/api/v2/transactions',
        '/api/v2/reviews',
        '/api/v1/settings',
        '/api/v1/messages',
        '/api/v2/news',
        '/api/v1/notifications',
        '/api/v2/subscriptions',
        '/api/v1/tickets',
        '/api/v1/comments',
        '/api/v2/categories',
        '/api/v1/files',
        '/api/v2/articles',
        '/api/v1/cart',
        '/api/v2/billing',
        '/api/v1/logs',
        '/api/v2/analytics',
        '/api/v1/tags',
        '/api/v2/security'
    );

    # Concurrently test each endpoint
    my @threads;
    foreach my $endpoint (@api_endpoints) {
        my $url = $target_url . $endpoint;
        push @threads, threads->create(\&test_endpoint, $url);
    }

    # Wait for all threads to finish
    foreach (@threads) {
        $_->join();
    }
}

# Function to test an individual endpoint
sub test_endpoint {
    my ($url) = @_;
    my $response = make_request($url, 'GET');
    my $status = $response->is_success ? "Success" : "Failed";
    my $color = $response->is_success ? "green" : "red";
    print colored("[$status] $url\n", $color);
    if ($response->is_success) {
        print colored("[Response] " . $response->decoded_content . "\n", "blue");
        print colored("[Potential Vulnerability] Unprotected API Endpoint found!\n", "yellow");
        print colored("[Exploit] Investigate the endpoint and its functionality for potential exploitation.\n\n", "yellow");
    }
}

# Main function
sub main {
    print "Enter your target website URL: ";
    my $target_url = <STDIN>;
    chomp($target_url);

    # Validate URL
    unless ($target_url =~ /^https?:\/\/\w+/i) {
        print "Invalid URL format. Please enter a valid URL.\n";
        return;
    }

    # Test for unprotected API endpoints
    test_api_endpoints($target_url);

    print "Testing complete.\n";
}

# Run the main function
main();
