package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
    "strings"
)

func main() {
    // Prompt the user to enter the target website URL
    var targetURL string
    fmt.Print("Enter your target website URL: ")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    targetURL = scanner.Text()

    // Perform data leakage vulnerability tests
    fmt.Println("Testing for data leakage vulnerabilities on", targetURL)

    // Check for sensitive information in the source code
    sourceCodeLeaks := checkSourceCodeLeaks(targetURL)
    if sourceCodeLeaks {
        fmt.Println("[+] Potential data leakage vulnerability found: Exposed sensitive information in the source code.")
    } else {
        fmt.Println("[-] No source code leakage detected.")
    }

    // Check for sensitive data in HTTP responses
    httpLeaks := checkHTTPLeaks(targetURL)
    if httpLeaks {
        fmt.Println("[+] Potential data leakage vulnerability found: Exposed sensitive data in HTTP responses.")
    } else {
        fmt.Println("[-] No sensitive data found in HTTP responses.")
    }

    // Additional tests can be added as needed

    fmt.Println("Data leakage vulnerability testing complete.")
}

// Function to check for sensitive information in the source code
func checkSourceCodeLeaks(url string) bool {
    response, err := http.Get(url)
    if err != nil {
        fmt.Println("Error:", err)
        return false
    }
    defer response.Body.Close()

    // Read the source code
    scanner := bufio.NewScanner(response.Body)
    for scanner.Scan() {
        line := scanner.Text()
        // Check for sensitive keywords (e.g., password, secret, API key, etc.)
        sensitiveKeywords := []string{"password", "secret", "api_key"} // Add more keywords as needed
        for _, keyword := range sensitiveKeywords {
            if strings.Contains(line, keyword) {
                return true
            }
        }
    }
    return false
}

// Function to check for sensitive data in HTTP responses
func checkHTTPLeaks(url string) bool {
    // Send a GET request to the target URL
    response, err := http.Get(url)
    if err != nil {
        fmt.Println("Error:", err)
        return false
    }
    defer response.Body.Close()

    // Analyze HTTP response headers for sensitive information
    for header, values := range response.Header {
        headerName := strings.ToLower(header)
        // Check for headers that may contain sensitive data (e.g., Set-Cookie)
        if headerName == "set-cookie" {
            for _, value := range values {
                if strings.Contains(value, "secure") || strings.Contains(value, "HttpOnly") {
                    return true
                }
            }
        }
    }

    // Analyze HTTP response body for sensitive information
    scanner := bufio.NewScanner(response.Body)
    for scanner.Scan() {
        line := scanner.Text()
        // Check for sensitive data patterns (e.g., credit card numbers, email addresses)
        if strings.Contains(line, "credit_card") || strings.Contains(line, "email") {
            return true
        }
    }
    return false
}
