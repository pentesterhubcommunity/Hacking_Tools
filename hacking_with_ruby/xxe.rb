require 'net/http'
require 'colorize'
require 'rexml/document'

def test_xxe_vulnerability(url)
  uri = URI.parse(url)
  
  puts "Sending GET request to #{url}...".yellow
  response = Net::HTTP.get_response(uri)
  
  if response.code == '200'
    puts "Target website is accessible.".green
    puts "Analyzing response for potential XXE vulnerability...".yellow
    
    begin
      body = response.body
      xml = REXML::Document.new(body)
      
      if xml.elements['/response'].nil?
        puts "XXE vulnerability not detected.".red
      else
        puts "XXE vulnerability detected!".red
        puts "Here's how to test the vulnerability:".yellow
        puts "1. Craft a malicious XML payload containing an external entity."
        puts "2. Send a POST request to the target website with the crafted XML payload."
      end
    rescue REXML::ParseException => e
      puts "Error parsing XML response: #{e.message}".red
      puts "Consider manually inspecting the response to identify potential vulnerabilities."
    end
  else
    puts "Target website is not accessible or returned an error: #{response.code}".red
  end
end

puts "Enter your target website URL:"
target_url = gets.chomp

test_xxe_vulnerability(target_url)
