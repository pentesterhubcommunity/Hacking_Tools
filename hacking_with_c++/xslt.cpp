#include <iostream>
#include <string>
#include <curl/curl.h>
#include <libxml/parser.h>

// Function to perform HTTP GET request using libcurl
std::string httpGet(const std::string& url, bool verbose) {
    std::string response;
    CURL* curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, [](void* buffer, size_t size, size_t nmemb, std::string* response) -> size_t {
            response->append(static_cast<char*>(buffer), size * nmemb);
            return size * nmemb;
        });
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        if (verbose) {
            curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);
        }
        CURLcode res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            std::cerr << "Failed to fetch URL: " << curl_easy_strerror(res) << std::endl;
        }
        curl_easy_cleanup(curl);
    } else {
        std::cerr << "Failed to initialize libcurl." << std::endl;
    }
    return response;
}

int main() {
    // Prompt for target website URL
    std::cout << "\033[1;34mEnter your target website url: \033[0m";
    std::string targetUrl;
    std::cin >> targetUrl;

    // Perform HTTP GET request to fetch XML data
    std::cout << "\033[1;34mFetching XML data from: " << targetUrl << "\033[0m" << std::endl;
    std::string xmlData = httpGet(targetUrl, true);

    // Parse XML data using libxml2
    std::cout << "\033[1;34mParsing XML data...\033[0m" << std::endl;
    xmlDocPtr doc = xmlReadMemory(xmlData.c_str(), xmlData.length(), NULL, NULL, 0);
    if (doc == NULL) {
        std::cerr << "\033[1;31mError: Unable to parse XML data.\033[0m" << std::endl;
        return 1;
    }

    // Check if XSLT vulnerability exists
    xmlNodePtr root = xmlDocGetRootElement(doc);
    if (xmlStrcmp(root->name, (const xmlChar*)"xsl:stylesheet") == 0) {
        std::cout << "\033[1;32mTarget website is vulnerable to XSLT injection!\033[0m" << std::endl;

        // Show how to test the vulnerability
        std::cout << "\033[1;34mTo test the vulnerability, you can try injecting malicious XSLT code into the XML request.\033[0m" << std::endl;
    } else {
        std::cout << "\033[1;33mTarget website is not vulnerable to XSLT injection.\033[0m" << std::endl;
    }

    // Clean up libxml2 resources
    xmlFreeDoc(doc);
    xmlCleanupParser();

    return 0;
}
