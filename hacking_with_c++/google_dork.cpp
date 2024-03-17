#include <iostream>
#include <vector>
#include <string>
#include <cstdlib>

using namespace std;

// Function to perform Google dorking for the target domain
void performDorking(const string& target_domain, const vector<string>& queries) {
    // Loop through each dorking query
    for (const auto& query : queries) {
        // Open Google Chrome with the dorking query
        string command = "google-chrome \"https://www.google.com/search?q=" + query + "\" &";
        system(command.c_str());
        cout << "Opening Google Chrome with the dork query: " << query << endl;

        // Wait for the command to finish
        system("wait");
    }
    cout << "All dorking queries for " << target_domain << " have been executed. Close the tabs when you're done viewing the results." << endl;
}

int main() {
    // Vector to store dork queries
    vector<string> queries = {
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
        "site:{target_domain} inurl:root",
        "site:{target_domain} inurl:confidential",
        "site:{target_domain} inurl:database",
        "site:{target_domain} inurl:passed"
        // Add more queries here...
    };

    // Prompt for target domain
    string target_domain;
    cout << "Enter your target domain (e.g., example.com): ";
    getline(cin, target_domain);

    // Loop through each 3 dorking queries
    for (int i = 0; i < queries.size(); i += 3) {
        // Prompt for confirmation before running the next 3 commands
        string choice;
        cout << "Press [Enter] to run the next 3 commands (or type 'quit' to exit): ";
        getline(cin, choice);
        if (choice == "quit") {
            cout << "Exiting..." << endl;
            break;
        }

        // Extract 3 queries to run
        vector<string> queriesToRun;
        for (int j = i; j < min(i + 3, static_cast<int>(queries.size())); ++j) {
            queriesToRun.push_back(queries[j]);
        }

        // Perform dorking for the target domain
        performDorking(target_domain, queriesToRun);
    }

    return 0;
}
