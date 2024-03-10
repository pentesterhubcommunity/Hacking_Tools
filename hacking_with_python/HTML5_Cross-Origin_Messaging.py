import requests
from bs4 import BeautifulSoup
from termcolor import colored

def test_html5_cors(target_url):
    print(colored("[*] Testing HTML5 Cross-Origin Messaging for: " + target_url, "blue"))

    # Send a GET request to the target URL
    try:
        response = requests.get(target_url)
        if response.status_code != 200:
            print(colored("[!] Error: Unable to access the target website.", "red"))
            return
    except requests.RequestException as e:
        print(colored("[!] Error: Unable to connect to the target website.", "red"))
        print(e)
        return

    # Parse the HTML content
    soup = BeautifulSoup(response.text, 'html.parser')
    iframe_tags = soup.find_all('iframe')

    # Check if any iframe tags with 'sandbox' attribute found
    vulnerable = False
    for tag in iframe_tags:
        if tag.get('sandbox'):
            print(colored("[!] Vulnerability Found: Cross-Origin Messaging may be enabled.", "red"))
            vulnerable = True
            break

    if not vulnerable:
        print(colored("[*] Target is not vulnerable to HTML5 Cross-Origin Messaging.", "green"))
        return

    print(colored("[*] How to Test the Vulnerability:", "blue"))
    print(colored("1. Create an HTML file with a message and host it on a different domain.", "yellow"))
    print(colored("2. Include this HTML file in an iframe on the target website.", "yellow"))
    print(colored("3. Use JavaScript to listen for messages from the iframe.", "yellow"))
    print(colored("4. If you receive messages from the iframe, the website is vulnerable.", "yellow"))

if __name__ == "__main__":
    target_website = input(colored("Enter your target website url: ", "blue"))
    test_html5_cors(target_website)
