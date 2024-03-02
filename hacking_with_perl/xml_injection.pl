use strict;
use warnings;
use LWP::UserAgent;
use threads;
use Thread::Queue;
use Term::ANSIColor qw(:constants);

# Prompt user for target website URL
print "Enter your target website URL: ";
my $url = <STDIN>;
chomp($url);

# Number of threads to use for testing
my $num_threads = 4;

# Number of payloads to generate and test
my $num_payloads = 10;

# Initialize UserAgent
my $ua = LWP::UserAgent->new;
$ua->timeout(10); # Set timeout for requests (in seconds)

# Generate random payloads
sub generate_payloads {
    my @payloads;
    for (my $i = 0; $i < $num_payloads; $i++) {
        my $payload = '<payload>' . generate_random_string(10) . '</payload>';
        push @payloads, $payload;
    }
    return @payloads;
}

# Generate a random string of specified length
sub generate_random_string {
    my $length = shift;
    my @chars = ('a'..'z', 'A'..'Z', '0'..'9');
    my $random_string = '';
    foreach (1..$length) {
        $random_string .= $chars[rand @chars];
    }
    return $random_string;
}

# Send request with payload and check for injection
sub test_payload {
    my ($payload) = @_;

    my $xml_content = <<"XML";
<?xml version="1.0" encoding="UTF-8"?>
<data>
    $payload
</data>
XML

    my $response = $ua->post(
        $url,
        Content_Type => 'application/xml',
        Content      => $xml_content
    );

    if ($response->is_success && $response->content =~ /<response>Injected<\/response>/) {
        print BOLD GREEN "Vulnerability found with payload: $payload\n";
    } else {
        print BOLD RED "No vulnerability found with payload: $payload\n";
    }
}

# Generate payloads
my @payloads = generate_payloads();

# Create thread queue
my $queue = Thread::Queue->new();
$queue->enqueue(@payloads);

# Worker subroutine
sub worker {
    while (my $payload = $queue->dequeue_nb()) {
        test_payload($payload);
    }
}

# Create and start worker threads
my @threads;
for (1 .. $num_threads) {
    push @threads, threads->create(\&worker);
}

# Join threads
foreach my $thread (@threads) {
    $thread->join();
}
