package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
    "strings"
)

func main() {
    // Prompt for target website URL
    fmt.Print("Enter your target website URL: ")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    targetURL := scanner.Text()

    // Send initial request to get session cookie
    resp, err := http.Get(targetURL)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    defer resp.Body.Close()

    // Extract session cookie
    sessionCookie := extractSessionCookie(resp.Cookies())
    if sessionCookie == "" {
        fmt.Println("Error: No session cookie found.")
        return
    }

    fmt.Println("Initial session cookie:", sessionCookie)

    // Prompt for new session cookie
    fmt.Print("Enter the new session cookie value: ")
    scanner.Scan()
    newSessionCookie := scanner.Text()

    // Send request with new session cookie
    client := http.Client{}
    req, err := http.NewRequest("GET", targetURL, nil)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    req.Header.Set("Cookie", fmt.Sprintf("session=%s", newSessionCookie))
    resp, err = client.Do(req)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    defer resp.Body.Close()

    // Check if session cookie has changed
    if sessionCookie == extractSessionCookie(resp.Cookies()) {
        fmt.Println("Session fixation vulnerability not detected.")
    } else {
        fmt.Println("Session fixation vulnerability detected!")
    }
}

func extractSessionCookie(cookies []*http.Cookie) string {
    for _, cookie := range cookies {
        if strings.ToLower(cookie.Name) == "session" {
            return cookie.Value
        }
    }
    return ""
}
