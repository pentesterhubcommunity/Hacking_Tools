import requests
from concurrent.futures import ThreadPoolExecutor
from urllib.parse import urljoin

def fetch_url(url):
    try:
        response = requests.get(url, allow_redirects=True)
        response.raise_for_status()
        return response
    except requests.exceptions.RequestException as e:
        return None, e

def test_sensitive_data_exposure(url):
    try:
        responses = []
        with ThreadPoolExecutor(max_workers=10) as executor:
            urls_to_fetch = [url, urljoin(url, '/login'), urljoin(url, '/admin')]
            futures = [executor.submit(fetch_url, url) for url in urls_to_fetch]
            for future in futures:
                response, error = future.result()
                if error:
                    print(f"Error fetching {response.url}: {error}")
                else:
                    responses.append(response)

        # Check for common sensitive data in response content
        sensitive_data_keywords = ['password', 'credit card', 'social security number', 'ssn', 'pii']
        for response in responses:
            if not response:
                continue
            content_type = response.headers.get('Content-Type', '')
            if 'text/html' not in content_type:
                print(f"Skipping non-HTML content: {response.url}")
                continue
            
            for keyword in sensitive_data_keywords:
                if keyword.lower() in response.text.lower():
                    print(f"Potential sensitive data exposed at {response.url}: {keyword}")
                    return True
        
        print("No sensitive data exposed.")
        return False
    except Exception as e:
        print(f"Error: {e}")
        return False

def main():
    website_url = input("Enter your target website URL: ").strip()
    if website_url.startswith(("http://", "https://")):
        test_sensitive_data_exposure(website_url)
    else:
        print("Invalid URL. Please make sure to include the protocol (http:// or https://)")

if __name__ == "__main__":
    main()
