package main

import (
	"fmt"
	"net/http"
	"sync"
	"time"
)

func main() {
	fmt.Println("Misconfigured CORS Vulnerability Tester")

	var targetURL string
	fmt.Print("Enter your target website URL: ")
	fmt.Scanln(&targetURL)

	// Define custom Origin headers for testing
	origins := []string{"http://attacker.com", "http://evil.com", "http://malicious.com"}

	var wg sync.WaitGroup
	for _, origin := range origins {
		wg.Add(1)
		go func(origin string) {
			defer wg.Done()
			testCORS(targetURL, origin)
		}(origin)
	}
	wg.Wait()

	fmt.Println("\nTo manually check for Misconfigured CORS vulnerability:")
	fmt.Println("1. Open the developer tools in your browser (usually F12 or right-click -> Inspect).")
	fmt.Println("2. Go to the 'Network' tab.")
	fmt.Println("3. Visit the target website.")
	fmt.Println("4. Look for requests with the 'Origin' header and corresponding 'Access-Control-Allow-Origin' header in responses.")
}

func testCORS(targetURL, origin string) {
	fmt.Printf("\nTesting CORS with Origin: %s\n", origin)

	// Send preflight CORS request
	preflightReq, err := http.NewRequest("OPTIONS", targetURL, nil)
	if err != nil {
		fmt.Println("Error creating preflight request:", err)
		return
	}
	preflightReq.Header.Set("Origin", origin)
	preflightReq.Header.Set("Access-Control-Request-Method", "GET")

	preflightResp, err := http.DefaultClient.Do(preflightReq)
	if err != nil {
		fmt.Println("Error sending preflight request:", err)
		return
	}
	defer preflightResp.Body.Close()

	fmt.Printf("Response status code for preflight request: %d\n", preflightResp.StatusCode)

	// Check for CORS headers in preflight response
	checkCORSHeaders(preflightResp.Header, origin)

	// Send CORS request with custom Origin header
	corsReq, err := http.NewRequest("GET", targetURL, nil)
	if err != nil {
		fmt.Println("Error creating CORS request:", err)
		return
	}
	corsReq.Header.Set("Origin", origin)

	corsResp, err := http.DefaultClient.Do(corsReq)
	if err != nil {
		fmt.Println("Error sending CORS request:", err)
		return
	}
	defer corsResp.Body.Close()

	fmt.Printf("Response status code for CORS request: %d\n", corsResp.StatusCode)

	// Check for CORS headers in response
	checkCORSHeaders(corsResp.Header, origin)
}

func checkCORSHeaders(headers http.Header, origin string) {
	fmt.Printf("CORS headers for Origin %s:\n", origin)
	for key, values := range headers {
		fmt.Printf("%s: %v\n", key, values)
	}

	// Check for misconfigured CORS headers
	if len(headers.Get("Access-Control-Allow-Origin")) == 0 {
		fmt.Printf("Warning: Missing Access-Control-Allow-Origin header for Origin %s\n", origin)
	} else if headers.Get("Access-Control-Allow-Origin") != "*" && headers.Get("Access-Control-Allow-Origin") != origin {
		fmt.Printf("Vulnerability Detected: Misconfigured Access-Control-Allow-Origin header for Origin %s\n", origin)
	}
	if len(headers.Get("Access-Control-Allow-Methods")) == 0 {
		fmt.Printf("Warning: Missing Access-Control-Allow-Methods header for Origin %s\n", origin)
	}
	if len(headers.Get("Access-Control-Allow-Headers")) == 0 {
		fmt.Printf("Warning: Missing Access-Control-Allow-Headers header for Origin %s\n", origin)
	}
	if len(headers.Get("Access-Control-Allow-Credentials")) == 0 {
		fmt.Printf("Warning: Missing Access-Control-Allow-Credentials header for Origin %s\n", origin)
	}
	if len(headers.Get("Access-Control-Expose-Headers")) == 0 {
		fmt.Printf("Warning: Missing Access-Control-Expose-Headers header for Origin %s\n", origin)
	}
	if len(headers.Get("Access-Control-Max-Age")) == 0 {
		fmt.Printf("Warning: Missing Access-Control-Max-Age header for Origin %s\n", origin)
	} else if age, err := time.ParseDuration(headers.Get("Access-Control-Max-Age")); err == nil && age.Seconds() < 604800 {
		fmt.Printf("Warning: Inadequate Access-Control-Max-Age value for Origin %s\n", origin)
	}
}
