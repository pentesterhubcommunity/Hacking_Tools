package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "os/exec"
    "strings"
)

func main() {
    // Prompt user for target URL
    fmt.Print("Enter your target URL: ")
    reader := bufio.NewReader(os.Stdin)
    targetURL, err := reader.ReadString('\n')
    if err != nil {
        log.Fatal("Error reading input:", err)
    }
    targetURL = strings.TrimSpace(targetURL)

    // Define additional test commands
    testCommands := []string{
        fmt.Sprintf("curl -s -o /dev/null -w '%%{http_code}' %s", targetURL),
        fmt.Sprintf("curl -X POST -s -o /dev/null -w '%%{http_code}' %s", targetURL),
        fmt.Sprintf("curl -X PUT -s -o /dev/null -w '%%{http_code}' %s", targetURL),
        fmt.Sprintf("curl -X DELETE -s -o /dev/null -w '%%{http_code}' %s", targetURL),
        fmt.Sprintf("curl -X OPTIONS -s -o /dev/null -w '%%{http_code}' %s", targetURL),
        fmt.Sprintf("curl -X TRACE -s -o /dev/null -w '%%{http_code}' %s", targetURL),
        fmt.Sprintf("curl -X HEAD -s -o /dev/null -w '%%{http_code}' %s", targetURL),
        fmt.Sprintf("curl -X CONNECT -s -o /dev/null -w '%%{http_code}' %s", targetURL),
        fmt.Sprintf("wget -q --method=HEAD -O /dev/null %s", targetURL),
        fmt.Sprintf("nc -z -v %s 80", targetURL),
        fmt.Sprintf("sqlmap -u %s --batch --random-agent", targetURL), // You might need to adjust this based on your SQLMap configuration
        fmt.Sprintf("nmap -p 1-65535 %s", targetURL), // Full port scan
        fmt.Sprintf("nikto -h %s", targetURL), // Web server scanner
        fmt.Sprintf("dirb %s", targetURL), // Directory brute-forcing
        fmt.Sprintf("wpscan --url %s", targetURL), // WordPress vulnerability scanner
        // Add more test commands as needed
    }

    // Perform broken access control test
    fmt.Println("Performing broken access control test...")
    for _, command := range testCommands {
        fmt.Printf("Command: %s\n", command)
        cmd := exec.Command("bash", "-c", command)
        cmd.Stdout = os.Stdout
        cmd.Stderr = os.Stderr
        if err := cmd.Run(); err != nil {
            log.Printf("Error executing command: %v\n", err)
        }
        fmt.Println()
    }
    fmt.Println("Broken access control test completed.")
}
