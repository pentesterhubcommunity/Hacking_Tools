require 'uri'
require 'net/http'
require 'colorize'

def test_http_request_smuggling(target_url)
  puts "Testing for HTTP Request Smuggling vulnerability on #{target_url}...".yellow
  
  target_uri = URI.parse(target_url)
  http = Net::HTTP.new(target_uri.host, target_uri.port)
  http.use_ssl = (target_uri.scheme == 'https')
  
  # Craft a request with Content-Length header split across two lines
  req = Net::HTTP::Post.new(target_uri.request_uri)
  req.body = "Content-Length: 4\r\n"
  req.body << "X: 1\r\n"
  req.body << "\r\n"
  req.body << "1234"
  
  response = http.request(req)
  
  if response.code.to_i == 400 && response.body.include?("400 Bad Request") && response.body.include?("Length Required")
    puts "The target website is likely vulnerable to HTTP Request Smuggling!".red
    puts "To confirm the vulnerability, try sending a request with a smuggled header and see if it's processed differently."
    puts "For example, smuggle a 'Host' header to point to a different server and observe the response."
  else
    puts "The target website is not vulnerable to HTTP Request Smuggling.".green
  end
end

puts "Enter your target website URL:".blue
target_website = gets.chomp

test_http_request_smuggling(target_website)
