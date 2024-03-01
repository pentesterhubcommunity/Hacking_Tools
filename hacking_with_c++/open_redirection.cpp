#include <iostream>
#include <string>
#include <curl/curl.h>
#include <cstring>

// ANSI color codes
#define RED     "\033[0;31m"
#define GREEN   "\033[0;32m"
#define NC      "\033[0m" // No Color

struct MemoryStruct {
    char* memory;
    size_t size;
};

size_t write_callback(void* ptr, size_t size, size_t nmemb, void* data) {
    size_t realsize = size * nmemb;
    struct MemoryStruct* mem = (struct MemoryStruct*)data;

    char* ptr_realloc = (char*)realloc(mem->memory, mem->size + realsize + 1);
    if (ptr_realloc == NULL) {
        /* out of memory! */
        std::cerr << "Failed to reallocate memory" << std::endl;
        return 0;
    }

    mem->memory = ptr_realloc;
    memcpy(&(mem->memory[mem->size]), ptr, realsize);
    mem->size += realsize;
    mem->memory[mem->size] = 0;

    return realsize;
}

int main() {
    std::string target_url, redirect_url;
    std::cout << "Enter your target website link: ";
    std::getline(std::cin, target_url);
    redirect_url = "https://www.bbc.com";

    // Initialize libcurl
    curl_global_init(CURL_GLOBAL_ALL);
    CURL* curl = curl_easy_init();
    if (curl) {
        // Set the URL to fetch
        curl_easy_setopt(curl, CURLOPT_URL, (target_url + "?redirect=" + redirect_url).c_str());

        // Follow HTTP redirections
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

        // Initialize memory struct to store response
        struct MemoryStruct chunk;
        chunk.memory = (char*)malloc(1);
        chunk.size = 0;

        // Set callback function to retrieve HTTP status code
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void*)&chunk);

        // Perform the request
        CURLcode res = curl_easy_perform(curl);

        // Cleanup curl
        curl_easy_cleanup(curl);
        curl_global_cleanup();

        // Check the result
        if (res == CURLE_OK) {
            // Check redirection
            long http_code;
            curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &http_code);
            if (http_code >= 300 && http_code < 400) {
                std::cout << RED << "Potentially Vulnerable: Redirection occurred but not to the specified URL" << NC << std::endl;
            } else if (http_code == 200 && target_url == redirect_url) {
                std::cout << GREEN << "Vulnerable: Open Redirection exists" << NC << std::endl;
            } else {
                std::cout << RED << "Not Vulnerable: HTTP request failed with status code " << http_code << NC << std::endl;
            }
        } else {
            std::cerr << RED << "Failed to perform HTTP request: " << curl_easy_strerror(res) << NC << std::endl;
            return 1;
        }

        // Free allocated memory
        free(chunk.memory);
    } else {
        std::cerr << RED << "Failed to initialize libcurl" << NC << std::endl;
        return 1;
    }

    return 0;
}
