#!/bin/bash

# Define colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a URL is reachable
check_url() {
    local url="$1"
    if curl --output /dev/null --silent --head --fail "$url"; then
        echo -e "${GREEN}[*] Website is reachable.${NC}"
    else
        echo -e "${RED}[!] Website is unreachable.${NC}"
        exit 1
    fi
}

# Function to test for unprotected API endpoints
test_vulnerability() {
    local target_url="$1"
    echo -e "${YELLOW}[+] Testing for Unprotected API Endpoints vulnerability...${NC}"
    
    # Example API endpoints to test (modify as needed)
    endpoints=(
        "api/v1/users" 
        "api/v1/data" 
        "api/v1/admin" 
        "api/v1/debug" 
        "api/v1/orders" 
        "api/v1/products" 
        "api/v1/customers" 
        "api/v1/payments" 
        "api/v1/transactions" 
        "api/v1/settings" 
        "api/v1/invoices" 
        "api/v1/reports" 
        "api/v1/logs" 
        "api/v1/notifications"
        "api/v1/feedback"
        "api/v1/stats"
        "api/v1/analytics"
        "api/v1/notifications"
        "api/v1/alerts"
        "api/v1/documents"
        "api/v1/media"
        "api/v1/sales"
        "api/v1/shipping"
        "api/v1/cart"
        "api/v1/subscriptions"
        "api/v1/locations"
        "api/v1/contacts"
        "api/v1/employees"
        "api/v1/inventory"
        "api/v1/suppliers"
        "api/v1/expenses"
        "api/v1/payroll"
        "api/v1/calendar"
        "api/v1/tasks"
        "api/v1/projects"
        "api/v1/notes"
        "api/v1/forums"
        "api/v1/posts"
        "api/v1/comments"
        "api/v1/likes"
        "api/v1/messages"
        "api/v1/notifications"
        "api/v1/events"
        "api/v1/reservations"
        "api/v1/announcements"
        "api/v1/reviews"
        # Add more endpoints as needed
    )

    # Loop through each endpoint and check if it's accessible
    for endpoint in "${endpoints[@]}"; do
        full_url="$target_url/$endpoint"
        echo -e "${YELLOW}[*] Testing $full_url...${NC}"
        response=$(curl -sL -w "%{http_code}\\n" "$full_url" -o /dev/null)
        http_code=$(echo "$response" | awk '{print $NF}')

        # Check if the response is in the 2xx range
        if [[ "$http_code" =~ ^2 ]]; then
            echo -e "${RED}[!] Potential vulnerability found: $full_url${NC}"
            echo -e "${YELLOW}[+] Exploitation${NC}"
            # Add your exploitation code here
        elif [[ "$http_code" =~ ^4 ]]; then
            echo -e "${YELLOW}[!] Possible client error for $full_url. Further investigation may be needed.${NC}"
        elif [[ "$http_code" =~ ^5 ]]; then
            echo -e "${YELLOW}[!] Possible server error for $full_url. Further investigation may be needed.${NC}"
        else
            echo -e "${GREEN}[*] $full_url is not vulnerable.${NC}"
        fi
    done
}

# Main function
main() {
    echo -e "${YELLOW}[*] Enter your target website URL: ${NC}"
    read target_url

    check_url "$target_url"
    test_vulnerability "$target_url"
}

# Execute the script
main
