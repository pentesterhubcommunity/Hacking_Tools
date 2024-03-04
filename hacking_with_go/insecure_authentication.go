package main

import (
	"fmt"
	"net/http"
	"net/url"
	"os"
)

func main() {
	fmt.Print("Enter your target website URL: ")
	var targetURL string
	fmt.Scanln(&targetURL)

	// Validate and normalize the URL
	parsedURL, err := url.Parse(targetURL)
	if err != nil {
		fmt.Println("Invalid URL:", err)
		os.Exit(1)
	}

	// Check if the URL scheme is provided
	if parsedURL.Scheme == "" {
		targetURL = "http://" + targetURL
	}

	// Send an HTTP GET request to the target URL
	resp, err := http.Get(targetURL)
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	// Check if the response status code indicates the use of insecure authentication
	if resp.StatusCode == http.StatusUnauthorized || resp.StatusCode == http.StatusForbidden {
		fmt.Println("Insecure Authentication Vulnerability Detected!")
		fmt.Println("The website is returning Unauthorized or Forbidden status codes without proper authentication.")
		fmt.Println("To test this vulnerability further, you can try accessing restricted resources or endpoints without proper authentication.")
	} else if resp.StatusCode == http.StatusOK {
		fmt.Println("No Insecure Authentication Vulnerability Detected.")
	} else {
		fmt.Println("Unexpected response status code:", resp.StatusCode)
	}
}
