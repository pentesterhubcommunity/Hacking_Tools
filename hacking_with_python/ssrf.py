import requests

def test_ssrf_vulnerability(url):
    try:
        response = requests.get(url)
        if response.status_code == 200:
            print("SSRF Vulnerability Found: Accessible URL -", url)
        else:
            print("URL is not accessible or SSRF Vulnerability not present.")
    except Exception as e:
        print("Error occurred:", str(e))

if __name__ == "__main__":
    target_website = input("Enter your target website link: ")
    test_ssrf_vulnerability(target_website)
