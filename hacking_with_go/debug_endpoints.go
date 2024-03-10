package main

import (
	"fmt"
	"net/http"
	"strings"
)

// Color codes for output formatting
const (
	Reset  = "\033[0m"
	Red    = "\033[31m"
	Green  = "\033[32m"
	Yellow = "\033[33m"
)

// Function to check if a URL is vulnerable to exposed debug endpoints
func checkDebugEndpoints(url string) bool {
	// List of common debug endpoints
	debugEndpoints := []string{
		"/debug",
		"/debug/vars",
		"/debug/pprof",
		"/debug/pprof/heap",
		"/debug/pprof/goroutine",
		"/debug/pprof/block",
		"/debug/pprof/threadcreate",
		"/trace",
		"/debug/fgprof",
		"/debug/log",
		"/debug/zip",
		"/debug/mutex",
		"/debug/allocs",
	}

	// Iterate over each debug endpoint
	for _, endpoint := range debugEndpoints {
		// Construct the full URL
		fullURL := url + endpoint

		// Send a GET request to the endpoint
		resp, err := http.Get(fullURL)
		if err != nil {
			fmt.Printf("Error accessing %s: %v\n", fullURL, err)
			continue
		}

		// Check if the response status code indicates success (200 OK)
		if resp.StatusCode == http.StatusOK {
			fmt.Printf("%s is %svulnerable%s to exposed debug endpoint: %s\n", url, Red, Reset, endpoint)
			return true
		}

		// Close the response body
		resp.Body.Close()
	}

	// If no debug endpoints were found to be exposed
	fmt.Printf("%s is %snot vulnerable%s to exposed debug endpoints\n", url, Green, Reset)
	return false
}

func main() {
	fmt.Println("Welcome to the Exposed Debug Endpoints Tester")

	// Prompt user to enter target website URL
	var targetURL string
	fmt.Print("Enter your target website URL: ")
	fmt.Scanln(&targetURL)

	// Check if the target URL starts with "http://" or "https://", if not, add it
	if !strings.HasPrefix(targetURL, "http://") && !strings.HasPrefix(targetURL, "https://") {
		targetURL = "http://" + targetURL
	}

	// Check for exposed debug endpoints
	vulnerable := checkDebugEndpoints(targetURL)

	if vulnerable {
		fmt.Println("\nTo test this vulnerability, try accessing the debug endpoints listed above.")
		fmt.Println("For example, you can try visiting", targetURL+"/debug/vars")
	}

	fmt.Println("\nProgram execution completed.")
}
