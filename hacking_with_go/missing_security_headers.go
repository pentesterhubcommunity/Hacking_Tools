package main

import (
    "fmt"
    "net/http"
)

func main() {
    fmt.Println("Welcome to Missing Security Headers Vulnerability Tester")

    // Prompting the user to enter the target website URL
    var targetURL string
    fmt.Print("Enter your target website URL: ")
    fmt.Scanln(&targetURL)

    // Testing the target website for missing security headers
    headers := testSecurityHeaders(targetURL)

    // Checking if any security headers are missing
    if len(headers) == 0 {
        fmt.Println("No missing security headers found!")
    } else {
        fmt.Println("The following security headers are missing:")
        for _, header := range headers {
            fmt.Println(header)
        }
        fmt.Println("To exploit this vulnerability, an attacker could perform various attacks such as Cross-Site Scripting (XSS), Clickjacking, or Session Hijacking.")
    }
}

// Function to test for missing security headers
func testSecurityHeaders(url string) []string {
    // Sending an HTTP HEAD request to the target URL
    resp, err := http.Head(url)
    if err != nil {
        fmt.Println("Error:", err)
        return nil
    }
    defer resp.Body.Close()

    // Extracting the headers from the response
    headers := resp.Header

    // List of commonly recommended security headers
    recommendedHeaders := map[string]string{
        "X-XSS-Protection":           "X-XSS-Protection",
        "Strict-Transport-Security":  "Strict-Transport-Security",
        "X-Content-Type-Options":     "X-Content-Type-Options",
        "Content-Security-Policy":    "Content-Security-Policy",
        "X-Frame-Options":            "X-Frame-Options",
        "Referrer-Policy":            "Referrer-Policy",
        "Feature-Policy":             "Feature-Policy",
        "X-Permitted-Cross-Domain-Policies": "X-Permitted-Cross-Domain-Policies",
        "Expect-CT":                  "Expect-CT",
    }

    // Checking for missing recommended security headers
    var missingHeaders []string
    for header, headerName := range recommendedHeaders {
        if _, ok := headers[headerName]; !ok {
            missingHeaders = append(missingHeaders, header)
        }
    }

    return missingHeaders
}
