import requests
from bs4 import BeautifulSoup
from colorama import Fore, Style

def check_session_hijacking_vulnerability(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
    except requests.RequestException as e:
        print(Fore.RED + f"Error: {e}")
        return

    soup = BeautifulSoup(response.text, 'html.parser')
    session_info = extract_session_info(soup)

    print(Fore.GREEN + "Session Information:")
    print(Style.RESET_ALL)
    print(session_info)

    if is_session_hijackable(session_info):
        print(Fore.RED + "Potential Session Hijacking Vulnerability Detected!")
        print(Fore.YELLOW + "Consider implementing stronger session management techniques.")
    else:
        print(Fore.GREEN + "No Session Hijacking Vulnerability Detected.")

def extract_session_info(soup):
    session_info = {
        'cookies': soup.cookies,
        'hidden_fields': soup.find_all('input', type='hidden'),
        # Add more session information extraction here if needed
    }
    return session_info

def is_session_hijackable(session_info):
    # Example check: if cookies are not secure, consider it a vulnerability
    for cookie in session_info['cookies']:
        if not cookie.secure:
            return True
    return False

if __name__ == "__main__":
    from colorama import init
    init(autoreset=True)

    print(Fore.YELLOW + "Session Hijacking Vulnerability Checker")
    print(Style.RESET_ALL)
    target_url = input("Enter your target website URL: ")
    check_session_hijacking_vulnerability(target_url)
