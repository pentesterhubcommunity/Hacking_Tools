import requests
from bs4 import BeautifulSoup, Comment
import re
import sys

# Color codes for formatting output
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def check_information_disclosure(target_url):
    try:
        print(f"{bcolors.OKBLUE}[*] Testing for Information Disclosure vulnerability on {target_url}...{bcolors.ENDC}")
        
        # Send request to the target website with timeout
        response = requests.get(target_url, timeout=10)

        if response.status_code == 200:
            print(f"{bcolors.OKGREEN}[+] Target website is reachable...{bcolors.ENDC}")
            soup = BeautifulSoup(response.text, 'html.parser')

            # Additional keywords for sensitive information
            sensitive_info_keywords = [
                'password', 'username', 'email', 'credit card', 'api key', 'secret',
                'security question', 'social security number', 'phone number', 'address',
                'birthdate', 'passport number', 'bank account', 'access token'
            ]

            # Regular expression pattern
            pattern = '|'.join(sensitive_info_keywords)

            # Check for sensitive information in the response body
            sensitive_info = re.finditer(pattern, response.text, re.IGNORECASE)
            if sensitive_info:
                print(f"{bcolors.FAIL}[!] Possible sensitive information found in the response body:{bcolors.ENDC}")
                for match in sensitive_info:
                    start = max(0, match.start() - 50)
                    end = min(len(response.text), match.end() + 50)
                    print(f"{bcolors.FAIL}  - {match.group()} (Found in context: {response.text[start:end]}){bcolors.ENDC}")

            # Check for sensitive information in HTML comments
            html_comments = soup.find_all(string=lambda text: isinstance(text, Comment))
            for comment in html_comments:
                sensitive_info = re.finditer(pattern, comment, re.IGNORECASE)
                if sensitive_info:
                    print(f"{bcolors.FAIL}[!] Possible sensitive information found in HTML comments:{bcolors.ENDC}")
                    for match in sensitive_info:
                        start = max(0, match.start() - 50)
                        end = min(len(comment), match.end() + 50)
                        print(f"{bcolors.FAIL}  - {match.group()} (Found in context: {comment[start:end]}){bcolors.ENDC}")

            # Check for sensitive information in meta tags
            meta_tags = soup.find_all('meta')
            for meta in meta_tags:
                if meta.get('name') and meta.get('content'):
                    sensitive_info = re.finditer(pattern, meta.get('content'), re.IGNORECASE)
                    if sensitive_info:
                        print(f"{bcolors.FAIL}[!] Possible sensitive information found in meta tags:{bcolors.ENDC}")
                        for match in sensitive_info:
                            start = max(0, match.start() - 50)
                            end = min(len(meta.get('content')), match.end() + 50)
                            print(f"{bcolors.FAIL}  - {match.group()} (Found in context: {meta.get('content')[start:end]}){bcolors.ENDC}")
        else:
            print(f"{bcolors.WARNING}[!] Target website is not reachable, status code: {response.status_code}{bcolors.ENDC}")

    except requests.exceptions.Timeout:
        print(f"{bcolors.WARNING}[!] Request timed out. The target website may be unresponsive.{bcolors.ENDC}")
    except Exception as e:
        print(f"{bcolors.FAIL}[!] Error occurred: {e}{bcolors.ENDC}")

def main():
    target_url = input(f"{bcolors.HEADER}Enter your target website url: {bcolors.ENDC}")

    # Check for Information Disclosure vulnerability
    check_information_disclosure(target_url)

if __name__ == "__main__":
    main()
