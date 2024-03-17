package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

// PerformDorking performs Google dorking for the target domain
func PerformDorking(targetDomain string, queries []string) {
	for _, query := range queries {
		// Open Google Chrome with the dorking query
		command := exec.Command("google-chrome", "https://www.google.com/search?q="+query)
		err := command.Start()
		if err != nil {
			fmt.Println("Error:", err)
			continue
		}
		fmt.Println("Opening Google Chrome with the dork query:", query)

		// Wait for the command to finish
		err = command.Wait()
		if err != nil {
			fmt.Println("Error:", err)
		}
	}
	fmt.Println("All dorking queries for", targetDomain, "have been executed. Close the tabs when you're done viewing the results.")
}

func main() {
	// Slice to store dork queries
	queries := []string{
		"site:{target_domain} inurl:login",
		"site:{target_domain} intitle:index.of",
		"site:{target_domain} intext:password",
		"site:{target_domain} filetype:pdf",
		"site:{target_domain} inurl:admin",
		"site:{target_domain} intitle:admin",
		"site:{target_domain} intitle:dashboard",
		"site:{target_domain} intitle:config OR site:{target_domain} intitle:configuration",
		"site:{target_domain} intitle:setup",
		"site:{target_domain} intitle:phpinfo",
		"site:{target_domain} inurl:wp-admin",
		"site:{target_domain} inurl:wp-content",
		"site:{target_domain} inurl:wp-includes",
		"site:{target_domain} inurl:wp-login",
		"site:{target_domain} inurl:wp-config",
		"site:{target_domain} inurl:wp-config.txt",
		"site:{target_domain} inurl:wp-config.php",
		"site:{target_domain} inurl:wp-config.php.bak",
		"site:{target_domain} inurl:wp-config.php.old",
		"site:{target_domain} inurl:wp-config.php.save",
		"site:{target_domain} inurl:wp-config.php.swp",
		"site:{target_domain} inurl:wp-config.php~",
		"site:{target_domain} inurl:wp-config.bak",
		"site:{target_domain} inurl:wp-config.old",
		"site:{target_domain} inurl:wp-config.save",
		"site:{target_domain} inurl:wp-config.swp",
		"site:{target_domain} inurl:wp-config~",
		"site:{target_domain} inurl:.env",
		"site:{target_domain} inurl:credentials",
		"site:{target_domain} inurl:connectionstrings",
		"site:{target_domain} inurl:secret_key",
		"site:{target_domain} inurl:api_key",
		"site:{target_domain} inurl:client_secret",
		"site:{target_domain} inurl:auth_key",
		"site:{target_domain} inurl:access_key",
		"site:{target_domain} inurl:backup",
		"site:{target_domain} inurl:dump",
		"site:{target_domain} inurl:logs",
		"site:{target_domain} inurl:conf",
		"site:{target_domain} inurl:db",
		"site:{target_domain} inurl:sql",
		"site:{target_domain} inurl:root",
		"site:{target_domain} inurl:confidential",
		"site:{target_domain} inurl:database",
		"site:{target_domain} inurl:passed",
	}

	// Prompt for target domain
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter your target domain (e.g., example.com): ")
	targetDomain, _ := reader.ReadString('\n')
	targetDomain = strings.TrimSpace(targetDomain)

	// Loop through each 3 dorking queries
	for i := 0; i < len(queries); i += 3 {
		// Prompt for confirmation before running the next 3 commands
		fmt.Print("Press [Enter] to run the next 3 commands (or type 'quit' to exit): ")
		choice, _ := reader.ReadString('\n')
		choice = strings.TrimSpace(choice)
		if choice == "quit" {
			fmt.Println("Exiting...")
			break
		}

		// Extract 3 queries to run
		end := i + 3
		if end > len(queries) {
			end = len(queries)
		}
		queriesToRun := queries[i:end]

		// Perform dorking for the target domain
		PerformDorking(targetDomain, queriesToRun)
	}
}
