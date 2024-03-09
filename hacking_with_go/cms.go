package main

import (
    "fmt"
    "net/http"
    "strings"
)

func main() {
    fmt.Println("\033[1;34mCMS Information Disclosure Vulnerability Tester\033[0m")
    fmt.Println("\033[1;33m-----------------------------------------------\033[0m")

    var targetURL string
    fmt.Print("Enter your target website URL: ")
    fmt.Scanln(&targetURL)

    fmt.Printf("\033[1;34m[+] Testing for CMS Information Disclosure Vulnerabilities on: %s\033[0m\n", targetURL)

    // Send a GET request to the target website
    resp, err := http.Get(targetURL)
    if err != nil {
        fmt.Println("\033[1;31m[!] Error occurred while making the request:", err, "\033[0m")
        return
    }
    defer resp.Body.Close()

    // Extracting the server header to identify the CMS
    serverHeader := resp.Header.Get("Server")
    if serverHeader != "" {
        fmt.Printf("\033[1;32m[*] Server header found: %s\033[0m\n", serverHeader)

        // Checking if the server header reveals information about the CMS
        cmsInfo := getCMSInfo(serverHeader)
        if cmsInfo != "" {
            fmt.Printf("\033[1;32m[*] CMS Information Found: %s\033[0m\n", cmsInfo)
            fmt.Println("\033[1;32m[*] This website may be vulnerable to CMS Information Disclosure.\033[0m")
            fmt.Println("\033[1;32m[*] To test this vulnerability, try accessing common CMS directories and files.\033[0m")
        } else {
            fmt.Println("\033[1;32m[*] No CMS Information Found in Server Header.\033[0m")
            fmt.Println("\033[1;32m[*] This website may not be vulnerable to CMS Information Disclosure.\033[0m")
        }
    } else {
        fmt.Println("\033[1;31m[!] Server header not found. Unable to determine CMS information.\033[0m")
    }
}

// Function to extract CMS information from the server header
func getCMSInfo(serverHeader string) string {
    cmsInfo := ""
    // Common CMS identifiers in server headers
    cmsIdentifiers := map[string]string{
        "WordPress":    "WordPress",
        "Joomla":       "Joomla",
        "Drupal":       "Drupal",
        "Magento":      "Magento",
        "Shopify":      "Shopify",
        "PrestaShop":   "PrestaShop",
        "TYPO3":        "TYPO3",
        "Wix.com":      "Wix.com",
        "Blogger":      "Blogger",
        "Ghost":        "Ghost",
        "Squarespace":  "Squarespace",
        "Weebly":       "Weebly",
        "Bolt":         "Bolt",
    }

    // Check if the server header contains any of the CMS identifiers
    for key, value := range cmsIdentifiers {
        if strings.Contains(serverHeader, key) {
            cmsInfo = value
            break
        }
    }
    return cmsInfo
}
