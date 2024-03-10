import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
from termcolor import colored

def find_debug_endpoints(url):
    print(colored("[*] Discovering potential debug endpoints on:", "cyan"), colored(url, "blue"))
    debug_endpoints = []

    try:
        response = requests.get(url)
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, "html.parser")
            links = soup.find_all("a", href=True)
            for link in links:
                href = link["href"]
                if any(keyword in href.lower() for keyword in ["debug", "test", "admin", "dev", "trace", "info", "logs", "log", "debugger", "monitor", "diagnose", "inspect", "console", "audit", "status", "check", "health", "metrics"]):
                    debug_endpoints.append(href)

            return debug_endpoints

    except Exception as e:
        print(colored("[!] Error:", "red"), e)

def test_vulnerability(debug_endpoints):
    if debug_endpoints:
        print(colored("[+] Potential debug endpoints found:", "green"))
        for endpoint in debug_endpoints:
            print(colored("[+] ", "green"), endpoint)
        print(colored("[*] The website may be vulnerable.", "yellow"))
        print(colored("[*] To test the vulnerability, try accessing these endpoints and observe the response.", "yellow"))
    else:
        print(colored("[*] No potential debug endpoints found.", "green"))
        print(colored("[*] The website seems not to be vulnerable.", "yellow"))

def main():
    target_website = input(colored("Enter your target website url: ", "cyan"))
    debug_endpoints = find_debug_endpoints(target_website)
    test_vulnerability(debug_endpoints)

if __name__ == "__main__":
    main()
