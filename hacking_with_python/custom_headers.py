import requests
from bs4 import BeautifulSoup
from colorama import init, Fore

init(autoreset=True)

def test_custom_header_vulnerability(target_url, headers):
    print(f"{Fore.YELLOW}Testing Custom Header Vulnerability for: {target_url}")

    response = requests.get(target_url, headers=headers)
    soup = BeautifulSoup(response.content, 'html.parser')

    if response.headers:
        print(f"{Fore.GREEN}The target website is vulnerable to Custom Header Vulnerabilities!")
        print(f"{Fore.GREEN}To exploit this vulnerability, send a request with a custom header.")
    else:
        print(f"{Fore.RED}The target website is not vulnerable to Custom Header Vulnerabilities.")

    print(f"{Fore.YELLOW}Response Headers:")
    for header, value in response.headers.items():
        print(f"{Fore.CYAN}{header}: {value}")

if __name__ == "__main__":
    target_website = input(f"{Fore.YELLOW}Enter your target website URL: ")

    malicious_headers = {
        "X-XSS-Protection": "1; mode=block",
        "X-Content-Type-Options": "nosniff",
        "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
        "Content-Security-Policy": "default-src 'self'",
        "X-Frame-Options": "DENY"
    }

    print(f"{Fore.YELLOW}Choose a predefined malicious header or add a new custom header:")
    print(f"{Fore.YELLOW}Predefined Malicious Headers:")
    for index, (header, value) in enumerate(malicious_headers.items()):
        print(f"{Fore.CYAN}{index+1}. {header}: {value}")

    print(f"{Fore.YELLOW}Custom Header Options:")
    print(f"{Fore.CYAN}6. Add a new custom header")

    choice = input(f"{Fore.YELLOW}Enter your choice (1-6): ")

    if choice.isdigit() and 1 <= int(choice) <= 6:
        if int(choice) == 6:
            custom_header = input(f"{Fore.YELLOW}Enter custom header name: ")
            custom_value = input(f"{Fore.YELLOW}Enter custom header value: ")
            headers = {custom_header: custom_value}
        else:
            index = int(choice) - 1
            headers = {list(malicious_headers.keys())[index]: list(malicious_headers.values())[index]}
    else:
        print(f"{Fore.RED}Invalid choice! Exiting...")
        exit()

    test_custom_header_vulnerability(target_website, headers)
