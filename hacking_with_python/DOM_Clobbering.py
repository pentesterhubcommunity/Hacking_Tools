import requests
from bs4 import BeautifulSoup
import re

# Function to test for DOM Clobbering vulnerability
def test_dom_clobbering(url):
    print("\nTesting for DOM Clobbering vulnerability on:", url)
    
    # Step 1: Fetch the HTML content of the webpage
    print("\nFetching webpage content...")
    response = requests.get(url)
    if response.status_code != 200:
        print("Error: Unable to fetch webpage content. Status code:", response.status_code)
        return
    
    html_content = response.text
    
    # Step 2: Extract all script tags from the HTML content
    print("\nExtracting script tags from the HTML content...")
    soup = BeautifulSoup(html_content, 'html.parser')
    script_tags = soup.find_all('script')
    
    # Step 3: Check if any script tag contains suspicious patterns indicating potential DOM Clobbering
    vulnerable = False
    for script_tag in script_tags:
        script_content = str(script_tag)
        if re.search(r'var\s+[a-zA-Z_][a-zA-Z0-9_]*\s*=\s*document', script_content):
            vulnerable = True
            print("\nPotential DOM Clobbering found in the following script tag:")
            print(script_content)
    
    # Step 4: Display vulnerability status and testing instructions
    if vulnerable:
        print("\nThe target website is potentially vulnerable to DOM Clobbering.")
        print("\nTo test this vulnerability, you can inject a script that clobbers existing DOM elements,")
        print("such as:")
        print("\n<script>")
        print("var element = document.getElementById('element_id');")
        print("element.innerHTML = 'Hacked!';")
        print("</script>")
    else:
        print("\nThe target website is not vulnerable to DOM Clobbering.")

# Main function to execute the program
def main():
    print("\033[95m") # Magenta color for better visibility
    
    # Input target website URL
    target_website = input("Enter your target website URL: ")
    
    # Test for DOM Clobbering vulnerability
    test_dom_clobbering(target_website)

if __name__ == "__main__":
    main()
