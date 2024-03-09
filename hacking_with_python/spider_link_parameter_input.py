import requests
from bs4 import BeautifulSoup
import re
from urllib.parse import urljoin
from colorama import init, Fore, Style

init(autoreset=True)

def spider(url):
    print(f"{Fore.CYAN}[*] Crawling {url}")
    try:
        response = requests.get(url)
        if response.status_code == 200:
            soup = BeautifulSoup(response.content, "html.parser")
            links = soup.find_all("a", href=True)
            forms = soup.find_all("form")
            inputs = soup.find_all("input")
            scripts = soup.find_all("script", src=True)
            images = soup.find_all("img", src=True)
            files = soup.find_all(re.compile(r'(href=".*\.(css|js|png|jpg|jpeg|gif|pdf|doc|docx|xls|xlsx|ppt|pptx|zip|rar)")'))
            
            # Print collected links
            print(f"{Fore.GREEN}[+] Links:")
            for link in links:
                print(urljoin(url, link["href"]))

            # Print forms and inputs
            print(f"{Fore.GREEN}[+] Forms:")
            for form in forms:
                print(form)
            print(f"{Fore.GREEN}[+] Inputs:")
            for inp in inputs:
                print(inp)

            # Print scripts and images
            print(f"{Fore.GREEN}[+] Scripts:")
            for script in scripts:
                print(urljoin(url, script["src"]))
            print(f"{Fore.GREEN}[+] Images:")
            for image in images:
                print(urljoin(url, image["src"]))

            # Print file paths
            print(f"{Fore.GREEN}[+] Files:")
            for file in files:
                print(file["href"])

        else:
            print(f"{Fore.RED}[!] Error: {response.status_code}")
    except Exception as e:
        print(f"{Fore.RED}[!] Error: {e}")

if __name__ == "__main__":
    target_url = input(f"{Fore.YELLOW}Enter your target website url: ")
    spider(target_url)
