package main

import (
    "fmt"
    "io/ioutil"
    "net/http"
    "os"
    "time"
)

func main() {
    fmt.Println("Enter your target website URL (including http/https): ")
    var targetURL string
    fmt.Scanln(&targetURL)

    // Create a custom HTTP client with timeout and custom User-Agent
    client := &http.Client{
        Timeout: 10 * time.Second,
    }

    // Create a request with a custom User-Agent header
    req, err := http.NewRequest("GET", targetURL, nil)
    if err != nil {
        fmt.Println("Error creating request:", err)
        os.Exit(1)
    }
    req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36")

    // Send the request
    resp, err := client.Do(req)
    if err != nil {
        fmt.Println("Error sending request:", err)
        os.Exit(1)
    }
    defer resp.Body.Close()

    // Check response status code
    if resp.StatusCode != http.StatusOK {
        fmt.Println("Unexpected status code:", resp.StatusCode)
        os.Exit(1)
    }

    // Read and discard response body
    _, err = ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println("Error reading response body:", err)
        os.Exit(1)
    }

    // Extract and display cookies
    cookies := resp.Cookies()
    if len(cookies) > 0 {
        fmt.Println("Cookies:")
        for _, cookie := range cookies {
            fmt.Printf("%s: %s\n", cookie.Name, cookie.Value)
            // Add additional analysis here if needed
        }
    } else {
        fmt.Println("No cookies found.")
    }
}
