require 'net/http'
require 'colorize'
require 'uri'

# Define the list of security headers to check
SECURITY_HEADERS = [
  'X-Frame-Options',
  'X-XSS-Protection',
  'Content-Security-Policy',
  'Strict-Transport-Security',
  'X-Content-Type-Options'
].freeze

# Function to check a single security header
def check_header(url, header_name)
  uri = URI.parse(url)
  begin
    response = Net::HTTP.get_response(uri)
    headers = response.to_hash
    if headers.key?(header_name)
      { header_name => headers[header_name][0] }
    else
      { header_name => 'Missing' }
    end
  rescue StandardError => e
    puts "Error occurred while checking #{header_name}: #{e.message}".colorize(:red)
    { header_name => 'Error' }
  end
end

# Function to test security headers for a given URL
def test_security_headers(url)
  puts "Testing Security Headers for #{url}".colorize(:cyan)
  puts "----------------------------------".colorize(:cyan)

  results = {}
  SECURITY_HEADERS.each do |header|
    results.merge!(check_header(url, header))
  end

  # Display the results
  results.each do |header, value|
    if value == 'Missing' || value == 'Error'
      puts "#{header}: #{value}".colorize(:red)
    else
      puts "#{header}: #{value}".colorize(:green)
    end
  end
end

# Function to confirm vulnerability based on the absence of security headers
def confirm_vulnerability(url)
  puts "Confirming Vulnerability for #{url}".colorize(:cyan)
  puts "----------------------------------".colorize(:cyan)

  misconfigurations = {
    'X-Frame-Options' => 'DENY',
    'X-XSS-Protection' => '1; mode=block',
    'Content-Security-Policy' => "default-src 'self'",
    'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains',
    'X-Content-Type-Options' => 'nosniff'
  }

  missing_headers = []
  misconfigurations.each do |header, expected_value|
    header_value = check_header(url, header)[header]
    if header_value == 'Missing' || header_value != expected_value
      missing_headers << header
    end
  end

  # Display vulnerability status
  if missing_headers.empty?
    puts "Website is not vulnerable.".colorize(:green)
  else
    puts "Website is vulnerable. Missing/misconfigured headers: #{missing_headers.join(', ')}".colorize(:red)
  end
end

# Main function
def main
  puts "Enter your target website URL: ".colorize(:yellow)
  target_url = gets.chomp.strip
  test_security_headers(target_url)
  confirm_vulnerability(target_url)
end

# Execute the program
main
