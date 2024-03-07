import requests
import concurrent.futures
from termcolor import colored

def check_security_headers(url):
    try:
        response = requests.get(url, timeout=5)
        headers = response.headers

        print(colored(f"\n[*] Testing {url}", "cyan"))

        print(colored("\n[*] Received Headers:", "cyan"))
        for header, value in headers.items():
            print(f"{header}: {value}")

        vulnerable = False

        # List of security headers and their recommended values
        security_headers = {
            "Strict-Transport-Security": "max-age=31536000; includeSubDomains; preload",
            "X-Content-Type-Options": "nosniff",
            "X-Frame-Options": "SAMEORIGIN",
            "X-XSS-Protection": "1; mode=block",
            "Content-Security-Policy": "default-src 'self'"
        }

        # Checking for missing or misconfigured security headers
        for header, recommended_value in security_headers.items():
            if header not in headers:
                print(colored(f"\n[!] Missing security header: {header}", "red"))
                vulnerable = True
            elif headers[header] != recommended_value:
                print(colored(f"\n[!] Misconfigured security header: {header}. Recommended value: {recommended_value}", "red"))
                vulnerable = True
        
        if not vulnerable:
            print(colored("\n[+] No missing or misconfigured security headers found. The website appears to be properly configured.", "green"))
        else:
            print(colored("\n[-] The website might be vulnerable to HTTP Security Headers Misconfiguration.", "red"))
            print(colored("\n[!] Recommendations:", "yellow"))
            print("- Consider adding or updating the missing or misconfigured security headers.")
            print("- Follow security best practices to protect against common web vulnerabilities.")
            print("- Regularly review and update security configurations.")

    except requests.RequestException as e:
        print(colored(f"\n[!] Error occurred: {str(e)}", "red"))

def main():
    target_url = input("Enter your target website URL: ")
    check_security_headers(target_url)

if __name__ == "__main__":
    main()
