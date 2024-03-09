package main

import (
    "fmt"
    "net/http"
    "os"
    "strings"
)

func main() {
    fmt.Println("\033[1;36mCustom Header Vulnerability Tester\033[0m")
    fmt.Print("Enter your target website URL: ")
    var targetURL string
    fmt.Scanln(&targetURL)

    fmt.Printf("\n\033[1;33mTesting for Custom Header Vulnerabilities on %s\033[0m\n", targetURL)

    // Prepare headers with common vulnerability indicators
    headers := map[string]string{
        "X-Test-Header":          "Vulnerable",
        "X-Custom-Header":        "<script>alert('Vulnerable')</script>",
        "X-Injection-Header":     "' OR 1=1--",
        "X-Malicious-Header":     "<svg/onload=alert('Vulnerable')>",
        "X-XSS-Protection":       "1; mode=block",
        "X-Content-Type-Options": "nosniff",
        "X-Frame-Options":        "DENY",
    }

    // Flag to track if any vulnerability is found
    vulnerable := false

    // Send HTTP request with each header
    for header, value := range headers {
        req, err := http.NewRequest("GET", targetURL, nil)
        if err != nil {
            fmt.Println("\033[1;31mError creating HTTP request:", err, "\033[0m")
            os.Exit(1)
        }
        req.Header.Set(header, value)

        fmt.Printf("\n\033[1;34mSending request with %s header\033[0m\n", header)

        client := &http.Client{}
        resp, err := client.Do(req)
        if err != nil {
            fmt.Println("\033[1;31mError sending HTTP request:", err, "\033[0m")
            os.Exit(1)
        }

        // Check response for vulnerability indicator
        body := make([]byte, 100)
        _, _ = resp.Body.Read(body)
        response := string(body)

        if strings.Contains(response, value) {
            fmt.Printf("\033[1;32m%s header is vulnerable!\033[0m\n", header)
            fmt.Println("Vulnerability test: Send a request with the", header, "header and check if the response contains", value)
            vulnerable = true
        } else {
            fmt.Printf("\033[1;33m%s header is not vulnerable\033[0m\n", header)
        }
    }

    // Confirm if the target is vulnerable or not
    if vulnerable {
        fmt.Println("\033[1;31mThe target is vulnerable to Custom Header Vulnerabilities\033[0m")
    } else {
        fmt.Println("\033[1;32mThe target is not vulnerable to Custom Header Vulnerabilities\033[0m")
    }
}
