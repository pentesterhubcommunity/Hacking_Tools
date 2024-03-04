import requests
from colorama import init, Fore, Style

# Initialize colorama to enable colored output on Windows
init()

def test_insecure_authentication_vulnerability(target_url):
    print(Fore.YELLOW + "Testing for Insecure Authentication vulnerability on:", target_url)
    try:
        # Sending a GET request without authentication
        response = requests.get(target_url)
        
        # Checking the status code for unauthorized access (401)
        if response.status_code == 401:
            print(Fore.RED + "Insecure Authentication vulnerability found!")
            print(Fore.GREEN + "Details:")
            print("The server responded with a 401 Unauthorized status code, indicating that access is restricted.")
            print("This vulnerability allows unauthorized users to access restricted pages or endpoints without proper authentication.")
            print(Fore.GREEN + "Recommendations:")
            print("1. Implement proper authentication mechanisms such as username/password or token-based authentication.")
            print("2. Ensure that all sensitive resources are protected and require valid authentication credentials.")
            print("3. Regularly audit and review access controls to identify and mitigate potential vulnerabilities.")
        else:
            print(Fore.GREEN + "No Insecure Authentication vulnerability found.")
    except requests.exceptions.RequestException as e:
        print(Fore.RED + "Error occurred:", e)

if __name__ == "__main__":
    # Asking for the target website URL
    target_url = input(Fore.CYAN + "Enter your target website url: ")

    # Testing for Insecure Authentication vulnerability
    test_insecure_authentication_vulnerability(target_url)
