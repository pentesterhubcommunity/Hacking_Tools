import requests
from bs4 import BeautifulSoup
import re

# Function to test CSP bypass for a given URL
def test_csp_bypass(url):
    print("\033[95m[*] Testing Content Security Policy (CSP) Bypass...\033[0m")
    
    # Send a GET request to the target URL
    response = requests.get(url)
    print("\033[94m[*] Sending GET request to:", url, "\033[0m")
    
    # Parse the response HTML
    soup = BeautifulSoup(response.content, 'html.parser')
    
    # Check if CSP is present in the response headers
    if 'content-security-policy' in response.headers:
        print("\033[92m[*] Content Security Policy (CSP) found in response headers.\033[0m")
        csp_header = response.headers['content-security-policy']
        print("\033[93m[*] Content Security Policy (CSP) Header:", csp_header, "\033[0m")
        
        # Check if 'unsafe-inline' is present in CSP header
        if "'unsafe-inline'" in csp_header:
            print("\033[91m[!] Target website is potentially vulnerable to CSP bypass.\033[0m")
            
            # Extract URLs with 'unsafe-inline' from HTML content
            inline_scripts = soup.find_all('script', attrs={'src': False})
            for script in inline_scripts:
                if script.text.strip() != "":
                    print("\033[96m[*] Potentially bypassable inline script found:\033[0m", script.text.strip())
            
            # Additional checks or techniques to test CSP bypass can be added here
            
        else:
            print("\033[92m[*] Content Security Policy (CSP) does not contain 'unsafe-inline'.\033[0m")
            print("\033[92m[*] Target website is not vulnerable to CSP bypass.\033[0m")
    else:
        print("\033[91m[!] Content Security Policy (CSP) not found in response headers.\033[0m")
        print("\033[92m[*] Target website may or may not be vulnerable to CSP bypass.\033[0m")

# Main function to execute the program
def main():
    print("\033[96m[>] Content Security Policy (CSP) Bypass Tester\033[0m")
    target_url = input("\033[93m[*] Enter your target website URL: \033[0m")
    test_csp_bypass(target_url)

if __name__ == "__main__":
    main()
