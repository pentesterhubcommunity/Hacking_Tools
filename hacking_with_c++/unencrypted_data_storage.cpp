#include <iostream>
#include <string>
#include <curl/curl.h> // Using libcurl for HTTP requests

using namespace std;

// Function to perform HTTP GET request
size_t writeCallback(void *ptr, size_t size, size_t nmemb, string *data) {
    data->append((char *)ptr, size * nmemb);
    return size * nmemb;
}

bool isDataUnencrypted(const string& websiteUrl) {
    CURL *curl;
    CURLcode res;
    string response;

    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, websiteUrl.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
        
        // Check if the response contains unencrypted data
        // You can add your vulnerability detection logic here
        if (response.find("password") != string::npos) {
            return true;
        }
    }
    return false;
}

int main() {
    string targetWebsite;

    // Prompt the user to enter the target website URL
    cout << "\033[1;33mEnter your target website URL: \033[0m";
    getline(cin, targetWebsite);

    // Check if the website has unencrypted data storage vulnerability
    if (isDataUnencrypted(targetWebsite)) {
        cout << "\033[1;31mWarning: The website may have unencrypted data storage vulnerability!\033[0m" << endl;
    } else {
        cout << "\033[1;32mNo unencrypted data storage vulnerability detected.\033[0m" << endl;
    }

    return 0;
}
