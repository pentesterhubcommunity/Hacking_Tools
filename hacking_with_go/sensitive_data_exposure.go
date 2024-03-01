package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"strings"
	"sync"
	"time"
)

var (
	client        = &http.Client{Timeout: 10 * time.Second}
	resultsFile   *os.File
	resultsMutex  sync.Mutex
	concurrency   = 10
	userAgents    = []string{
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:95.0) Gecko/20100101 Firefox/95.0",
	}
)

func main() {
	// Open a file to log the results
	var err error
	resultsFile, err = os.Create("results.txt")
	if err != nil {
		fmt.Println("Error opening results file:", err)
		return
	}
	defer resultsFile.Close()

	// Prompt the user to enter the target website URL
	targetURL := getUserInput("Enter your target website URL: ")

	// Send HTTP requests concurrently
	var wg sync.WaitGroup
	taskChan := make(chan string)

	// Start worker pool
	for i := 0; i < concurrency; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for endpoint := range taskChan {
				testEndpoint(targetURL, endpoint)
			}
		}()
	}

	// Add initial endpoints to the task channel
	for _, endpoint := range discoverEndpoints(targetURL) {
		taskChan <- endpoint
	}

	// Wait for all workers to finish
	go func() {
		wg.Wait()
		close(taskChan)
	}()
}

func testEndpoint(baseURL, endpoint string) {
	url := strings.TrimSuffix(baseURL, "/") + endpoint

	// Randomly select a User-Agent
	rand.Seed(time.Now().UnixNano())
	userAgent := userAgents[rand.Intn(len(userAgents))]

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		logResult(url, fmt.Sprintf("Error creating request: %v", err))
		return
	}
	req.Header.Set("User-Agent", userAgent)

	resp, err := client.Do(req)
	if err != nil {
		logResult(url, fmt.Sprintf("Error: %v", err))
		return
	}
	defer resp.Body.Close()

	// Check if the response status code indicates success (2xx)
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		logResult(url, "Potential sensitive data exposed")
	} else {
		logResult(url, fmt.Sprintf("HTTP Error: %s", resp.Status))
	}
}

func discoverEndpoints(baseURL string) []string {
	// Add logic here to dynamically discover endpoints (e.g., crawling the website)
	// For demonstration, return a static list of endpoints
	return []string{"/admin", "/config.php", "/database.sql"}
}

func logResult(url, result string) {
	resultsMutex.Lock()
	defer resultsMutex.Unlock()
	currentTime := time.Now().Format("2006-01-02 15:04:05")
	fmt.Printf("[%s] %s: %s\n", currentTime, url, result)
	_, err := resultsFile.WriteString(fmt.Sprintf("[%s] %s: %s\n", currentTime, url, result))
	if err != nil {
		fmt.Println("Error writing result to file:", err)
	}
}

func getUserInput(prompt string) string {
	fmt.Print(prompt)
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	return scanner.Text()
}
