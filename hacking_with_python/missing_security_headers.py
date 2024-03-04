import requests
import concurrent.futures
from termcolor import colored

# Define the list of security headers to check
headers_to_check = ['X-Content-Type-Options', 'X-Frame-Options', 'X-XSS-Protection', 'Content-Security-Policy']

def test_security_headers(url):
    results = {'url': url, 'missing_headers': []}
    
    try:
        response = requests.get(url, timeout=5)  # Set a timeout for the HTTP request
        
        if response.status_code == 200:
            print(f"Testing {url}...")
            for header in headers_to_check:
                if header not in response.headers:
                    results['missing_headers'].append(header)
            return results
        else:
            print(f"Failed to retrieve {url}: Status code {response.status_code}")
            return None
    
    except Exception as e:
        print(f"Error while testing {url}: {e}")
        return None

def print_results(results):
    if results:
        print("\n" + "=" * 50)
        print(f"Results for {results['url']}:\n")
        if results['missing_headers']:
            print(colored("Missing Security Headers:", "red"))
            for header in results['missing_headers']:
                print(colored(f"- {header}", "red"))
            print("\nVulnerability Exploitation:")
            print("Attackers could exploit this vulnerability to perform various attacks such as clickjacking, XSS, etc.")
        else:
            print(colored("All Security Headers Found!", "green"))
            print("The website is protected against the Missing Security Headers vulnerability.")
        print("=" * 50 + "\n")

if __name__ == "__main__":
    target_url = input("Enter your target website URL: ")
    
    with concurrent.futures.ThreadPoolExecutor() as executor:
        future_results = [executor.submit(test_security_headers, target_url) for _ in range(5)]  # Send 5 concurrent requests
    
        for future in concurrent.futures.as_completed(future_results):
            print_results(future.result())
