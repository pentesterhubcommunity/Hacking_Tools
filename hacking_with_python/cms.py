import requests
from bs4 import BeautifulSoup
import re
import sys

# Function to check for CMS Information Disclosure Vulnerabilities
def check_cms_info_disclosure(target_url):
    try:
        print("\n[*] Testing for CMS Information Disclosure Vulnerabilities on:", target_url)
        
        # Fetching the website content
        response = requests.get(target_url)
        
        if response.status_code == 200:
            html_content = response.text
            
            # Parsing the HTML content
            soup = BeautifulSoup(html_content, 'html.parser')
            
            # Finding meta generator tag
            meta_generator = soup.find('meta', {'name': re.compile(r'generator', re.I)})
            
            if meta_generator:
                print("\n[*] Found meta generator tag:")
                print(meta_generator)
                print("\n[!] The website may be disclosing CMS information.")
                print("\n[*] To test this vulnerability, try accessing the following URLs:")
                print("\n[1] /wp-admin")
                print("[2] /administrator")
                print("[3] /admin")
                print("[4] /wp-login.php")
                print("[5] /wp-admin/install.php")
            else:
                print("\n[*] No meta generator tag found. The website does not seem to disclose CMS information.")
        else:
            print("\n[!] Failed to retrieve website content. Status Code:", response.status_code)
    except Exception as e:
        print("\n[!] An error occurred:", str(e))

# Function to run the program
def run():
    print("\033[1m" + "\033[93m" + "\nCMS Information Disclosure Vulnerability Tester\n" + "\033[0m")
    target_url = input("\nEnter your target website url: ")
    check_cms_info_disclosure(target_url)

# Main function
if __name__ == "__main__":
    run()
