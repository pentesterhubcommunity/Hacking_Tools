import requests
from bs4 import BeautifulSoup
import re
import urllib.parse
import logging
from termcolor import colored
from concurrent.futures import ThreadPoolExecutor

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Set default timeout for HTTP requests (in seconds)
DEFAULT_TIMEOUT = 10

# Custom headers
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36",
    "Accept-Language": "en-US,en;q=0.9",
    "Referer": "https://www.google.com/",
}

# Proxy settings (optional)
PROXY = None  # Example: "http://user:password@proxy_ip:proxy_port"

def test_api_vulnerability(url):
    logger.info("Testing Unprotected API Endpoints vulnerability on: %s", url)

    try:
        # Fetch the webpage content
        response = requests.get(url, headers=HEADERS, timeout=DEFAULT_TIMEOUT, proxies={'http': PROXY, 'https': PROXY} if PROXY else None)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        logger.error("Failed to fetch webpage content: %s", e)
        return

    soup = BeautifulSoup(response.text, "html.parser")

    # Extract potential API endpoints from the webpage
    api_endpoints = set()
    for tag in soup.find_all(['a', 'script', 'link'], href=True):
        href = tag.get('href', '')
        if re.match(r'^https?://', href):
            api_endpoints.add(href)

    logger.info("Potential API Endpoints Found:")
    for endpoint in api_endpoints:
        logger.info("  - %s", endpoint)

    # Attempt to bypass protection systems (add your bypass techniques here)
    logger.info("Attempting to bypass protection systems...")

    # Exploit the vulnerability (add your exploitation techniques here)
    logger.info("Exploiting the vulnerability...")

if __name__ == "__main__":
    print(colored("Unprotected API Endpoints Vulnerability Tester", "blue"))
    target_website = input(colored("Enter your target website URL: ", "cyan"))

    # Multithreaded scanning
    with ThreadPoolExecutor(max_workers=10) as executor:
        executor.map(test_api_vulnerability, [target_website])
