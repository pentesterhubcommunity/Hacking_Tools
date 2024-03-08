package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
    "strings"
)

func main() {
    fmt.Println("\x1b[1;34mXSLT Injection Vulnerability Tester\x1b[0m")
    fmt.Println("")

    // Prompt user to enter target website URL
    fmt.Print("Enter your target website URL: ")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    targetURL := scanner.Text()

    // Check if the URL starts with http:// or https://
    if !strings.HasPrefix(targetURL, "http://") && !strings.HasPrefix(targetURL, "https://") {
        targetURL = "http://" + targetURL
    }

    // Send request to the target URL with malicious XSLT payload
    fmt.Println("Sending request to", targetURL)
    resp, err := http.Get(targetURL)
    if err != nil {
        fmt.Println("Error occurred while sending request:", err)
        return
    }
    defer resp.Body.Close()

    // Display HTTP response body for manual inspection
    fmt.Println("\x1b[1;34mResponse Body:\x1b[0m")
    fmt.Println("--------------------------------------------------------------")
    scanner = bufio.NewScanner(resp.Body)
    for scanner.Scan() {
        fmt.Println(scanner.Text())
    }
    fmt.Println("--------------------------------------------------------------")

    // Check if the response contains evidence of XSLT injection vulnerability
    if strings.Contains(resp.Header.Get("Content-Type"), "application/xml") ||
        strings.Contains(resp.Header.Get("Content-Type"), "text/xml") ||
        strings.Contains(resp.Header.Get("Content-Type"), "application/xhtml+xml") ||
        strings.Contains(resp.Header.Get("Content-Type"), "application/rss+xml") ||
        strings.Contains(resp.Header.Get("Content-Type"), "application/atom+xml") ||
        strings.Contains(resp.Header.Get("Content-Type"), "application/rdf+xml") {
        fmt.Println("\x1b[1;32mTarget website may be vulnerable to XSLT injection!\x1b[0m")
        fmt.Println("")
        fmt.Println("\x1b[1;34mHow to Test the Vulnerability:\x1b[0m")
        fmt.Println("1. Prepare an XSLT payload with malicious code.")
        fmt.Println("2. Send a request to the target website with the XSLT payload.")
        fmt.Println("3. Inspect the response to check if the payload was executed.")
    } else {
        fmt.Println("\x1b[1;31mTarget website is not vulnerable to XSLT injection.\x1b[0m")
    }
}
