package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
    "strings"
)

func main() {
    fmt.Println("\033[1;34mContent Security Policy (CSP) Bypass Tester\033[0m")

    // Ask for the target website URL
    fmt.Print("\033[1;32mEnter your target website URL: \033[0m")
    reader := bufio.NewReader(os.Stdin)
    targetURL, _ := reader.ReadString('\n')
    targetURL = strings.TrimSpace(targetURL)

    // Make a request to the target website
    fmt.Println("\033[1;36mMaking a request to the target website...\033[0m")
    resp, err := http.Get(targetURL)
    if err != nil {
        fmt.Printf("\033[1;31mError: %v\033[0m\n", err)
        return
    }
    defer resp.Body.Close()

    // Check if the target website is vulnerable
    vulnerable := isVulnerable(resp)
    if vulnerable {
        fmt.Println("\033[1;33mThe target website may be vulnerable to CSP bypass!\033[0m")
        fmt.Println("\033[1;36mTo test this vulnerability, try injecting scripts and observing if they execute.\033[0m")
    } else {
        fmt.Println("\033[1;32mThe target website does not appear to be vulnerable to CSP bypass.\033[0m")
    }
}

func isVulnerable(resp *http.Response) bool {
    // Check if the Content-Security-Policy header is present
    cspHeader := resp.Header.Get("Content-Security-Policy")
    if cspHeader == "" {
        fmt.Println("\033[1;32mNo Content-Security-Policy header found. Website may not be vulnerable.\033[0m")
        return false
    }

    // Check if the Content-Security-Policy header allows unsafe-inline
    if strings.Contains(cspHeader, "'unsafe-inline'") {
        fmt.Println("\033[1;33mContent-Security-Policy header allows 'unsafe-inline', indicating potential vulnerability.\033[0m")
        return true
    }

    // Check if the Content-Security-Policy header allows unsafe-eval
    if strings.Contains(cspHeader, "'unsafe-eval'") {
        fmt.Println("\033[1;33mContent-Security-Policy header allows 'unsafe-eval', indicating potential vulnerability.\033[0m")
        return true
    }

    return false
}
