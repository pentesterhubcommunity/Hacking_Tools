package main

import (
    "bufio"
    "fmt"
    "io/ioutil"
    "net/http"
    "os"
    "strings"
)

func main() {
    reader := bufio.NewReader(os.Stdin)
    fmt.Print("Enter your target website URL: ")
    url, err := reader.ReadString('\n')
    if err != nil {
        fmt.Println("Error reading input:", err)
        os.Exit(1)
    }

    // Trim newline character from the URL
    url = strings.TrimSpace(url)

    fmt.Println("Testing for SSRF vulnerability on:", url)

    // Attempt to make a request to the specified URL
    resp, err := http.Get(url)
    if err != nil {
        fmt.Println("Error making request:", err)
        os.Exit(1)
    }
    defer resp.Body.Close()

    // Check if the response status code indicates success
    if resp.StatusCode >= 200 && resp.StatusCode < 300 {
        fmt.Printf("Successfully accessed URL: %s\n", url)
        // Read the response body
        body, err := ioutil.ReadAll(resp.Body)
        if err != nil {
            fmt.Println("Error reading response body:", err)
        } else {
            // Check if the response contains sensitive information
            responseBody := string(body)
            if strings.Contains(responseBody, "internal") || strings.Contains(responseBody, "secret") {
                fmt.Println("The website may be vulnerable to SSRF.")
            } else {
                fmt.Println("The website does not seem to be vulnerable to SSRF.")
            }
        }
    } else {
        fmt.Printf("Failed to access URL: %s\n", url)
        fmt.Printf("Status code: %d\n", resp.StatusCode)
    }
}
