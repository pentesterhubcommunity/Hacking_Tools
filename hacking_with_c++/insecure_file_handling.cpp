#include <iostream>
#include <curl/curl.h>

// Function to perform the HTTP request
size_t writeCallback(char* buf, size_t size, size_t nmemb, std::string* data) {
    if (data) {
        data->append(buf, size * nmemb);
        return size * nmemb;
    }
    return 0;
}

int main() {
    // Initialize libcurl
    curl_global_init(CURL_GLOBAL_ALL);
    CURL* curl = curl_easy_init();

    if (curl) {
        std::string url;
        std::cout << "\x1b[33mEnter your target website URL: \x1b[0m";
        std::cin >> url;

        // Set the URL to test
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());

        // Set custom headers (optional)
        struct curl_slist* headers = NULL;
        headers = curl_slist_append(headers, "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36");
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

        // Set the write callback function
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);
        std::string response;

        // Perform the request
        CURLcode res = curl_easy_perform(curl);

        // Check for errors
        if (res != CURLE_OK) {
            std::cerr << "\x1b[31mError accessing the website: " << curl_easy_strerror(res) << "\x1b[0m" << std::endl;
        } else {
            // Print the response
            std::cout << "\x1b[32mResponse from " << url << ":\n\x1b[0m" << response << std::endl;

            // Check for common sensitive files and directories
            if (response.find("etc/passwd") != std::string::npos) {
                std::cout << "\x1b[31mPotential insecure file handling vulnerability detected: /etc/passwd accessible!\x1b[0m" << std::endl;
            }
            if (response.find("etc/shadow") != std::string::npos) {
                std::cout << "\x1b[31mPotential insecure file handling vulnerability detected: /etc/shadow accessible!\x1b[0m" << std::endl;
            }
        }

        // Clean up libcurl resources
        curl_easy_cleanup(curl);
        curl_slist_free_all(headers);
    } else {
        std::cerr << "\x1b[31mFailed to initialize libcurl!\x1b[0m" << std::endl;
    }

    // Cleanup
    curl_global_cleanup();

    return 0;
}
