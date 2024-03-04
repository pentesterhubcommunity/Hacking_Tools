import requests
from bs4 import BeautifulSoup
from termcolor import colored
import threading

def test_unencrypted_data_storage(url):
    try:
        response = requests.get(url, headers={'User-Agent': 'Mozilla/5.0'})
        if response.status_code == 200:
            soup = BeautifulSoup(response.content, 'html.parser')
            # Search for potential areas where unencrypted data might be stored
            potential_areas = []
            # Look for input fields
            input_fields = soup.find_all('input')
            if input_fields:
                potential_areas.extend(input_fields)
            # Add more potential areas here (e.g., forms, URLs with sensitive information)
            if potential_areas:
                print(colored("[+] Potential unencrypted data storage found on the website:", 'green'))
                for area in potential_areas:
                    print(colored("  - Found in:", 'yellow'), area)
                explore_further = input(colored("Do you want to explore further? (Y/N): ", 'cyan')).strip().lower()
                if explore_further == 'y':
                    # Implement further exploration here
                    pass
            else:
                print(colored("[-] No potential unencrypted data storage found on the website.", 'red'))
        else:
            print(colored("[-] Failed to retrieve content from the website.", 'red'))
    except Exception as e:
        print(colored("[-] An error occurred:", 'red'), e)

if __name__ == "__main__":
    print(colored("Unencrypted Data Storage Vulnerability Tester", 'blue'))
    print(colored("This program will test a given website for potential unencrypted data storage vulnerabilities.", 'blue'))
    target_website = input(colored("Enter your target website URL: ", 'cyan'))
    print(colored(f"Testing {target_website} for unencrypted data storage vulnerability...", 'cyan'))
    test_unencrypted_data_storage(target_website)
