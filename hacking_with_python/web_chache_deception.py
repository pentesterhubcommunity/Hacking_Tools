import requests
import random
import string
from colorama import Fore, Style

def generate_user_agent():
    platforms = ['Windows NT 10.0; Win64; x64', 'Macintosh; Intel Mac OS X 10_15_7', 'X11; Linux x86_64']
    browsers = ['Chrome', 'Firefox', 'Safari', 'Opera', 'Edge']
    return f"{random.choice(browsers)} ({random.choice(platforms)})"

def test_web_cache_deception(url, custom_headers=None, use_proxy=False):
    headers = {
        'Host': 'example.com',  # Replace 'example.com' with the actual hostname of the website
        'X-Original-URL': '/index.html',  # Replace '/index.html' with a valid URL on the website
        'User-Agent': generate_user_agent()
    }
    if custom_headers:
        headers.update(custom_headers)

    proxies = None
    if use_proxy:
        # Replace 'proxy_address:proxy_port' with the actual proxy address and port
        proxies = {'http': 'http://proxy_address:proxy_port', 'https': 'https://proxy_address:proxy_port'}

    try:
        response = requests.get(url, headers=headers, proxies=proxies, timeout=10, allow_redirects=True)

        # Check if the final URL matches the requested URL
        final_url = response.url
        if final_url != url:
            print(f"{Fore.YELLOW}Redirected to: {final_url}{Style.RESET_ALL}")

        # Print response headers
        print(f"\n{Fore.GREEN}Testing {final_url} for Web Cache Deception:{Style.RESET_ALL}")
        print(f"{Fore.BLUE}Response Headers:{Style.RESET_ALL}")
        for header, value in response.headers.items():
            print(f"{Fore.CYAN}{header}: {value}{Style.RESET_ALL}")

        # Check for cache deception vulnerability
        vulnerable_headers = ['X-Cache-Status', 'Vary', 'Cache-Control', 'Surrogate-Key']
        detected_vulnerabilities = [header for header in vulnerable_headers if header in response.headers]
        if detected_vulnerabilities:
            print(f"\n{Fore.RED}Warning: Web Cache Deception vulnerability detected!{Style.RESET_ALL}")
            print(f"{Fore.RED}Vulnerable Headers:{Style.RESET_ALL}", detected_vulnerabilities)
        else:
            print(f"\n{Fore.GREEN}No Web Cache Deception vulnerability detected.{Style.RESET_ALL}")
    
    except requests.RequestException as e:
        print(f"{Fore.RED}Error occurred while testing {url}: {e}{Style.RESET_ALL}")

if __name__ == "__main__":
    url = input("Enter the target website URL: ")
    use_proxy = input("Do you want to use a proxy? (y/n): ").lower() == 'y'
    custom_headers_str = input("Enter custom headers (if any), in the format 'Header1: Value1, Header2: Value2': ")
    custom_headers = dict(header.split(': ') for header in custom_headers_str.split(', ')) if custom_headers_str else None

    test_web_cache_deception(url, custom_headers, use_proxy)
