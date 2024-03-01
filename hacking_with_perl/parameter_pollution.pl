use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder;

# Prompt user for target website URL
print "Enter your target website URL: ";
my $url = <STDIN>;
chomp $url;

# Create a UserAgent object
my $ua = LWP::UserAgent->new;

# Send request to the target website
my $response = $ua->get($url);

unless ($response->is_success) {
    die "Failed to fetch the website: ", $response->status_line;
}

# Parse HTML content to extract parameters
my $content = $response->decoded_content;
my $tree = HTML::TreeBuilder->new;
$tree->parse($content);

# Collect parameters from forms
my %params;
for my $form ($tree->find('form')) {
    for my $input ($form->find('input')) {
        my $name = $input->attr('name');
        next unless defined $name;
        push @{$params{$name}}, '';
    }
}

$tree->delete;

# Iterate over each parameter and test for parameter pollution
foreach my $param (keys %params) {
    print "Testing parameter: $param\n";
    
    # Iterate over each payload for the parameter
    foreach my $payload (@{$params{$param}}) {
        # Construct the request
        my $request = HTTP::Request->new(POST => $url);
        $request->content_type('application/x-www-form-urlencoded');
        $request->content("$param=$payload");
        
        # Send the request
        my $response = $ua->request($request);
        
        # Check the response
        if ($response->is_success) {
            # Analyze the response for signs of parameter pollution
            # Here you can check for unexpected behavior, error messages, etc.
            print "Payload '$payload' for parameter '$param' resulted in a successful response.\n";
            print "Response body:\n", $response->content, "\n";
        } else {
            print "Payload '$payload' for parameter '$param' failed.\n";
            print "Error:", $response->status_line, "\n";
        }
    }
}
