package main

import (
    "bufio"
    "fmt"
    "io/ioutil"
    "net/http"
    "os"
    "strings"
    "sync"
)

func main() {
    // Prompt the user to enter the target website URL
    fmt.Print("Enter your target website URL: ")
    reader := bufio.NewReader(os.Stdin)
    url, err := reader.ReadString('\n')
    if err != nil {
        fmt.Println("Error reading input:", err)
        return
    }
    url = strings.TrimSpace(url)

    // Payloads to inject - Modify and add more payloads as per your testing needs
    payloads := []string{
        "<script>alert('Vulnerable!');</script>",
        "<img src=x onerror=alert('Vulnerable!')>",
        "<svg/onload=alert('Vulnerable!')>",
        "<body onload=alert('Vulnerable!')>",
        "<marquee onstart=alert('Vulnerable!')>Test</marquee>",
        "<div style=\"display:none\" onload=alert('Vulnerable!')></div>",
        "<iframe src=\"javascript:alert('Vulnerable!');\"></iframe>",
        "<input type=\"image\" src=\"javascript:alert('Vulnerable!');\">",
        "<object data=\"javascript:alert('Vulnerable!');\"></object>",
        "<plaintext><script>alert('Vulnerable!');</script></plaintext>",
    }

    // Channel to receive results from Goroutines
    results := make(chan bool)

    // WaitGroup to wait for Goroutines to finish
    var wg sync.WaitGroup

    // Send concurrent requests with different payloads
    for _, payload := range payloads {
        wg.Add(1)
        go func(payload string) {
            defer wg.Done()

            // Send a GET request to the target URL
            resp, err := http.Get(url)
            if err != nil {
                fmt.Printf("Error sending GET request with payload %q: %v\n", payload, err)
                results <- false
                return
            }
            defer resp.Body.Close()

            // Read the response body
            bodyBytes, err := ioutil.ReadAll(resp.Body)
            if err != nil {
                fmt.Printf("Error reading response body with payload %q: %v\n", payload, err)
                results <- false
                return
            }

            // Convert response body to string
            responseBody := string(bodyBytes)

            // Check if the payload is present in the response body
            if strings.Contains(responseBody, payload) {
                fmt.Printf("Vulnerable to HTML injection with payload: %q\n", payload)
                results <- true
            } else {
                results <- false
            }
        }(payload)
    }

    // Close the channel when all Goroutines are done
    go func() {
        wg.Wait()
        close(results)
    }()

    // Check results from Goroutines
    vulnerable := false
    for result := range results {
        if result {
            vulnerable = true
            break
        }
    }

    if !vulnerable {
        fmt.Println("Not vulnerable to HTML injection.")
    }
}
