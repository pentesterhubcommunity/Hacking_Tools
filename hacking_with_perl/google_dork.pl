use strict;
use warnings;
use URI::Escape;
use Term::ReadKey;

# Function to open URLs in a web browser three at a time
sub open_urls_three_at_a_time {
    my ($urls, $index) = @_;

    # Base case: if all URLs have been opened
    if ($index >= scalar(@$urls)) {
        print "All dorking queries have been executed.\n";
        return;
    }
    
    # Open three URLs
    my @promises;
    for (my $i = $index; $i < $index + 3 && $i < scalar(@$urls); $i++) {
        my $url = $$urls[$i];
        push @promises, system("google-chrome $url &");
    }

    # Prompt the user to continue
    print "Press [Enter] to run the next 3 commands (or type 'quit' to exit): ";
    ReadMode('cbreak');
    my $answer = ReadLine(0);
    ReadMode('normal');
    chomp($answer);

    if ($answer eq 'quit') {
        print "Exiting...\n";
        return;
    }

    # Recursively open the next set of URLs
    open_urls_three_at_a_time($urls, $index + 3);
}

# Main function
sub main {
    # List to store dork queries
    my @queries = (
        "site:{target_domain} inurl:login",
        "site:{target_domain} intitle:index.of",
        "site:{target_domain} intext:password",
        "site:{target_domain} filetype:pdf",
        "site:{target_domain} inurl:admin",
        "site:{target_domain} intitle:admin",
        "site:{target_domain} intitle:dashboard",
        "site:{target_domain} intitle:config OR site:{target_domain} intitle:configuration",
        "site:{target_domain} intitle:setup",
        "site:{target_domain} intitle:phpinfo",
        # Add more queries here...
        "site:{target_domain} inurl:wp-admin",
        "site:{target_domain} inurl:wp-content",
        "site:{target_domain} inurl:wp-includes",
        "site:{target_domain} inurl:wp-login",
        "site:{target_domain} inurl:wp-config",
        "site:{target_domain} inurl:wp-config.txt",
        "site:{target_domain} inurl:wp-config.php",
        "site:{target_domain} inurl:wp-config.php.bak",
        "site:{target_domain} inurl:wp-config.php.old",
        "site:{target_domain} inurl:wp-config.php.save",
        "site:{target_domain} inurl:wp-config.php.swp",
        "site:{target_domain} inurl:wp-config.php~",
        "site:{target_domain} inurl:wp-config.bak",
        "site:{target_domain} inurl:wp-config.old",
        "site:{target_domain} inurl:wp-config.save",
        "site:{target_domain} inurl:wp-config.swp",
        "site:{target_domain} inurl:wp-config~",
        "site:{target_domain} inurl:.env",
        "site:{target_domain} inurl:credentials",
        "site:{target_domain} inurl:connectionstrings",
        "site:{target_domain} inurl:secret_key",
        "site:{target_domain} inurl:api_key",
        "site:{target_domain} inurl:client_secret",
        "site:{target_domain} inurl:auth_key",
        "site:{target_domain} inurl:access_key",
        "site:{target_domain} inurl:backup",
        "site:{target_domain} inurl:dump",
        "site:{target_domain} inurl:logs",
        "site:{target_domain} inurl:conf",
        "site:{target_domain} inurl:db",
        "site:{target_domain} inurl:sql",
        "site:{target_domain} inurl:backup",
        "site:{target_domain} inurl:root",
        "site:{target_domain} inurl:confidential",
        "site:{target_domain} inurl:database",
        "site:{target_domain} inurl:passed",
        # Add more queries here...
    );

    # Prompt for target domain
    print "Enter your target domain (e.g., example.com): ";
    my $target_domain = <STDIN>;
    chomp($target_domain);

    # Construct URLs with target domain
    my @urls;
    foreach my $query (@queries) {
        my $encoded_query = uri_escape($query =~ s/{target_domain}/$target_domain/r);
        my $url = "https://www.google.com/search?q=$encoded_query";
        push @urls, $url;
    }

    # Start opening URLs three at a time
    open_urls_three_at_a_time(\@urls, 0);
}

# Run the main function
main();
