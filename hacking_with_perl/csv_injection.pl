#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use Text::CSV;
use Term::ANSIColor;

# Function to test CSV data for potential injection
sub test_for_injection {
    my ($data) = @_;
    my @payloads = (
        "=\"cmd|'/C calc'!A1",             # Command execution
        "=\"=HYPERLINK(\"\"http://evil.com\"\",\"\"Click Here\"\")\"",  # Hyperlink manipulation
        "\"=SUM(1+2)*cmd|' /C calc'!A1\"", # Formula injection
    );
    foreach my $payload (@payloads) {
        if ($data =~ /$payload/) {
            return 1;
        }
    }
    return 0;
}

# Function to parse and analyze CSV data
sub analyze_csv {
    my ($csv_data) = @_;
    my $csv = Text::CSV->new({ binary => 1 }) or die "Cannot use CSV: " . Text::CSV->error_diag();
    my $num_rows = 0;
    my $num_cols = 0;
    my @suspicious_rows;

    my @rows = split /\n/, $csv_data;
    foreach my $line (@rows) {
        $num_rows++;
        my @fields = split /,/, $line;
        $num_cols = scalar(@fields) if scalar(@fields) > $num_cols;
        foreach my $cell (@fields) {
            if ($cell =~ /[\=\+\-\@]/) { # Check for suspicious characters
                push @suspicious_rows, $num_rows;
                last;
            }
        }
    }

    return ($num_rows, $num_cols, \@suspicious_rows);
}

# Prompt user for target website URL
print "Enter your target website URL: ";
my $url = <STDIN>;
chomp($url);

# Fetch the CSV file
print "Fetching CSV file from $url...\n";
my $csv_data = get $url;

if (defined $csv_data) {
    print color('green'), "CSV file successfully fetched!\n", color('reset');

    # Test for CSV Injection vulnerability
    print "Testing for CSV Injection vulnerability...\n";
    if (test_for_injection($csv_data)) {
        print color('red'), "The target website is vulnerable to CSV Injection!\n", color('reset');
        print "To test the vulnerability, open the CSV file and see if the payload is executed.\n";
    } else {
        print color('green'), "The target website is not vulnerable to CSV Injection.\n", color('reset');
    }

    # Analyze CSV data for suspicious patterns
    print "Analyzing CSV data for suspicious patterns...\n";
    my ($num_rows, $num_cols, $suspicious_rows) = analyze_csv($csv_data);
    if (@$suspicious_rows) {
        print color('yellow'), "Suspicious patterns detected in rows: ", join(", ", @$suspicious_rows), "\n", color('reset');
        print "Consider further investigation to determine if there are any vulnerabilities.\n";
    } else {
        print color('green'), "No suspicious patterns detected in the CSV data.\n", color('reset');
    }

} else {
    print color('red'), "Failed to fetch CSV file from $url. Please check the URL and try again.\n", color('reset');
}
