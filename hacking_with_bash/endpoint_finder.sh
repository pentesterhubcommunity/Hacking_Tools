#!/bin/bash
echo "We are removing the pre-exist urls.txt"
echo "Don't worry, after finishing the scan"
echo "it will create a new one."
rm -r urls.txt
# Function to extract URLs from a webpage
extract_urls() {
    local webpage="$1"
    # Use grep with Perl-compatible regular expressions to extract URLs
    grep -Po '(?<=href=")([^"]*)(?=")' <<< "$webpage"
}

# Function to check if a URL is an endpoint
is_endpoint() {
    local url="$1"
    # Check if the URL ends with a file extension or has a query string
    if [[ "$url" =~ \.(html?|php|asp|aspx|jsp|py|cgi|pl|xml|json|txt|css|js|rb|java|dll|exe|bin|sh|bat|cmd)(\?.*)?$ ]]; then
        return 0 # It's an endpoint
    else
        return 1 # It's not an endpoint
    fi
}

# Function to crawl a website recursively
crawl_website() {
    local url="$1"
    local visited_urls=()

    # Start crawling with the provided URL
    crawl_recursive "$url"
}

# Function to recursively crawl URLs
crawl_recursive() {
    local url="$1"
    local webpage
    local urls

    # Check if the URL has already been visited to avoid infinite loops
    if [[ "${visited_urls[*]}" =~ "$url" ]]; then
        return
    fi

    # Fetch the webpage content
    webpage=$(curl -s "$url")

    # Extract URLs from the webpage
    urls=$(extract_urls "$webpage")

    # Iterate over each extracted URL
    for u in $urls; do
        # Check if the URL is an endpoint
        if is_endpoint "$u"; then
            echo "Endpoint: $u"
            # Append the endpoint URL (with '/' added before it) to the file
            echo "Corresponding URL: $url$u"
            echo "$url/$u" >> urls.txt  
            echo >> urls.txt  # Add a new line for better readability in the file
        fi

        # If the URL is not an endpoint and is within the same domain, crawl it recursively
        if [[ "$u" == /* ]]; then
            crawl_recursive "$url$u"
        fi
    done

    # Mark the current URL as visited
    visited_urls+=("$url")
}

# Main function
main() {
    local start_url="$1"
    # Start crawling the website
    crawl_website "$start_url"
}

# Ensure that the urls.txt file exists or create it if it doesn't
touch urls.txt

# Prompt the user to enter the target website URL
read -p "Enter your target website link with http:// or https:// : " target_url

# Check if a URL argument is provided
if [[ -z "$target_url" ]]; then
    echo "You must provide a target website URL."
    exit 1
fi

# Call the main function with the provided URL
main "$target_url"