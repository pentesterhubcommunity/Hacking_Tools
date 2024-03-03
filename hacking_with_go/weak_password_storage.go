package main

import (
    "fmt"
    "log"
    "net/http"
    "strings"
)

// Colors for better visualization
const (
    Reset  = "\033[0m"
    Red    = "\033[31m"
    Green  = "\033[32m"
    Yellow = "\033[33m"
)

func main() {
    fmt.Println("Welcome to Weak Password Storage Vulnerability Tester")

    // Prompt user for target website URL
    fmt.Print("Enter your target website URL: ")
    var targetURL string
    fmt.Scanln(&targetURL)

    // Make a GET request to the target URL
    resp, err := http.Get(targetURL)
    if err != nil {
        log.Fatal("Error fetching website:", err)
    }
    defer resp.Body.Close()

    // Check if response header contains "Set-Cookie" field
    if strings.Contains(resp.Header.Get("Set-Cookie"), "password=") {
        fmt.Printf("%sWarning:%s Potential Weak Password Storage Vulnerability detected on %s\n", Red, Reset, targetURL)
        fmt.Println("How to test this vulnerability manually:")
        fmt.Println("1. Create an account on the website with a simple password (e.g., 'password123').")
        fmt.Println("2. Log out and attempt to log back in using the same password.")
        fmt.Println("3. If the website allows you to log in with the same simple password, it likely has weak password storage.")
    } else {
        fmt.Printf("%sSuccess:%s No Weak Password Storage Vulnerability detected on %s\n", Green, Reset, targetURL)
    }
}
