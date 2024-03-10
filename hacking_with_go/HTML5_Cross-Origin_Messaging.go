package main

import (
    "fmt"
    "net/http"
    "os"
)

func main() {
    fmt.Println("\x1b[1;34mHTML5 Cross-Origin Messaging Vulnerability Tester\x1b[0m")
    fmt.Print("Enter your target website URL: ")
    var targetURL string
    fmt.Scanln(&targetURL)

    fmt.Println("\nTesting HTML5 Cross-Origin Messaging...")

    // Start a web server to handle the postMessage
    go func() {
        http.HandleFunc("/receiver", func(w http.ResponseWriter, r *http.Request) {
            fmt.Println("\x1b[1;32mMessage received from:", r.Header.Get("Origin"), "\x1b[0m")
        })
        http.ListenAndServe(":8080", nil)
    }()

    // Create an HTML page to send a postMessage
    html := `<html><body><script>
                var target = window.opener || window.parent;
                target.postMessage("Test message", "*");
              </script></body></html>`

    // Serve the HTML page
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, html)
    })
    go http.ListenAndServe(":9090", nil)

    // Open the target website
    fmt.Println("Open the following URL in your browser:")
    fmt.Println("\x1b[1;36mhttp://localhost:9090/\x1b[0m")

    // Wait for user confirmation
    fmt.Print("\nHave you opened the URL? (Y/N): ")
    var confirmation string
    fmt.Scanln(&confirmation)

    if confirmation != "Y" && confirmation != "y" {
        fmt.Println("Please open the URL and try again.")
        os.Exit(1)
    }

    // Wait for messages to be received
    fmt.Println("\nWaiting for message...")
    fmt.Println("If you see any message received from a different origin, the website might be vulnerable to Cross-Origin Messaging attacks.")

    // Wait for user to terminate
    fmt.Println("\nPress Ctrl+C to exit.")

    select {}
}
