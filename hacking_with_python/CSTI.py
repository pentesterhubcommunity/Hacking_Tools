import requests
from bs4 import BeautifulSoup
from termcolor import colored

# Function to check if the target website is vulnerable to CSTI
def check_csti_vulnerability(url):
    try:
        # Send a GET request to the target website
        response = requests.get(url)

        # Parse HTML content using BeautifulSoup
        soup = BeautifulSoup(response.text, 'html.parser')

        # Check for potential indicators of CSTI vulnerability
        if "{{" in soup.text and "}}" in soup.text:
            return True
        else:
            return False
    except Exception as e:
        print(colored("Error occurred while checking vulnerability:", 'red'), e)
        return False

# Function to provide guidance on testing the CSTI vulnerability
def test_csti_vulnerability():
    print(colored("\nTesting for Client-Side Template Injection vulnerability...\n", 'blue'))
    print("1. Look for input fields where user-supplied data is rendered.")
    print("2. Inject template code like {{7*7}} and observe if it gets evaluated.")
    print("3. Check for any unexpected behavior or responses indicating successful injection.")
    print("\nFor example, try injecting {{7*7}} in a search box and see if the result is 49.\n")

# Main function
def main():
    print(colored("Welcome to Client-Side Template Injection Vulnerability Tester\n", 'green'))
    target_url = input(colored("Enter your target website URL: ", 'cyan'))

    print(colored("\nChecking if the target website is vulnerable...\n", 'blue'))
    if check_csti_vulnerability(target_url):
        print(colored("The target website is potentially vulnerable to Client-Side Template Injection.", 'yellow'))
        test_csti_vulnerability()
    else:
        print(colored("The target website is not vulnerable to Client-Side Template Injection.", 'green'))

if __name__ == "__main__":
    main()
