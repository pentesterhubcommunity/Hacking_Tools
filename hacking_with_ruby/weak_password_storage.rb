require 'net/http'
require 'uri'
require 'colorize'

# Function to check if the website uses secure HTTPS protocol
def uses_https?(url)
  uri = URI.parse(url)
  uri.scheme == "https"
end

# Function to check for password input fields in the HTML response
def check_password_fields(response)
  response.include?('type="password"') || response.include?('type=\'password\'')
end

# Function to check for password hashing algorithms commonly used for secure storage
def uses_secure_hashing?(response)
  secure_hashing_algorithms = ['bcrypt', 'scrypt', 'PBKDF2', 'Argon2']
  secure_hashing_algorithms.any? { |algorithm| response.include?(algorithm) }
end

# Function to check for weak password storage vulnerability
def check_weak_password_storage(url)
  begin
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    if response.code.to_i == 200
      body = response.body

      if check_password_fields(body)
        puts "Potential indications of weak password storage vulnerability detected:".colorize(:red)
        puts "1. The website contains password input fields in the HTML.".colorize(:yellow)
      else
        puts "No password input fields detected in the HTML.".colorize(:green)
      end

      if !uses_https?(url)
        puts "2. The website does not use HTTPS, which may indicate insecure transmission of passwords.".colorize(:red)
      else
        puts "The website uses HTTPS for secure transmission.".colorize(:green)
      end

      if !uses_secure_hashing?(body)
        puts "3. No indications of secure password hashing algorithms found in the response.".colorize(:red)
      else
        puts "Indications of secure password hashing algorithms found.".colorize(:green)
      end

      puts "To further test this vulnerability, consider:".colorize(:yellow)
      puts "- Checking the website's password reset functionality for secure practices."
      puts "- Analyzing the server-side code or using tools like OWASP ZAP for deeper inspection."
    else
      puts "Error: Unable to fetch URL. Response code: #{response.code}".colorize(:red)
    end
  rescue Exception => e
    puts "Error: #{e.message}".colorize(:red)
  end
end

puts "Enter your target website URL: "
target_url = gets.chomp

check_weak_password_storage(target_url)
