import requests
from termcolor import colored
import concurrent.futures

def test_cors_vulnerability(target_url):
    print(colored("[*] Testing CORS vulnerability for: " + target_url, "yellow"))

    # Send a preflight request to check CORS headers
    print(colored("[*] Sending preflight CORS request...", "yellow"))
    preflight_response = requests.options(target_url)
    print(colored("[+] Preflight request response headers:", "green"))
    print(preflight_response.headers)

    # Check if CORS headers are present and misconfigured
    if 'Access-Control-Allow-Origin' in preflight_response.headers:
        print(colored("[!] Access-Control-Allow-Origin header is present!", "red"))
        print(colored("[!] CORS vulnerability might be present!", "red"))
        print(colored("[!] Testing further for misconfiguration...", "red"))

        # Test additional misconfigurations concurrently
        with concurrent.futures.ThreadPoolExecutor() as executor:
            future = executor.submit(test_additional_cors_misconfigurations, target_url)
            future.result()
    else:
        print(colored("[+] Access-Control-Allow-Origin header is not present", "green"))
        print(colored("[*] No CORS vulnerability detected", "green"))

def test_additional_cors_misconfigurations(target_url):
    # Attempt to bypass any protection systems
    print(colored("[*] Attempting to bypass protection systems...", "yellow"))
    bypass_headers = {'Origin': 'https://evil.com'}
    bypass_response = requests.get(target_url, headers=bypass_headers)
    print(colored("[+] Bypass attempt response:", "green"))
    print(bypass_response.text)

    # Check if bypass attempt was successful
    if bypass_response.status_code == 200:
        print(colored("[!] Bypass attempt successful!", "red"))
    else:
        print(colored("[*] Bypass attempt unsuccessful", "green"))

    # Add more tests here if needed

def main():
    print(colored("=== CORS Vulnerability Tester ===", "blue"))
    target_url = input(colored("Enter your target website url: ", "blue"))
    test_cors_vulnerability(target_url)

if __name__ == "__main__":
    main()
