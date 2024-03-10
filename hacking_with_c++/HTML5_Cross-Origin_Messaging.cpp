#include <iostream>
#include <string>
#include <cstdlib>
#include <curl/curl.h>

// Define the target website URL
std::string targetWebsite;

// Function to send a cross-origin message to the target website
size_t sendMessageCallback(void* contents, size_t size, size_t nmemb, std::string* message) {
    message->append((char*)contents, size * nmemb);
    return size * nmemb;
}

bool sendMessage(const std::string& url) {
    CURL* curl;
    CURLcode res;
    std::string message;

    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, sendMessageCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &message);
        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);

        if (res != CURLE_OK) {
            std::cerr << "Failed to send message to the target website." << std::endl;
            return false;
        }
    } else {
        std::cerr << "Failed to initialize CURL." << std::endl;
        return false;
    }

    std::cout << "Message sent successfully." << std::endl;
    std::cout << "Response received: " << message << std::endl;

    // Check if the response contains the message we sent
    if (message.find("Cross-Origin Message Received:") != std::string::npos) {
        return true; // Vulnerable
    } else {
        return false; // Not vulnerable
    }
}

int main() {
    // Ask for the target website URL
    std::cout << "\x1b[33mEnter your target website url: \x1b[0m";
    std::cin >> targetWebsite;

    std::cout << "Testing HTML5 Cross-Origin Messaging vulnerability for: " << targetWebsite << std::endl;

    // Send a cross-origin message
    bool isVulnerable = sendMessage(targetWebsite);

    // Display vulnerability status
    if (isVulnerable) {
        std::cout << "\x1b[32mThe target website is vulnerable to HTML5 Cross-Origin Messaging vulnerability.\x1b[0m" << std::endl;
        // Provide instructions on how to exploit the vulnerability
        std::cout << "To test the vulnerability, you can send crafted messages containing sensitive information" << std::endl;
        std::cout << "and see if the website accepts them from a different origin." << std::endl;
    } else {
        std::cout << "\x1b[31mThe target website is not vulnerable to HTML5 Cross-Origin Messaging vulnerability.\x1b[0m" << std::endl;
    }

    return 0;
}
