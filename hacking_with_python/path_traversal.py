import requests
from urllib.parse import urljoin
from bs4 import BeautifulSoup
import re
from termcolor import colored

def test_path_traversal(target_url):
    print(colored("[*] Testing for Path Traversal vulnerability on:", "yellow"), target_url)
    
    # Send request to the target URL
    try:
        response = requests.get(target_url)
        if response.status_code != 200:
            print(colored("[!] Error: Unable to connect to the target URL.", "red"))
            return
    except Exception as e:
        print(colored("[!] Error:", str(e), "red"))
        return
    
    print(colored("[*] Target website is accessible.", "green"))
    
    # Parse HTML content
    soup = BeautifulSoup(response.content, 'html.parser')
    
    # Extract links from HTML content
    links = soup.find_all('a', href=True)
    
    print(colored("[*] Extracting links from the target website...", "yellow"))
    
    vulnerable_links = []
    for link in links:
        href = link['href']
        absolute_link = urljoin(target_url, href)
        
        # Check if the link contains any suspicious patterns
        if re.search(r'\.\./', href):
            vulnerable_links.append(absolute_link)
    
    if len(vulnerable_links) > 0:
        print(colored("[!] Target website may be vulnerable to Path Traversal!", "red"))
        print(colored("[*] Vulnerable links found:", "red"))
        for link in vulnerable_links:
            print(colored(link, "red"))
    else:
        print(colored("[*] Target website is not vulnerable to Path Traversal.", "green"))

# Main function
if __name__ == "__main__":
    target_website = input(colored("Enter your target website URL: ", "blue"))
    test_path_traversal(target_website)
