#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

#define MAX_URL_LENGTH 256

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_RESET   "\x1b[0m"

// Function to perform a sensitive data exposure attack
void perform_exposure(const char *target_url) {
    CURL *curl;
    CURLcode res;
    long response_code;
    char *response_content = NULL;

    // Initialize libcurl
    curl = curl_easy_init();
    if (!curl) {
        fprintf(stderr, ANSI_COLOR_RED "Error initializing libcurl\n" ANSI_COLOR_RESET);
        exit(EXIT_FAILURE);
    }

    // Set the target URL for the sensitive data exposure attack
    curl_easy_setopt(curl, CURLOPT_URL, target_url);

    // Follow HTTP redirections
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

    // Perform the HTTP request
    res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        fprintf(stderr, ANSI_COLOR_RED "Error performing HTTP request: %s\n" ANSI_COLOR_RESET, curl_easy_strerror(res));
        curl_easy_cleanup(curl);
        exit(EXIT_FAILURE);
    }

    // Get HTTP response code
    res = curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
    if (res != CURLE_OK) {
        fprintf(stderr, ANSI_COLOR_RED "Error getting HTTP response code: %s\n" ANSI_COLOR_RESET, curl_easy_strerror(res));
        curl_easy_cleanup(curl);
        exit(EXIT_FAILURE);
    }

    // Check if response code indicates success (2xx)
    if (response_code >= 200 && response_code < 300) {
        // Get the response content
        res = curl_easy_getinfo(curl, CURLINFO_CONTENT_LENGTH_DOWNLOAD_T, &response_code);
        if (res != CURLE_OK) {
            fprintf(stderr, ANSI_COLOR_RED "Error getting response content: %s\n" ANSI_COLOR_RESET, curl_easy_strerror(res));
            curl_easy_cleanup(curl);
            exit(EXIT_FAILURE);
        }

        // Allocate memory for response content
        response_content = (char *)malloc(response_code + 1);
        if (!response_content) {
            fprintf(stderr, ANSI_COLOR_RED "Error allocating memory\n" ANSI_COLOR_RESET);
            curl_easy_cleanup(curl);
            exit(EXIT_FAILURE);
        }

        // Copy response content
        res = curl_easy_getinfo(curl, CURLINFO_CONTENT_TYPE, &response_content);
        if (res != CURLE_OK) {
            fprintf(stderr, ANSI_COLOR_RED "Error copying response content: %s\n" ANSI_COLOR_RESET, curl_easy_strerror(res));
            curl_easy_cleanup(curl);
            free(response_content);
            exit(EXIT_FAILURE);
        }

        // Analyze response content for sensitive information (e.g., detecting the word "password")
        if (strstr(response_content, "password") != NULL) {
            // Highlight sensitive information in green
            printf(ANSI_COLOR_GREEN "Sensitive information detected in response content:\n%s\n" ANSI_COLOR_RESET, response_content);
        } else {
            // Print response content without highlighting
            printf("%s\n", response_content);
        }

        // Clean up
        free(response_content);
    } else {
        fprintf(stderr, ANSI_COLOR_RED "HTTP request failed with response code: %ld\n" ANSI_COLOR_RESET, response_code);
    }

    // Cleanup libcurl
    curl_easy_cleanup(curl);
}

int main() {
    char target_url[MAX_URL_LENGTH];

    printf("Enter your target website link: ");
    fgets(target_url, sizeof(target_url), stdin);
    target_url[strcspn(target_url, "\n")] = '\0';

    printf(ANSI_COLOR_GREEN "Starting Sensitive Data Exposure attack...\n" ANSI_COLOR_RESET);
    perform_exposure(target_url);
    printf(ANSI_COLOR_GREEN "Sensitive Data Exposure attack completed.\n" ANSI_COLOR_RESET);

    return 0;
}
