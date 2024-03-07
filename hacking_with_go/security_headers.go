package main

import (
    "fmt"
    "net/http"
    "sync"
)

// HeaderInfo struct to hold header name and its value
type HeaderInfo struct {
    Name  string
    Value string
}

func main() {
    // Prompt user for target website URL
    fmt.Print("Enter your target website URL: ")
    var targetURL string
    fmt.Scanln(&targetURL)

    // Slice of header names to retrieve
    headersToRetrieve := []string{
        "Content-Security-Policy",
        "X-Content-Type-Options",
        "X-Frame-Options",
        "X-XSS-Protection",
        "Strict-Transport-Security",
    }

    // Channel to receive header info
    headerChan := make(chan HeaderInfo)

    // Wait group for concurrent execution
    var wg sync.WaitGroup

    // Concurrently fetch headers
    for _, headerName := range headersToRetrieve {
        wg.Add(1)
        go fetchHeader(targetURL, headerName, &wg, headerChan)
    }

    // Close channel once all goroutines are done
    go func() {
        wg.Wait()
        close(headerChan)
    }()

    // Print header info as it becomes available
    for header := range headerChan {
        fmt.Printf("%s: %s\n", header.Name, header.Value)
    }

    // Testing instructions
    fmt.Println("\nTesting the Vulnerability:")
    fmt.Println("----------------------------")
    fmt.Println("1. Check if Content-Security-Policy restricts loading resources from untrusted sources.")
    fmt.Println("2. Ensure X-Content-Type-Options is set to 'nosniff' to prevent MIME type sniffing.")
    fmt.Println("3. Verify X-Frame-Options is set to 'DENY' or 'SAMEORIGIN' to prevent clickjacking.")
    fmt.Println("4. Confirm X-XSS-Protection is enabled with '1; mode=block' to prevent XSS attacks.")
    fmt.Println("5. Ensure Strict-Transport-Security is set with a reasonable max-age to enforce HTTPS usage.")

}

// fetchHeader retrieves a specific header from the provided URL
func fetchHeader(url, headerName string, wg *sync.WaitGroup, headerChan chan<- HeaderInfo) {
    defer wg.Done()
    response, err := http.Get(url)
    if err != nil {
        fmt.Printf("Error fetching URL (%s): %v\n", url, err)
        return
    }
    defer response.Body.Close()

    headerValue := response.Header.Get(headerName)
    headerChan <- HeaderInfo{Name: headerName, Value: headerValue}
}
