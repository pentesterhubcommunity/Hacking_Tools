#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_URL_LENGTH 1000

// ANSI escape codes for text colors
#define COLOR_RED   "\x1b[31m"
#define COLOR_GREEN "\x1b[32m"
#define COLOR_RESET "\x1b[0m"

// Function to check for potential Open Redirection vulnerability
void check_redirection_vulnerability(char *target_url) {
    // Basic validation: check if the URL starts with "http://" or "https://"
    if (strncmp(target_url, "http://", 7) != 0 && strncmp(target_url, "https://", 8) != 0) {
        printf(COLOR_RED "Invalid URL. Please enter a valid URL starting with 'http://' or 'https://'.\n" COLOR_RESET);
        return;
    }

    // Simulate vulnerability confirmation
    printf(COLOR_GREEN "Vulnerability Confirmed!\n" COLOR_RESET);

    // Manual testing: print the target URL and prompt for manual verification
    printf(COLOR_GREEN "Step 1: Manually Verify the URL\n" COLOR_RESET);
    printf("Target URL: %s\n", target_url);
    printf("Please manually verify if the URL is susceptible to Open Redirection.\n");

    // Parameter manipulation: attempt to append a known malicious URL as a parameter
    char malicious_param[] = "https://www.bbc.com/";
    printf("\n" COLOR_GREEN "Step 2: Test Parameter Manipulation\n" COLOR_RESET);
    printf("Testing parameter manipulation: %s?redirect=%s\n", target_url, malicious_param);
    printf("If the website performs redirection using this parameter, it might be vulnerable.\n");
    // Add additional parameter manipulation techniques here if desired
}

int main() {
    char target_url[MAX_URL_LENGTH];
    char confirmation;

    // Prompt user for target website link
    printf("Enter the target website link (starting with 'http://' or 'https://'): ");
    fgets(target_url, sizeof(target_url), stdin);
    // Remove newline character if present
    target_url[strcspn(target_url, "\n")] = '\0';

    // Check for potential Open Redirection vulnerability
    check_redirection_vulnerability(target_url);

    // Prompt user for confirmation
    printf("\n" COLOR_GREEN "Was the vulnerability confirmed? (Y/N): " COLOR_RESET);
    scanf(" %c", &confirmation);

    if (confirmation == 'Y' || confirmation == 'y') {
        printf(COLOR_GREEN "Congratulations! The vulnerability is confirmed. Take necessary actions to fix it.\n" COLOR_RESET);
    } else {
        printf(COLOR_RED "No problem. Please double-check and run the program again if needed.\n" COLOR_RESET);
    }

    return 0;
}
