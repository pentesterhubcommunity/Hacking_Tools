async function main() {
    // List to store dork queries
    const queries = [
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
    ];

    // Create interface for reading user input
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    // Prompt for target domain
    const targetDomain = await new Promise((resolve) => {
        rl.question("Enter your target domain (e.g., example.com): ", (answer) => {
            rl.close();
            resolve(answer.trim());
        });
    });

    // Construct URLs with target domain
    const urls = queries.map(query => {
        const encodedQuery = encodeURIComponent(query.replace("{target_domain}", targetDomain));
        return `https://www.google.com/search?q=${encodedQuery}`;
    });

    // Start opening URLs three at a time
    await openUrlsThreeAtATime(urls);
}
