#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder::XPath;
use Term::ANSIColor;

# Prompt for target website URL
print colored("Enter your target website URL: ", "cyan");
my $target_url = <STDIN>;
chomp $target_url;

# Send request to the target website
my $ua = LWP::UserAgent->new;
my $response = $ua->get($target_url);
die "Failed to fetch $target_url: ", $response->status_line unless $response->is_success;

# Parse HTML content
my $content = $response->decoded_content;
my $tree = HTML::TreeBuilder::XPath->new;
$tree->parse($content);

# Check for vulnerability
my $vulnerable = 0;
my @scripts = $tree->findvalues('//script[@src]');
foreach my $script (@scripts) {
    if ($script =~ /^https?:\/\/(?!$target_url)/i) {
        $vulnerable = 1;
        last;
    }
}

# Display vulnerability status
print "\n";
if ($vulnerable) {
    print colored("The target website is vulnerable to HTML5 Cross-Origin Messaging!\n", "red");
} else {
    print colored("The target website is not vulnerable to HTML5 Cross-Origin Messaging.\n", "green");
}

# Display how to test the vulnerability
print colored("\nTo test the vulnerability, you can use the following steps:\n", "cyan");
print colored("1. Open Developer Tools in your browser (usually by pressing F12).\n", "yellow");
print colored("2. Navigate to the 'Console' tab.\n", "yellow");
print colored("3. Execute JavaScript code similar to:\n", "yellow");
print colored("   var iframe = document.createElement('iframe');\n", "yellow");
print colored("   iframe.src = 'https://attacker.com';\n", "yellow");
print colored("   document.body.appendChild(iframe);\n", "yellow");
print colored("4. If you see a request to 'https://attacker.com' being made from the target website, it is vulnerable.\n\n", "yellow");

# Cleanup
$tree->delete;
