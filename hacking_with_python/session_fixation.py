import requests
from colorama import Fore, Style

def test_session_fixation_vulnerability(target_url):
    session = requests.Session()
    response = session.get(target_url)
    
    # Displaying the response status code
    print(f"\n{Fore.YELLOW}Response Status Code:{Style.RESET_ALL} {response.status_code}")
    
    # Displaying the Set-Cookie header in the response
    print(f"{Fore.YELLOW}Set-Cookie Header:{Style.RESET_ALL} {response.headers.get('Set-Cookie')}")

    # Prompting user to check for any session IDs present in the Set-Cookie header
    print(f"\n{Fore.GREEN}Now, check if the website's response contains any session IDs in the Set-Cookie header.{Style.RESET_ALL}")
    print(f"{Fore.GREEN}If you find a session ID being set before authentication, it indicates a potential Session Fixation vulnerability.{Style.RESET_ALL}")

if __name__ == "__main__":
    from colorama import init
    init(autoreset=True)
    
    print(f"{Fore.CYAN}Python Session Fixation Vulnerability Tester{Style.RESET_ALL}")
    
    # Asking user for the target website URL
    target_url = input("\nEnter your target website URL: ")
    
    # Testing the session fixation vulnerability
    test_session_fixation_vulnerability(target_url)
