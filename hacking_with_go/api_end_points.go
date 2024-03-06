package main

import (
    "fmt"
    "net/http"
    "io/ioutil"
    "time"
)

func main() {
    // Ask user for target website URL
    fmt.Print("Enter your target website URL: ")
    var targetURL string
    fmt.Scanln(&targetURL)

    // Scan for unprotected API endpoints
    fmt.Println("Scanning for unprotected API endpoints...")

    // List of common API endpoint paths to test
    apiEndpoints := []string{
        "/api",
        "/v1",
        "/v2",
        "/users",
        "/posts",
        "/products",
        "/orders",
        "/payments",
        "/auth",
        "/admin",
        "/settings",
        "/notifications",
        "/analytics",
        "/messages",
        "/comments",
        "/search",
        "/feedback",
        "/ratings",
        "/reviews",
        "/notifications",
        "/chats",
        "/events",
        "/subscriptions",
        "/invoices",
        "/transactions",
        "/invoices",
        "/notifications",
        "/assets",
        "/documents",
        "/notifications",
        "/notifications",
        "/subscriptions",
        "/reports",
        "/notifications",
        "/tasks"
    }

    // Client with timeout for HTTP requests
    client := &http.Client{
        Timeout: 10 * time.Second,
    }

    for _, endpoint := range apiEndpoints {
        // Construct URL
        url := targetURL + endpoint

        // Send request
        resp, err := client.Get(url)
        if err != nil {
            fmt.Println("Error accessing endpoint:", err)
            continue
        }
        defer resp.Body.Close()

        // Check response status code
        if resp.StatusCode == http.StatusOK {
            fmt.Println("Unprotected API endpoint found:", url)
            // Attempt to exploit the vulnerability
            exploitVulnerability(url)
        }
    }
}

func exploitVulnerability(url string) {
    // Example of exploiting the vulnerability
    // Sending a request to retrieve sensitive data
    fmt.Println("Exploiting vulnerability...")
    client := &http.Client{
        Timeout: 10 * time.Second,
    }
    resp, err := client.Get(url)
    if err != nil {
        fmt.Println("Error exploiting vulnerability:", err)
        return
    }
    defer resp.Body.Close()

    // Read response body
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println("Error reading response body:", err)
        return
    }

    // Print sensitive data retrieved
    fmt.Println("Sensitive data retrieved from:", url)
    // Limit output to prevent overwhelming the console
    // Assuming the response body contains JSON data
    fmt.Println(trimJSON(string(body)))
}

func trimJSON(jsonString string) string {
    // Trim JSON string to limit output
    const maxOutputLength = 200
    if len(jsonString) > maxOutputLength {
        return jsonString[:maxOutputLength] + "..."
    }
    return jsonString
}
