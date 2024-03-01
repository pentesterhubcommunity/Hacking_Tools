package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
)

func main() {
    fmt.Print("Enter your target website link: ")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    targetURL := scanner.Text()

    redirectURL := "https://www.bbc.com"

    // Send a request with the redirection URL
    resp, err := http.Get(targetURL + "?redirect=" + redirectURL)
    if err != nil {
        fmt.Printf("HTTP request failed: %v\n", err)
        return
    }
    defer resp.Body.Close()

    // Extract status code and effective URL from the response
    statusCode := resp.StatusCode
    effectiveURL := resp.Request.URL.String()

    // Check if the response status code indicates a successful redirection
    if statusCode >= 300 && statusCode < 400 && effectiveURL == redirectURL {
        fmt.Println("\033[0;32mVulnerable: Open Redirection exists\033[0m")
    } else if statusCode >= 300 && statusCode < 400 {
        fmt.Println("\033[0;31mPotentially Vulnerable: Redirection occurred but not to the specified URL\033[0m")
    } else if statusCode < 200 || statusCode >= 400 {
        fmt.Printf("\033[0;31mNot Vulnerable: HTTP request failed with status code %d\033[0m\n", statusCode)
    } else {
        fmt.Println("\033[0;31mNot Vulnerable: Redirection did not occur\033[0m")
    }
}
