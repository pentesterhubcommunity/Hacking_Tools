#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <fstream>

// Function to run a command
void run_command(const char *command) {
    std::cout << "Command: " << command << std::endl;
    system(command);
    std::cout << std::endl;
}

int main() {
    // Prompt user for target URL
    char target_url[1000];
    std::cout << "Enter your target URL: ";
    std::cin.getline(target_url, sizeof(target_url));
    target_url[strcspn(target_url, "\n")] = 0; // Remove newline character

    // Run Gobuster to discover URLs
    char gobuster_command[2000];
    sprintf(gobuster_command, "gobuster dir -u %s -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt -o gobuster_results.txt", target_url);
    std::cout << "Running Gobuster on " << target_url << " ...\n";
    system(gobuster_command);

    // Check if Gobuster ran successfully
    if (system("echo $?") == 0) {
        std::cout << "Gobuster completed successfully.\n";
    } else {
        std::cout << "Error: Gobuster failed to run.\n";
        exit(1);
    }

    // Extract URLs from Gobuster results
    std::cout << "Extracting URLs...\n";
    std::ifstream fp("gobuster_results.txt");
    char line[1000];
    while (fp.getline(line, sizeof(line))) {
        if (line[0] == '/') {
            char *url = strtok(line, " ");
            std::cout << "Testing URL: " << url << std::endl;
            
            // Define additional test commands
            const char* test_commands[] = {
                "curl -s -o /dev/null -w '%%{http_code}' %s",
                "curl -X POST -s -o /dev/null -w '%%{http_code}' %s"
                "curl -X PUT -s -o /dev/null -w '%%{http_code}' %s"
                "curl -X DELETE -s -o /dev/null -w '%%{http_code}' %s"
                "curl -X OPTIONS -s -o /dev/null -w '%%{http_code}' %s"
                "curl -X TRACE -s -o /dev/null -w '%%{http_code}' %s"
                "curl -X HEAD -s -o /dev/null -w '%%{http_code}' %s"
                "curl -X CONNECT -s -o /dev/null -w '%%{http_code}' %s"
                "wget -q --method=HEAD -O /dev/null %s"
                "nc -z -v %s 80"
                "sqlmap -u %s --batch --random-agent" // You might need to adjust this based on your SQLMap configuration
                "nmap -p 1-65535 %s" // Full port scan
                "nikto -h %s" // Web server scanner
                "dirb %s" // Directory brute-forcing
                "wpscan --url %s" // WordPress vulnerability scanner
                "gobuster dns -d %s -w /usr/share/wordlists/dirbuster/dns-Jhaddix.txt" // DNS subdomain brute-forcing
                "amass enum -d %s" // DNS enumeration
                "wfuzz -c --hc 404 -w /usr/share/wordlists/wfuzz/general/common.txt %s/FUZZ" // Fuzzing for sensitive files/directories
                "hydra -L /usr/share/wordlists/metasploit/http_default_userpass.txt -P /usr/share/wordlists/metasploit/http_default_pass.txt %s http-get /" // Brute force login
                "git clone --recursive %s" // Attempt to clone the repository
                "svn checkout %s" // Attempt to checkout the SVN repository
                "testssl.sh %s" // SSL/TLS security testing
                "nikto -host %s" // Web server scanner (Nikto)
                "uniscan -u %s -qweds" // Web application vulnerability scanner
                "whatweb %s" // Web scanner
                "dotdotpwn -m http -h %s" // Directory traversal scanner
                "sslscan --no-failed %s" // SSL/TLS security testing
                "nmap -sV --script=banner %s" // Version detection
                "nmap --script=http-enum %s" // HTTP enum script
                "sqlmap -u %s --forms --batch --random-agent" // Automated SQL injection testing
                "nikto -host %s -Tuning 10" // Enhanced Nikto testing
                "dirsearch -u %s -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt -e html,php,asp,aspx,jsp,do,action,xml" // Directory and file brute-forcing
                "wafw00f %s" // Web Application Firewall detection
                "nuclei -target %s -t /path/to/nuclei-templates" // Generic vulnerability scanner
                "snmp-check %s" // SNMP enumeration and testing
                "smtp-user-enum -M VRFY -U /usr/share/wordlists/metasploit/unix_users.txt -t %s" // SMTP user enumeration
                "ike-scan %s" // IKE/IPsec VPN scanning
                // Add more test commands as needed
            };

            for (const char* test_command : test_commands) {
                char command[2000];
                snprintf(command, sizeof(command), test_command, target_url);
                run_command(command);
            }
        }
    }
    fp.close();

    std::cout << "Broken access control test completed.\n";

    return 0;
}
