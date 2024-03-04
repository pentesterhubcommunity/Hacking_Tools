import requests
from bs4 import BeautifulSoup
from termcolor import colored

def test_data_leakage(target_url):
    print(colored("[*] Testing for Data Leakage Vulnerability on:", "blue"), target_url)
    try:
        response = requests.get(target_url)
        if response.status_code == 200:
            soup = BeautifulSoup(response.content, "html.parser")
            sensitive_keywords = ["password", "credit card", "SSN", "social security number", "login"]
            for keyword in sensitive_keywords:
                if soup.find(text=lambda text: text and keyword.lower() in text.lower()):
                    print(colored("[!] Potential Data Leakage Detected:", "red"), f"Keyword: {keyword}")
            print(colored("[+] Data Leakage Test Complete.", "green"))
        else:
            print(colored("[!] Failed to retrieve website content.", "red"))
    except requests.RequestException as e:
        print(colored("[!] Error:", "red"), e)

def main():
    target_website = input(colored("Enter your target website url: ", "blue"))
    test_data_leakage(target_website)

if __name__ == "__main__":
    main()
