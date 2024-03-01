use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder;
use Parallel::ForkManager;
use Term::ANSIColor qw(:constants);

# Prompt for the target website URL
print "Enter your target website URL: ";
my $url = <STDIN>;
chomp($url);

# Function to check for sensitive data in a given HTML content
sub check_for_sensitive_data {
    my ($content) = @_;
    my %sensitive_patterns = (
        'password' => qr/password/i,
        'credit card number' => qr/\b\d{4}[ -]?\d{4}[ -]?\d{4}[ -]?\d{4}\b/,
        'social security number' => qr/\b\d{3}[ -]?\d{2}[ -]?\d{4}\b/,
        'API key' => qr/api_key/i,
        # Add more patterns as needed
    );

    for my $category (keys %sensitive_patterns) {
        if ($content =~ $sensitive_patterns{$category}) {
            return $category;
        }
    }
    return undef;
}

# Create a user agent object
my $ua = LWP::UserAgent->new;

# Set a timeout for the HTTP request (10 seconds)
$ua->timeout(10);

# Make the HTTP request
my $response = $ua->get($url);

# Check if the request was successful
if ($response->is_success) {
    my $content = $response->decoded_content;

    # Parse HTML content
    my $tree = HTML::TreeBuilder->new_from_content($content);

    # Extract all text nodes from the HTML tree
    my @text_nodes = $tree->look_down('_tag', 'text');

    # Check for potential sensitive data in text nodes
    my $sensitive_data_found = 0;
    for my $node (@text_nodes) {
        my $category = check_for_sensitive_data($node->as_text);
        if ($category) {
            print RED, "Potential sensitive data exposure in text: $category\n", RESET;
            $sensitive_data_found = 1;
            last;
        }
    }

    # If no sensitive data found in text nodes, check in other parts of HTML
    unless ($sensitive_data_found) {
        # Additional checks here (metadata, comments, hidden fields, etc.)
        # Example: check metadata for sensitive information
        my $metadata = $tree->find_by_tag_name('meta');
        if ($metadata) {
            my $category = check_for_sensitive_data($metadata->attr('content'));
            if ($category) {
                print RED, "Potential sensitive data exposure in metadata: $category\n", RESET;
                $sensitive_data_found = 1;
            }
        }
        # Add more checks as needed
    }

    # If still no sensitive data found
    print GREEN, "No potential sensitive data exposure detected.\n", RESET unless $sensitive_data_found;

    $tree->delete;
} else {
    # Print the error message if the request failed
    print RED, "Error: Failed to retrieve the website content. " . $response->status_line . "\n", RESET;
}
