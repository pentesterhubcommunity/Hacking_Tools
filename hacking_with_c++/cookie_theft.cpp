#include <iostream>
#include <string>
#include <curl/curl.h>

// ANSI escape codes for colors
#define RED_TEXT "\033[1;31m"
#define GREEN_TEXT "\033[1;32m"
#define RESET_TEXT "\033[0m"

// Callback function to handle HTTP response
size_t writeCallback(char* ptr, size_t size, size_t nmemb, std::string* data) {
    data->append(ptr, size * nmemb);
    return size * nmemb;
}

int main() {
    // Initialize libcurl
    CURL* curl = curl_easy_init();
    if (!curl) {
        std::cerr << RED_TEXT << "Failed to initialize libcurl." << RESET_TEXT << std::endl;
        return 1;
    }

    // Ask for target website URL
    std::string targetWebsiteUrl;
    std::cout << "Enter the target website URL (including http/https): ";
    std::getline(std::cin, targetWebsiteUrl);

    // Set URL
    curl_easy_setopt(curl, CURLOPT_URL, targetWebsiteUrl.c_str());

    // Follow redirects
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

    // Perform request
    CURLcode res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        std::cerr << RED_TEXT << "Failed to retrieve data from the provided URL. Error: " << curl_easy_strerror(res) << RESET_TEXT << std::endl;
        curl_easy_cleanup(curl);
        return 1;
    }

    // Get cookies
    curl_slist* cookies;
    res = curl_easy_getinfo(curl, CURLINFO_COOKIELIST, &cookies);
    if (res != CURLE_OK) {
        std::cerr << RED_TEXT << "Failed to retrieve cookies. Error: " << curl_easy_strerror(res) << RESET_TEXT << std::endl;
        curl_easy_cleanup(curl);
        return 1;
    }

    // Print cookies
    std::cout << "\nCookies retrieved from " << targetWebsiteUrl << ":" << std::endl;
    while (cookies) {
        std::string cookieStr(cookies->data);
        size_t splitPos = cookieStr.find("\t");
        std::string cookieName = cookieStr.substr(splitPos + 1, cookieStr.find("\t", splitPos + 1) - splitPos - 1);
        std::cout << GREEN_TEXT << cookieName << RESET_TEXT << std::endl;
        cookies = cookies->next;
    }

    // Clean up
    curl_slist_free_all(cookies);
    curl_easy_cleanup(curl);

    // Explanation of the vulnerability
    std::cout << "\nTo test the Cookie Theft vulnerability, an attacker could intercept the cookies ";
    std::cout << "sent between the client and server, allowing them to impersonate the victim ";
    std::cout << "and potentially gain unauthorized access to the victim's account." << std::endl;

    return 0;
}
