package main

import (
    "bufio"
    "fmt"
    "math/rand"
    "net/http"
    "os"
    "sync"
    "time"
)

// List of manipulated headers to test
var manipulatedHeaders = []string{
    "X-Forwarded-Host",
    "X-Forwarded-Proto",
    "X-Forwarded-For",
    "X-Original-URL",
    "X-Rewrite-URL",
    "X-Client-IP",
    "X-Host",
    "X-Remote-IP",
    "X-Forwarded-URI",
    "X-Originating-IP",
}

// List of custom headers to include in requests
var customHeaders = map[string]string{
    "User-Agent":      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36",
    "Accept-Language": "en-US,en;q=0.9",
    // Add more custom headers as needed
}

func main() {
    // Prompt user to input the target website URL
    fmt.Print("Enter your target website URL: ")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    url := scanner.Text()

    // Set up HTTP client with timeout
    httpClient := &http.Client{
        Timeout: 10 * time.Second,
    }

    // Number of concurrent requests
    numWorkers := 10
    var wg sync.WaitGroup
    wg.Add(numWorkers)

    // Channel for results
    results := make(chan string)

    // Start worker goroutines
    for i := 0; i < numWorkers; i++ {
        go func() {
            defer wg.Done()
            for {
                method := getRandomMethod()
                header := getRandomHeader()
                value := getRandomValue()
                req, err := http.NewRequest(method, url, nil)
                if err != nil {
                    results <- fmt.Sprintf("Error creating request: %v", err)
                    return
                }
                // Set custom headers
                for key, val := range customHeaders {
                    req.Header.Set(key, val)
                }
                req.Header.Set(header, value)

                // Send the request
                resp, err := httpClient.Do(req)
                if err != nil {
                    results <- fmt.Sprintf("Error sending request: %v", err)
                    return
                }
                defer resp.Body.Close()

                // Analyze response for cache deception
                if isCacheDeception(resp) {
                    results <- fmt.Sprintf("Potential cache deception detected: Method=%s, Header=%s, Value=%s", method, header, value)
                }
            }
        }()
    }

    // Start a goroutine to collect results
    go func() {
        for result := range results {
            fmt.Println(result)
        }
    }()

    // Wait for all workers to finish
    wg.Wait()

    // Close the results channel
    close(results)
}

// getRandomMethod returns a randomly selected HTTP method
func getRandomMethod() string {
    methods := []string{"GET", "POST", "PUT", "DELETE"}
    return methods[rand.Intn(len(methods))]
}

// getRandomHeader returns a randomly selected header from the list of manipulated headers
func getRandomHeader() string {
    return manipulatedHeaders[rand.Intn(len(manipulatedHeaders))]
}

// getRandomValue generates a random value for a manipulated header
func getRandomValue() string {
    return fmt.Sprintf("random-%d", rand.Intn(1000))
}

// isCacheDeception checks if the response indicates potential cache deception
func isCacheDeception(resp *http.Response) bool {
    // Analyze response headers and content for cache deception indicators
    // For example, check for variations in caching headers
    return false // Placeholder, implement your logic here
}
