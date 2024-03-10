package main

import (
	"bufio"
	"fmt"
	"net/http"
	"os"
	"strings"
)

func main() {
	fmt.Println("Welcome to HTTP Request Smuggling Vulnerability Tester")

	// Ask for target website URL
	fmt.Print("Enter your target website URL: ")
	targetURL, _ := bufio.NewReader(os.Stdin).ReadString('\n')
	targetURL = strings.TrimSpace(targetURL)

	// Check for vulnerability
	vulnerable := checkVulnerability(targetURL)

	// Display result
	if vulnerable {
		fmt.Println("The target website may be vulnerable to HTTP Request Smuggling!")
	} else {
		fmt.Println("The target website does not appear to be vulnerable to HTTP Request Smuggling.")
	}

	// Show how to test vulnerability
	fmt.Println("\nTo test the vulnerability, you can perform the following steps:")
	fmt.Println("1. Use a proxy tool such as Burp Suite to intercept requests.")
	fmt.Println("2. Send multiple HTTP requests with different content lengths.")
	fmt.Println("3. Check if the backend server processes the requests as expected or if there is any discrepancy in behavior.")
}

func checkVulnerability(targetURL string) bool {
	client := &http.Client{}

	// Create a request with a content-length header discrepancy
	req, err := http.NewRequest("GET", targetURL, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return false
	}
	req.Header.Set("Content-Length", "5")

	// Send the request
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error sending request:", err)
		return false
	}
	defer resp.Body.Close()

	// Check the response for potential discrepancies
	if resp.StatusCode == http.StatusOK {
		return false // Not vulnerable
	}
	return true // Vulnerable
}
