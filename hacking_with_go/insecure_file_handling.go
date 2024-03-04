package main

import (
    "fmt"
    "net/http"
    "strings"
)

func main() {
    // Ask for the target website URL
    fmt.Print("Enter your target website URL: ")
    var targetURL string
    fmt.Scanln(&targetURL)

    // Send a request to the target website
    resp, err := http.Get(targetURL)
    if err != nil {
        fmt.Println("Error occurred while fetching the website:", err)
        return
    }
    defer resp.Body.Close()

    // Check if the response status code indicates success
    if resp.StatusCode != http.StatusOK {
        fmt.Printf("Failed to fetch the website. Status code: %d\n", resp.StatusCode)
        return
    }

    // Extract the response body
    responseBody := make([]byte, 0)
    for {
        buf := make([]byte, 1024)
        n, err := resp.Body.Read(buf)
        if n > 0 {
            responseBody = append(responseBody, buf[:n]...)
        }
        if err != nil {
            break
        }
    }

    // Check for potential indicators of insecure file handling vulnerabilities
    if strings.Contains(string(responseBody), "Index of /") {
        fmt.Println("Potential insecure file listing found.")
        fmt.Println("This may expose directory contents including sensitive files.")
        fmt.Println("Consider restricting directory listing in web server configuration.")
        fmt.Println("Exploitation: An attacker can navigate directories and access sensitive files directly.")
    } else {
        fmt.Println("No potential insecure file handling vulnerabilities detected.")
    }

    // Additional checks can be added here based on specific vulnerability indicators
}
