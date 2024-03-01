package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
    "strings"
)

func main() {
    // Prompt user to enter the target website
    fmt.Print("Enter your target website: ")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    url := scanner.Text()

    // Send GET request to the target website to retrieve parameters
    resp, err := http.Get(url)
    if err != nil {
        fmt.Println("Error fetching website:", err)
        return
    }
    defer resp.Body.Close()

    // Read response body
    body, err := bufio.NewReader(resp.Body).ReadString('\n')
    if err != nil {
        fmt.Println("Error reading response:", err)
        return
    }

    // Extract parameters from the response body
    parameters := extractParameters(body)

    // Send HTTP requests with each parameter
    for _, param := range parameters {
        // Craft different payloads with the same parameter name but different values
        payloads := map[string]string{
            param: "value1",
            param: "value2",
            // Add more payloads as needed
        }

        // Send POST request with each payload
        for paramName, paramValue := range payloads {
            // Create request body with the parameter payload
            body := strings.NewReader(fmt.Sprintf("%s=%s", paramName, paramValue))

            // Send POST request to the website
            resp, err := http.Post(url, "application/x-www-form-urlencoded", body)
            if err != nil {
                fmt.Println("Error sending request:", err)
                return
            }
            defer resp.Body.Close()

            // Read response body
            respBody, err := bufio.NewReader(resp.Body).ReadString('\n')
            if err != nil {
                fmt.Println("Error reading response:", err)
                return
            }

            // Check if the response contains any indicators of successful exploitation
            // This could include changes in application behavior, error messages, or unexpected output
            // Analyze respBody for any signs of parameter pollution vulnerability

            // Example: Check if response body contains a specific string indicating successful exploitation
            if strings.Contains(respBody, "Vulnerability exploited!") {
                fmt.Printf("Parameter pollution vulnerability found with payload: %s=%s\n", paramName, paramValue)
            } else {
                fmt.Printf("No vulnerability found with payload: %s=%s\n", paramName, paramValue)
            }
        }
    }
}

// Extract parameters from the HTML response body
func extractParameters(body string) []string {
    // Here you need to implement your logic to extract parameters from the HTML response body
    // This could involve using regular expressions, HTML parsing libraries, or custom logic
    // For simplicity, let's assume we're looking for parameter names within HTML form tags
    parameters := []string{"param1", "param2", "param3"} // Example parameters
    return parameters
}
