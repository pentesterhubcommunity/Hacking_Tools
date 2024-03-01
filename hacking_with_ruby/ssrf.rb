require 'net/http'

def test_ssrf_vulnerability(url)
  uri = URI.parse(url)

  # Check if the URI scheme is allowed
  if ['http', 'https'].include?(uri.scheme)
    response = Net::HTTP.get_response(uri)
    
    # Check if the response status code indicates a successful request
    if response.code.to_i == 200
      puts "Vulnerability found: #{url} is vulnerable to SSRF."
    else
      puts "#{url} is not vulnerable to SSRF."
    end
  else
    puts "Invalid URI scheme: #{uri.scheme}. SSRF may not be possible."
  end
rescue URI::InvalidURIError => e
  puts "Invalid URL: #{url}. #{e.message}"
rescue SocketError => e
  puts "Failed to connect to #{url}. #{e.message}"
rescue => e
  puts "An error occurred: #{e.message}"
end

puts "Enter your target website url: "
target_url = gets.chomp

# Example usage:
test_ssrf_vulnerability(target_url)
