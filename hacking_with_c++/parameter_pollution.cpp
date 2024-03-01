#include <iostream>
#include <string>
#include <boost/asio.hpp>
#include <regex>

using namespace boost::asio;
using namespace boost::asio::ip;

// Function to extract parameters from HTML content
std::vector<std::string> extractParameters(const std::string& html_content) {
    std::vector<std::string> parameters;
    std::regex param_regex("name=\"([^\"]+)\"");
    std::sregex_iterator next(html_content.begin(), html_content.end(), param_regex);
    std::sregex_iterator end;
    while (next != end) {
        parameters.push_back((*next)[1]);
        ++next;
    }
    return parameters;
}

int main() {
    io_context io_context;
    tcp::resolver resolver(io_context);
    tcp::socket socket(io_context);

    // Prompt user for the target website link
    std::cout << "Enter your target website link: ";
    std::string target_url;
    std::getline(std::cin, target_url);

    // Make HTTP GET request to the target website
    tcp::resolver::results_type endpoints = resolver.resolve(target_url, "http");
    boost::asio::connect(socket, endpoints);
    boost::asio::write(socket, boost::asio::buffer("GET / HTTP/1.1\r\nHost: " + target_url + "\r\nConnection: close\r\n\r\n"));

    // Read and parse HTML response
    std::string html_content;
    boost::system::error_code ec;
    boost::asio::streambuf response;
    boost::asio::read_until(socket, response, "\r\n\r\n", ec);
    if (!ec) {
        boost::asio::read(socket, response, boost::asio::transfer_all(), ec);
        if (!ec) {
            html_content = boost::asio::buffer_cast<const char*>(response.data());
        } else {
            std::cerr << "Error reading response body: " << ec.message() << std::endl;
            return 1;
        }
    } else {
        std::cerr << "Error reading response header: " << ec.message() << std::endl;
        return 1;
    }

    // Extract parameters from HTML content
    std::vector<std::string> parameters = extractParameters(html_content);

    // Construct parameters demonstrating parameter pollution
    std::string parameter_string;
    for (const std::string& param : parameters) {
        parameter_string += param + "=test1&" + param + "=test2&" + param + "=test3&";
    }
    parameter_string.pop_back(); // Remove the extra '&'

    // Construct HTTP request with parameters demonstrating parameter pollution
    std::string request =
        "GET /?" + parameter_string + " HTTP/1.1\r\n" +
        "Host: " + target_url + "\r\n" +
        "Connection: close\r\n\r\n";

    // Send HTTP request
    boost::asio::write(socket, boost::asio::buffer(request));

    // Read and print response
    boost::asio::streambuf pollution_response;
    boost::asio::read_until(socket, pollution_response, "\r\n\r\n");
    std::cout << &pollution_response << std::endl;

    return 0;
}
