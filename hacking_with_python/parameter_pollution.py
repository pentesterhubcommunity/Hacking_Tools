import requests
from urllib.parse import urlparse, parse_qs

def extract_parameters(url):
    # Send a GET request to the target URL
    response = requests.get(url)

    # Check if the request was successful
    if response.status_code == 200:
        # Parse the URL to extract parameters
        parsed_url = urlparse(url)
        query_parameters = parse_qs(parsed_url.query)
        return query_parameters
    else:
        print("Failed to fetch parameters from the target URL.")
        return None

def test_parameter_pollution(url, parameters):
    if parameters is None:
        print("No parameters extracted. Exiting.")
        return

    # Make a copy of the original parameters dictionary
    original_params = parameters.copy()

    # Iterate over each parameter and add a dummy value
    for param, value in original_params.items():
        # Add a dummy value to the parameter
        parameters[param] = "dummy_value"

        # Send the request with modified parameters
        response = requests.get(url, params=parameters)

        # Check if the response indicates a potential parameter pollution
        if response.status_code != 200:
            print(f"Parameter {param} might be vulnerable to pollution")

        # Restore the original value of the parameter
        parameters[param] = value

if __name__ == "__main__":
    # Ask the user for the target website URL
    target_url = input("Enter the target website URL: ")

    # Extract parameters from the target website URL
    target_parameters = extract_parameters(target_url)

    # Test for parameter pollution
    test_parameter_pollution(target_url, target_parameters)
