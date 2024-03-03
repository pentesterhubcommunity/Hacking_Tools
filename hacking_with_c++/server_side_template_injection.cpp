#include <iostream>
#include <string>
#include <curl/curl.h>

// Callback function to write the response data to a string
size_t writeCallback(char* ptr, size_t size, size_t nmemb, std::string* data) {
    data->append(ptr, size * nmemb);
    return size * nmemb;
}

// Function to check if the response contains potential SSTI indicators
bool checkForSSTI(const std::string& response) {
    // You can enhance this function to include more sophisticated checks for SSTI indicators
    if (response.find("{{") != std::string::npos || response.find("{{") != std::string::npos) {
        return true;
    }
    return false;
}

int main() {
    std::string targetUrl;
    std::string postData = ""; // Modify this to include any data to be sent in the POST request

    std::cout << "Enter your target website URL: ";
    std::cin >> targetUrl;

    CURL *curl;
    CURLcode res;

    curl = curl_easy_init();
    if(curl) {
        // Set URL
        curl_easy_setopt(curl, CURLOPT_URL, targetUrl.c_str());

        // Set post data if needed
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, postData.c_str());

        // Set response data callback
        std::string responseData;
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &responseData);

        // Perform the request
        res = curl_easy_perform(curl);

        // Check for errors
        if(res != CURLE_OK) {
            std::cerr << "curl_easy_perform() failed: " << curl_easy_strerror(res) << std::endl;
            return 1;
        }

        // Analyze the response for potential SSTI
        bool sstiDetected = checkForSSTI(responseData);
        if (sstiDetected) {
            std::cout << "Potential SSTI vulnerability detected!" << std::endl;
        } else {
            std::cout << "No potential SSTI vulnerability detected." << std::endl;
        }

        // Clean up
        curl_easy_cleanup(curl);
    }

    return 0;
}
