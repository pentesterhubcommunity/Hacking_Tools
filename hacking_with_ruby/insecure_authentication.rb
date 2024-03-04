require 'net/http'
require 'colorize'

def test_insecure_authentication_vulnerability(url)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri.scheme == 'https'

  request = Net::HTTP::Get.new(uri.request_uri)
  
  begin
    response = http.request(request)
  
    if response.code == '200'
      puts "Insecure Authentication Vulnerability Detected!".colorize(:red)
      puts "The website is using HTTP Basic Authentication without encryption.".colorize(:red)
      puts "This can lead to credentials being transmitted over the network in plaintext.".colorize(:red)
      puts "To verify manually, try accessing the URL without HTTPS (e.g., http://#{uri.host}:#{uri.port}) and check if authentication is required.".colorize(:yellow)
    else
      puts "No Insecure Authentication Vulnerability Detected.".colorize(:green)
    end
  rescue StandardError => e
    puts "An error occurred while testing the vulnerability: #{e.message}".colorize(:yellow)
    puts "Please ensure that the target URL is accessible and try again.".colorize(:yellow)
  end
end

puts "Enter your target website URL: "
target_url = gets.chomp

test_insecure_authentication_vulnerability(target_url)
