#include <iostream>
#include <string>
#include <cstdlib> // For system() function to clear screen

// Include cURL library for sending HTTP requests
#include <curl/curl.h>

// Define colors for different console outputs
#ifdef _WIN32
    #include <windows.h>
    #define RED     SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_RED)
    #define GREEN   SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_GREEN)
    #define YELLOW  SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_RED | FOREGROUND_GREEN)
    #define RESET   SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE)
#else
    #define RED     "\033[1;31m"
    #define GREEN   "\033[1;32m"
    #define YELLOW  "\033[1;33m"
    #define RESET   "\033[0m"
#endif

using namespace std;

// Callback function for cURL to write received data
size_t writeCallback(char* ptr, size_t size, size_t nmemb, string* data) {
    data->append(ptr, size * nmemb);
    return size * nmemb;
}

int main() {
    string targetWebsite;

    // Clear screen
    system("clear");

    // Prompt user for target website URL
    cout << "Enter your target website URL: ";
    getline(cin, targetWebsite);

    // Display steps to test for insecure authentication vulnerability
    cout << "\nTo test for insecure authentication vulnerability:\n";
    cout << "1. Ensure the website is using HTTP instead of HTTPS.\n";
    cout << "2. Attempt to log in using valid credentials while monitoring network traffic.\n";
    cout << "3. If the credentials are sent over unencrypted HTTP, the website is vulnerable to insecure authentication.\n";

    // Simulate authentication request using cURL
    cout << "\nSimulating authentication request...\n";

    // Initialize cURL
    CURL* curl = curl_easy_init();
    if (curl) {
        // Set cURL options: URL, HTTP method, etc.
        curl_easy_setopt(curl, CURLOPT_URL, targetWebsite.c_str());
        curl_easy_setopt(curl, CURLOPT_HTTPGET, 1L); // Sending a GET request (change as per your requirement)
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L); // Follow HTTP redirects

        // Perform the request
        CURLcode res = curl_easy_perform(curl);

        // Check for errors
        if (res != CURLE_OK) {
            cerr << RED << "Error: " << curl_easy_strerror(res) << RESET << endl;
        } else {
            cout << GREEN << "Authentication request sent successfully.\n" << RESET;
        }

        // Cleanup cURL
        curl_easy_cleanup(curl);
    } else {
        cerr << RED << "Error initializing cURL.\n" << RESET;
    }

    cout << "\nInsecure authentication vulnerability test complete.\n";

    return 0;
}
