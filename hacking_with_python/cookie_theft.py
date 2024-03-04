import requests
from colorama import init, Fore

# Initialize colorama for colored output
init(autoreset=True)

def test_cookie_theft_vulnerability(target_url):
    try:
        # Set headers to mimic a browser request
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
        }

        # Send a GET request to the target website with custom headers
        response = requests.get(target_url, headers=headers, allow_redirects=True)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print(f"{Fore.GREEN}[+] Successfully accessed the website: {target_url}")
            
            # Check if the server returned any cookies
            if response.cookies:
                print(f"{Fore.GREEN}[+] Cookies received from the server:")
                for cookie in response.cookies:
                    print(f"\t{Fore.YELLOW}Name: {cookie.name}, Value: {cookie.value}")
            else:
                print(f"{Fore.RED}[-] No cookies received from the server.")
        else:
            print(f"{Fore.RED}[-] Failed to access the website: {target_url}. Status Code: {response.status_code}")

    except requests.exceptions.RequestException as e:
        print(f"{Fore.RED}[-] An error occurred: {str(e)}")


if __name__ == "__main__":
    print(f"{Fore.BLUE}[*] Welcome to Cookie Theft Vulnerability Tester")

    # Prompt user for the target website URL
    target_url = input(f"{Fore.BLUE}[*] Enter your target website URL: ")

    # Test the vulnerability
    test_cookie_theft_vulnerability(target_url)
