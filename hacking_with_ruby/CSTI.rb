require 'colorize'
require 'uri'
require 'net/http'

def test_csti_vulnerability(url)
  puts "Testing for Client-Side Template Injection vulnerability in #{url}...".yellow
  begin
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    if response.code == "200"
      puts "Website is accessible...".green
      puts "Checking for possible CSTI vulnerability...".yellow
      injection_code = "{{7*7}}"
      test_url = "#{url}/search?q=#{injection_code}"
      test_response = Net::HTTP.get_response(URI.parse(test_url))
      if test_response.body.include?("49")
        puts "The website appears to be vulnerable to CSTI!".red
        puts "To confirm the vulnerability, try injecting the following payload:".yellow
        puts "Payload: {{7*7}}".light_blue
        puts "If the result is 49, then the website is vulnerable.".yellow
      else
        puts "The website does not seem to be vulnerable to CSTI.".green
      end
    else
      puts "Unable to access the website. Response code: #{response.code}".red
    end
  rescue => e
    puts "An error occurred: #{e.message}".red
  end
end

puts "Enter your target website URL: ".yellow
target_website = gets.chomp

test_csti_vulnerability(target_website)
