#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

// Function to perform a SSRF attack
void perform_ssrf(char *url) {
    CURL *curl;
    CURLcode res;

    // Initialize libcurl
    curl = curl_easy_init();
    if (!curl) {
        fprintf(stderr, "\033[1;31mError initializing libcurl\033[0m\n");
        exit(EXIT_FAILURE);
    }

    // Set the target URL for the SSRF attack
    curl_easy_setopt(curl, CURLOPT_URL, url);

    // Set the write callback function to capture response
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, NULL);

    // Perform the SSRF attack
    res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        fprintf(stderr, "\033[1;31mError performing SSRF attack: %s\033[0m\n", curl_easy_strerror(res));
        curl_easy_cleanup(curl);
        exit(EXIT_FAILURE);
    }

    // Check response for potential vulnerabilities
    long response_code;
    curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
    if (response_code == 200) {
        printf("\033[1;32mVulnerability confirmed: Response indicates SSRF vulnerability.\033[0m\n");
    } else {
        printf("\033[1;33mNo SSRF vulnerability detected.\033[0m\n");
    }

    // Cleanup libcurl
    curl_easy_cleanup(curl);
}

int main() {
    char input_url[1000];

    // Prompt user for target website link
    printf("\033[1;36mEnter your target website link: \033[0m");
    fgets(input_url, sizeof(input_url), stdin);

    // Remove trailing newline character
    input_url[strcspn(input_url, "\n")] = 0;

    // Perform the SSRF attack
    perform_ssrf(input_url);

    return 0;
}
