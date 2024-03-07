#include <iostream>
#include <string>
#include <cstdlib>
#include <curl/curl.h> // Library for making HTTP requests

// Define colors for console output
#define RED "\033[1;31m"
#define GREEN "\033[1;32m"
#define YELLOW "\033[1;33m"
#define RESET "\033[0m"

using namespace std;

// Function to check Misconfigured CORS vulnerability
bool testCORSVulnerability(string targetURL) {
    CURL *curl;
    CURLcode res;
    bool vulnerable = false;

    curl = curl_easy_init();
    if (curl) {
        // Set the target URL
        curl_easy_setopt(curl, CURLOPT_URL, targetURL.c_str());

        // Set the HTTP request method
        curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "OPTIONS");

        // Perform the request
        res = curl_easy_perform(curl);

        // Check for CORS vulnerability
        if (res == CURLE_OK) {
            long response_code;
            curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
            if (response_code == 200) {
                vulnerable = true;
            }
        }

        // Cleanup
        curl_easy_cleanup(curl);
    }

    return vulnerable;
}

// Function to bypass protection systems
void bypassProtection(string targetURL) {
    // Simulate bypassing protection systems (replace with actual code)
    cout << YELLOW << "Attempting to bypass protection systems..." << RESET << endl;
    // Code to bypass protection systems goes here
    // For demonstration, let's try accessing the target URL without CORS headers
    cout << YELLOW << "Trying to bypass protection by making a cross-origin request..." << RESET << endl;
    CURL *curl = curl_easy_init();
    if (curl) {
        // Set the target URL
        string modifiedURL = targetURL;
        modifiedURL.insert(4, "://evil.com");
        curl_easy_setopt(curl, CURLOPT_URL, modifiedURL.c_str());

        // Set the HTTP request method
        curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

        // Perform the request
        CURLcode res = curl_easy_perform(curl);
        if (res == CURLE_OK) {
            cout << GREEN << "Protection systems bypassed successfully!" << RESET << endl;
        } else {
            cout << RED << "Failed to bypass protection systems." << RESET << endl;
        }

        // Cleanup
        curl_easy_cleanup(curl);
    } else {
        cout << RED << "Failed to initialize CURL." << RESET << endl;
    }
}

int main() {
    string targetURL;

    // Prompt user for target website URL
    cout << "Enter your target website URL: ";
    cin >> targetURL;

    // Check if the target URL starts with "http://" or "https://"
    if (targetURL.substr(0, 7) != "http://" && targetURL.substr(0, 8) != "https://") {
        cerr << RED << "Invalid URL. Please provide a valid URL starting with 'http://' or 'https://'" << RESET << endl;
        return 1;
    }

    // Test for Misconfigured CORS vulnerability
    cout << "Testing for Misconfigured CORS vulnerability on " << targetURL << "..." << endl;
    bool isVulnerable = testCORSVulnerability(targetURL);

    // Check if vulnerable
    if (isVulnerable) {
        cout << RED << "Misconfigured CORS vulnerability found on " << targetURL << "!" << RESET << endl;

        // Explain the potential risks
        cout << YELLOW << "This vulnerability may allow attackers to conduct cross-origin attacks, such as stealing sensitive data or performing unauthorized actions on behalf of the user." << RESET << endl;

        // Offer mitigation recommendations
        cout << YELLOW << "To mitigate this vulnerability, ensure that CORS headers are properly configured to restrict access only to trusted origins." << RESET << endl;

        // Attempt to bypass protection systems
        bypassProtection(targetURL);
    } else {
        cout << GREEN << "No Misconfigured CORS vulnerability found on " << targetURL << "." << RESET << endl;
    }

    // Provide instructions on how to check the vulnerability
    cout << "To check for Misconfigured CORS vulnerability, inspect the CORS headers in the server response." << endl;
    cout << "Look for 'Access-Control-Allow-Origin' header and ensure it's properly configured." << endl;

    return 0;
}
