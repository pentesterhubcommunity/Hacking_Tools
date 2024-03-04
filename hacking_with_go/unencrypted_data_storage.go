package main

import (
    "fmt"
    "io/ioutil"
    "net/http"
    "strings"
    "sync"
)

func main() {
    fmt.Println("Welcome to the Unencrypted Data Storage vulnerability tester.")

    // Prompt the user to enter the target website URL
    var targetURL string
    fmt.Print("Enter your target website URL: ")
    fmt.Scanln(&targetURL)

    // Perform vulnerability test
    testVulnerability(targetURL)
}

func testVulnerability(targetURL string) {
    // List of sensitive keywords to search for
    sensitiveKeywords := []string{"password", "credit card", "social security"}

    // Start testing
    fmt.Println("Testing for Unencrypted Data Storage vulnerability...")

    // Make HTTP GET request to the target URL
    resp, err := http.Get(targetURL)
    if err != nil {
        fmt.Println("Error occurred while sending request:", err)
        return
    }
    defer resp.Body.Close()

    // Read response body
    bodyBytes, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println("Error reading response body:", err)
        return
    }
    responseBody := string(bodyBytes)

    // Create a wait group for concurrent requests
    var wg sync.WaitGroup

    // Check for sensitive data concurrently
    for _, keyword := range sensitiveKeywords {
        // Increment the wait group counter
        wg.Add(1)
        
        // Start a goroutine to search for sensitive data
        go func(keyword string) {
            defer wg.Done()

            if strings.Contains(responseBody, keyword) {
                fmt.Printf("Sensitive data found: %s\n", keyword)
                // Add logic to identify location of sensitive data (e.g., line number, HTML element)
            }
        }(keyword)
    }

    // Wait for all goroutines to finish
    wg.Wait()

    // Print testing instructions
    fmt.Println("Here's how to test that vulnerability:")
    fmt.Println("1. Check if sensitive data is transmitted over HTTPS.")
    fmt.Println("2. Look for sensitive data stored in cookies, local storage, or in response bodies.")
    fmt.Println("3. Use tools like Burp Suite or OWASP ZAP for more comprehensive testing.")
}
