require 'net/http'
require 'colorize'

def test_custom_header_vulnerability(url)
  puts "Testing for Custom Header Vulnerability on #{url}...".yellow

  uri = URI(url)
  response = Net::HTTP.get_response(uri)

  if response['X-Custom-Header']
    puts "Custom header detected: #{response['X-Custom-Header']}".green
    puts "This website may be vulnerable to Custom Header Injection!".red
    puts "To test the vulnerability, try injecting a custom header in your request."
  else
    puts "No custom header detected.".green
    puts "This website does not appear to be vulnerable to Custom Header Injection.".green
  end
end

puts "Enter your target website url: "
target_website = gets.chomp

test_custom_header_vulnerability(target_website)
