package main

import (
    "fmt"
    "net/http"
    "io/ioutil"
    "strings"
)

func main() {
    // Prompt the user for the target website URL
    var targetURL string
    fmt.Print("Enter your target website URL: ")
    fmt.Scanln(&targetURL)

    // Send a request to the target website
    resp, err := http.Get(targetURL)
    if err != nil {
        fmt.Println("Error accessing the website:", err)
        return
    }
    defer resp.Body.Close()

    // Read the response body
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println("Error reading response body:", err)
        return
    }

    // Analyze the response for any indication of Session Hijacking vulnerability
    // For example, check for session cookies and their attributes
    cookies := resp.Cookies()
    sessionCookie := findSessionCookie(cookies)

    if sessionCookie != nil {
        fmt.Printf("Session cookie found: %s=%s\n", sessionCookie.Name, sessionCookie.Value)
        // Check if the session cookie is secure and HTTPOnly
        if sessionCookie.Secure && sessionCookie.HttpOnly {
            fmt.Println("Session cookie is secure and HTTPOnly. It may be resistant to Session Hijacking.")
        } else {
            fmt.Println("Session cookie is not secure or HTTPOnly. It may be vulnerable to Session Hijacking.")
        }
    } else {
        fmt.Println("No session cookie found. The website may not use session management.")
    }

    // Print the response body
    fmt.Println("\nResponse Body:", string(body))

    // Instructions on how to test the vulnerability manually
    fmt.Println("\nTo test for Session Hijacking vulnerability manually:")
    fmt.Println("1. Use a tool like Burp Suite to intercept and modify cookies.")
    fmt.Println("2. Look for session cookies and attempt to manipulate them.")
    fmt.Println("3. If successful, you may gain unauthorized access to another user's session.")

    // Additional steps to make the program more effective could include:
    // - Checking for weak session IDs or predictable session tokens
    // - Attempting to manipulate session data to gain unauthorized access
}

// Function to find the session cookie
func findSessionCookie(cookies []*http.Cookie) *http.Cookie {
    for _, cookie := range cookies {
        if strings.Contains(strings.ToLower(cookie.Name), "session") {
            return cookie
        }
    }
    return nil
}
