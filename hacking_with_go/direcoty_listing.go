package main

import (
    "fmt"
    "io/ioutil"
    "net/http"
    "sync"
    "time"
)

func main() {
    // Ask user for target website URL
    fmt.Print("Enter your target website url: ")
    var targetURL string
    fmt.Scanln(&targetURL)

    // List of directory paths to test
    directories := []string{
        "", "/", "/cgi-bin/", "/uploads/", "/admin/", "/backup/", "/etc/", "/tmp/",
        "/wp-content/", "/wp-admin/", "/wp-includes/", "/wp-json/", "/wordpress/", "/wp/", "/images/",
        "/scripts/", "/css/", "/js/", "/config/", "/lib/", "/includes/", "/data/", "/public/", "/private/",
        "/sites/", "/assets/", "/themes/", "/plugins/", "/cache/", "/docs/", "/logs/", "/phpmyadmin/",
        "/sql/", "/uploads/", "/vendor/", "/test/", "/web/", "/users/", "/system/", "/files/",
    }

    // List of user-agent strings to mimic different web browsers
    userAgents := []string{
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15",
        "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36 Edge/18.22000",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36 Edg/97.0.1072.55",
    }

    fmt.Println("Testing for Directory Listing vulnerability on", targetURL)

    var wg sync.WaitGroup
    for _, dir := range directories {
        for _, userAgent := range userAgents {
            for _, method := range []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"} {
                wg.Add(1)
                go func(dir, userAgent, method string) {
                    defer wg.Done()
                    url := targetURL + dir
                    fmt.Println("Testing directory:", url, "with User-Agent:", userAgent, "using method:", method)
                    client := http.Client{
                        Timeout: 5 * time.Second, // Set timeout for HTTP requests
                    }
                    req, err := http.NewRequest(method, url, nil)
                    if err != nil {
                        fmt.Println("Error creating request for", url, ":", err)
                        return
                    }
                    // Set a user-agent header to mimic a real web browser request
                    req.Header.Set("User-Agent", userAgent)

                    resp, err := client.Do(req)
                    if err != nil {
                        fmt.Println("Error accessing", url, ":", err)
                        return
                    }
                    defer resp.Body.Close()

                    // Check if directory listing is enabled
                    if resp.StatusCode == http.StatusOK || resp.StatusCode == http.StatusPartialContent {
                        fmt.Println("Directory listing is enabled for:", url)
                        // Display the list of directories/files
                        body, err := ioutil.ReadAll(resp.Body)
                        if err != nil {
                            fmt.Println("Error reading response body:", err)
                            return
                        }
                        fmt.Println("Response body:", string(body))
                    } else {
                        fmt.Println("Directory listing is not enabled for:", url)
                    }
                }(dir, userAgent, method)
            }
        }
    }
    wg.Wait()

    // Instructions on exploiting the vulnerability
    fmt.Println("\nTo exploit the vulnerability, try accessing the discovered directories/files in a web browser.")
    fmt.Println("If directory listing is enabled, you will see a list of files and directories, revealing potentially sensitive information.")
}
