#!/usr/bin/env python3

import requests

def check_redirection(target_url, redirect_url):
    # Send a request with the redirection URL
    response = requests.get(target_url, allow_redirects=False)
    status_code = response.status_code
    effective_url = response.headers.get('Location')

    # Check if the response status code indicates a successful redirection
    if 300 <= status_code < 400:
        if effective_url == redirect_url:
            print("\033[0;32mVulnerable: Open Redirection exists\033[0m")
        else:
            print("\033[0;31mPotentially Vulnerable: Redirection occurred but not to the specified URL\033[0m")
    elif 200 <= status_code < 300:
        print("\033[0;31mNot Vulnerable: Redirection did not occur\033[0m")
    else:
        print("\033[0;31mNot Vulnerable: HTTP request failed with status code {}\033[0m".format(status_code))

if __name__ == "__main__":
    target_url = input("Enter your target website link: ")
    redirect_url = "https://www.bbc.com"

    check_redirection(target_url, redirect_url)
