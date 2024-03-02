package main

import (
    "bufio"
    "context"
    "fmt"
    "net"
    "os"
    "strings"
    "sync"
    "time"
)

func main() {
    // Prompt the user to enter the target domain
    fmt.Print("Enter your target domain: ")
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Scan()
    domain := scanner.Text()

    // List of common subdomains to check
    subdomains := []string{
        "www",
        "mail",
        "ftp",
        "blog",
        "api",
        "admin",
        "test",
        "dev",
        "demo",
        "shop",
        "forum",
        "store",
        "m",
        "cdn",
        "secure",
        "support",
        "app",
        "portal",
        "download",
        "vpn",
        "status",
        "crm",
        "billing",
        "chat",
        "assets",
        "wiki",
        "help",
        "forum",
        "news",
        "media",
        "images",
        "docs",
        "auth",
        "backup",
        "calendar",
        "webmail",
        "files",
        "stats",
        "tracker",
        "blog",
        "jobs",
        "partners",
        "newsletter",
        "investors",
        "test",
        "staging",
        "demo",
        "labs",
        "events",
        "partners",
        "members",
        "download",
        "secure",
        "subscribe",
        "blog",
        "login",
        "register",
        "about",
        "contact",
        "faq",
        "terms",
        "media",
        "sitemap",
        "services",
        "api",
        // Additional subdomains
        "forum",
        "community",
        "app",
        "account",
        "panel",
        "gateway",
        "info",
        "host",
        "market",
        "search",
        "support",
        "register",
        "login",
        "chat",
        // More subdomains
        "store",
        "forum",
        "portal",
        "live",
        "jobs",
        "blog",
        "web",
        "finance",
        "music",
        "forum",
        "game",
        // Add more subdomains as needed
    }

    var wg sync.WaitGroup
    for _, subdomain := range subdomains {
        wg.Add(1)
        go func(sd string) {
            defer wg.Done()
            target := fmt.Sprintf("%s.%s", sd, domain)
            addresses, err := lookupWithTimeout(target, 2*time.Second) // Adjust timeout as needed
            if err != nil {
                // Uncomment the next line to print errors for not found subdomains
                // fmt.Printf("Subdomain %s not found: %s\n", target, err)
                return
            }
            fmt.Printf("Subdomain %s found. Addresses: %v\n", target, addresses)
        }(subdomain)
    }

    wg.Wait()
}

func lookupWithTimeout(domain string, timeout time.Duration) ([]string, error) {
    // Create a context with timeout
    ctx, cancel := context.WithTimeout(context.Background(), timeout)
    defer cancel()

    // Create a new dialer with context
    dialer := &net.Dialer{}

    // Perform DNS resolution with the specified timeout and context
    resolver := net.Resolver{Dial: dialer.DialContext}
    addresses, err := resolver.LookupHost(ctx, domain)
    if err != nil {
        // Handle DNS lookup errors
        if strings.Contains(err.Error(), "no such host") {
            // Return a custom error message for not found hosts
            return nil, fmt.Errorf("not found")
        }
        return nil, fmt.Errorf("error looking up %s: %v", domain, err)
    }
    return addresses, nil
}
