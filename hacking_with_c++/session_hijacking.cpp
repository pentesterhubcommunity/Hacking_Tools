#include <iostream>
#include <string>
#include <cstdlib> // For system("pause")
#include <curl/curl.h> // For sending HTTP requests
#include <jsoncpp/json/json.h> // For parsing JSON responses

// Color codes for console output
#define RESET   "\033[0m"
#define RED     "\033[31m"
#define GREEN   "\033[32m"
#define YELLOW  "\033[33m"

using namespace std;

// Callback function to receive HTTP response
size_t writeCallback(char* ptr, size_t size, size_t nmemb, string* data) {
    data->append(ptr, size * nmemb);
    return size * nmemb;
}

// Function to simulate session hijacking
void simulateSessionHijacking(const string& targetURL) {
    // Send a request to obtain a valid session token (e.g., by logging in)
    // In this example, we assume the token is obtained as a JSON response
    CURL* curl;
    CURLcode res;
    string response;
    curl = curl_easy_init();
    if (curl) {
        // Set URL
        curl_easy_setopt(curl, CURLOPT_URL, targetURL.c_str());
        // Set callback function to receive response
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);
        // Set response data to be stored in response variable
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        // Perform the request
        res = curl_easy_perform(curl);
        // Cleanup
        curl_easy_cleanup(curl);
    }
    // Parse JSON response to extract session token
    Json::Value root;
    Json::Reader reader;
    bool parsingSuccessful = reader.parse(response, root);
    if (parsingSuccessful) {
        string sessionToken = root["session_token"].asString();
        // Simulate session hijacking by using the obtained session token
        cout << YELLOW << "Session Hijacking Attack Simulated!" << RESET << endl;
        cout << "Session token obtained: " << sessionToken << endl;
        cout << RED << "Attacker can now access the victim's account!" << RESET << endl;
    } else {
        cout << RED << "Failed to obtain session token. Check the target website URL and try again." << RESET << endl;
    }
}

int main() {
    string targetURL;

    // Prompt user to enter target website URL
    cout << "Enter your target website URL: ";
    cin >> targetURL;

    // Simulate session hijacking attack
    simulateSessionHijacking(targetURL);

    // Instructions on how to test the vulnerability
    cout << GREEN << "\nTo test the vulnerability, follow these steps:\n";
    cout << "1. Obtain a valid session token from a logged-in user (e.g., by intercepting network traffic).\n";
    cout << "2. Inject the obtained session token into your own browser or a tool like Postman.\n";
    cout << "3. Access restricted areas or perform actions on the target website using the hijacked session.\n";
    cout << "4. If successful, you have exploited the session hijacking vulnerability.\n" << RESET;

    // Pause before exiting
    cout << "\nPress any key to exit...";
    system("pause");
    return 0;
}
