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

    // Run Gobuster to discover URLs
    fmt.Printf("Running Gobuster on %s ...\n", targetURL)
    gobusterCmd := exec.Command("gobuster", "dir", "-u", targetURL, "-w", "/usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt", "-o", "gobuster_results.txt")
    gobusterCmd.Stdout = os.Stdout
    gobusterCmd.Stderr = os.Stderr
    if err := gobusterCmd.Run(); err != nil {
        log.Fatalf("Error running Gobuster: %v\n", err)
    }

    // Check if Gobuster ran successfully
    if gobusterCmd.ProcessState.ExitCode() != 0 {
        log.Fatal("Error: Gobuster failed to run.")
    }

    // Extract URLs from Gobuster results
    fmt.Println("Extracting URLs...")
    file, err := os.Open("gobuster_results.txt")
    if err != nil {
        log.Fatal("Error opening file:", err)
    }
    defer file.Close()

    var urls []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := scanner.Text()
        if strings.HasPrefix(line, "/") {
            fields := strings.Fields(line)
            if len(fields) >= 2 {
                urls = append(urls, fields[1])
            }
        }
    }
    if err := scanner.Err(); err != nil {
        log.Fatal("Error scanning file:", err)
    }

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
		fmt.Sprintf("gobuster dns -d %s -w /usr/share/wordlists/dirbuster/dns-Jhaddix.txt", targetURL), // DNS subdomain brute-forcing
		fmt.Sprintf("amass enum -d %s", targetURL), // DNS enumeration
		fmt.Sprintf("wfuzz -c --hc 404 -w /usr/share/wordlists/wfuzz/general/common.txt %s/FUZZ", targetURL), // Fuzzing for sensitive files/directories
		fmt.Sprintf("hydra -L /usr/share/wordlists/metasploit/http_default_userpass.txt -P /usr/share/wordlists/metasploit/http_default_pass.txt %s http-get /", targetURL), // Brute force login
		fmt.Sprintf("git clone --recursive %s", targetURL), // Attempt to clone the repository
		fmt.Sprintf("svn checkout %s", targetURL), // Attempt to checkout the SVN repository
		fmt.Sprintf("testssl.sh %s", targetURL), // SSL/TLS security testing
		fmt.Sprintf("nikto -host %s", targetURL), // Web server scanner (Nikto)
		fmt.Sprintf("uniscan -u %s -qweds", targetURL), // Web application vulnerability scanner
		fmt.Sprintf("whatweb %s", targetURL), // Web scanner
		fmt.Sprintf("dotdotpwn -m http -h %s", targetURL), // Directory traversal scanner
		fmt.Sprintf("sslscan --no-failed %s", targetURL), // SSL/TLS security testing
		fmt.Sprintf("nmap -sV --script=banner %s", targetURL), // Version detection
		fmt.Sprintf("nmap --script=http-enum %s", targetURL), // HTTP enum script
		fmt.Sprintf("sqlmap -u %s --forms --batch --random-agent", targetURL), // Automated SQL injection testing
		fmt.Sprintf("nikto -host %s -Tuning 10", targetURL), // Enhanced Nikto testing
		fmt.Sprintf("dirsearch -u %s -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt -e html,php,asp,aspx,jsp,do,action,xml", targetURL), // Directory and file brute-forcing
		fmt.Sprintf("wafw00f %s", targetURL), // Web Application Firewall detection
		fmt.Sprintf("nuclei -target %s -t /path/to/nuclei-templates", targetURL), // Generic vulnerability scanner
		fmt.Sprintf("snmp-check %s", targetURL), // SNMP enumeration and testing
		fmt.Sprintf("smtp-user-enum -M VRFY -U /usr/share/wordlists/metasploit/unix_users.txt -t %s", targetURL), // SMTP user enumeration
		fmt.Sprintf("ike-scan %s", targetURL), // IKE/IPsec VPN scanning
		// Add more test commands as needed
	}
	

    // Iterate through each URL and perform broken access control test
    fmt.Println("Performing broken access control test...")
    for _, url := range urls {
        fmt.Printf("Testing URL: %s\n", url)
        for _, command := range testCommands {
            fmt.Printf("Command: %s\n", command)
            cmd := exec.Command("bash", "-c", command+url)
            cmd.Stdout = os.Stdout
            cmd.Stderr = os.Stderr
            if err := cmd.Run(); err != nil {
                log.Printf("Error executing command: %v\n", err)
            }
            fmt.Println()
        }
    }
    fmt.Println("Broken access control test completed.")
}
