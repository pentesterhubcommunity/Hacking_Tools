#!/bin/bash

# Function to perform Google dorking for the target domain
perform_dorking() {
    # Prompt for target domain
    read -p "Enter your target domain (e.g., example.com): " target_domain

    # Construct dork queries for the target domain
    queries=(
        "site:${target_domain} inurl:login"
        "site:${target_domain} intitle:index.of"
        "site:${target_domain} intext:password"
        "site:${target_domain} filetype:pdf"
        "site:${target_domain} inurl:admin"
        "site:${target_domain} intitle:admin"
        "site:${target_domain} intitle:dashboard"
        "site:${target_domain} intitle:config OR site:${target_domain} intitle:configuration"
        "site:${target_domain} intitle:setup"
        "site:${target_domain} intitle:phpinfo"
        "site:${target_domain} inurl:wp-admin"
        "site:${target_domain} inurl:wp-content"
        "site:${target_domain} inurl:wp-includes"
        "site:${target_domain} inurl:wp-login"
        "site:${target_domain} inurl:wp-config"
        "site:${target_domain} inurl:wp-config.txt"
        "site:${target_domain} inurl:wp-config.php"
        "site:${target_domain} inurl:wp-config.php.bak"
        "site:${target_domain} inurl:wp-config.php.old"
        "site:${target_domain} inurl:wp-config.php.save"
        "site:${target_domain} inurl:wp-config.php.swp"
        "site:${target_domain} inurl:wp-config.php~"
        "site:${target_domain} inurl:wp-config.bak"
        "site:${target_domain} inurl:wp-config.old"
        "site:${target_domain} inurl:wp-config.save"
        "site:${target_domain} inurl:wp-config.swp"
        "site:${target_domain} inurl:wp-config~"
        "site:${target_domain} inurl:.env"
        "site:${target_domain} inurl:credentials"
        "site:${target_domain} inurl:connectionstrings"
        "site:${target_domain} inurl:secret_key"
        "site:${target_domain} inurl:api_key"
        "site:${target_domain} inurl:client_secret"
        "site:${target_domain} inurl:auth_key"
        "site:${target_domain} inurl:access_key"
        "site:${target_domain} inurl:backup"
        "site:${target_domain} inurl:dump"
        "site:${target_domain} inurl:logs"
        "site:${target_domain} inurl:conf"
        "site:${target_domain} inurl:db"
        "site:${target_domain} inurl:sql"
        "site:${target_domain} inurl:root"
        "site:${target_domain} inurl:confidential"
        "site:${target_domain} inurl:database"
        "site:${target_domain} inurl:passed"
    )

    # Loop through each dorking query
    for ((i = 0; i < ${#queries[@]}; i+=3)); do
        # Open Google Chrome with the dorking queries
        for ((j = 0; j < 3 && i + j < ${#queries[@]}; j++)); do
            google-chrome "https://www.google.com/search?q=${queries[i+j]// /%20}" & disown
            echo "Opening Google Chrome with the dork query: ${queries[i+j]}"
        done

        # Prompt for confirmation before proceeding to the next set of queries
        read -p "Press [Enter] to run the next set of queries (or type 'quit' to exit): " choice
        if [[ $choice == "quit" ]]; then
            echo "Exiting..."
            return
        fi
    done

    echo "All dorking queries for ${target_domain} have been executed. Close the tabs when you're done viewing the results."
}

# Main loop to continuously prompt for dorking queries
while true; do
    perform_dorking
    read -p "Press [Enter] to perform dorking for another target domain or type 'quit' to exit: " choice
    if [[ $choice == "quit" ]]; then
        echo "Exiting..."
        break
    fi
done
