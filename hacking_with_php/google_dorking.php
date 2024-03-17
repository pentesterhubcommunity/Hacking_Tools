<?php

// Function to open URLs in a web browser three at a time
function openUrlsThreeAtATime($urls, $index) {
    // Base case: if all URLs have been opened
    if ($index >= count($urls)) {
        echo "All dorking queries have been executed.\n";
        return;
    }

    // Open three URLs
    for ($i = $index; $i < min($index + 3, count($urls)); $i++) {
        $url = $urls[$i];
        shell_exec("google-chrome \"$url\" &");
    }

    // Prompt the user to continue
    echo "Press [Enter] to run the next 3 commands (or type 'quit' to exit): ";
    $answer = trim(fgets(STDIN));

    if ($answer == 'quit') {
        echo "Exiting...\n";
        return;
    }

    // Recursively open the next set of URLs
    openUrlsThreeAtATime($urls, $index + 3);
}

// Main function
function main() {
    // List to store dork queries
    $queries = array(
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
        // Add more queries here...
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
        // Add more queries here...
    );

    // Prompt for target domain
    echo "Enter your target domain (e.g., example.com): ";
    $targetDomain = trim(fgets(STDIN));

    // Construct URLs with target domain
    $urls = array();
    foreach ($queries as $query) {
        $encodedQuery = urlencode(str_replace("{target_domain}", $targetDomain, $query));
        $url = "https://www.google.com/search?q=$encodedQuery";
        array_push($urls, $url);
    }

    // Start opening URLs three at a time
    openUrlsThreeAtATime($urls, 0);
}

// Run the main function
main();

?>
