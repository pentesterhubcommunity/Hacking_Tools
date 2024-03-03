require 'net/http'
require 'colorize'

def test_session_hijacking(target_url)
  uri = URI(target_url)
  
  # Handle HTTPS URLs
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri.scheme == 'https'

  # Set a random user-agent header
  user_agents = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:54.0) Gecko/20100101 Firefox/54.0",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36"
  ]
  http_headers = {'User-Agent': user_agents.sample}

  begin
    response = http.get(uri.request_uri, http_headers)
    
    if response.code == '200'
      if response['Set-Cookie']
        session_cookie = response['Set-Cookie'].split(';').first
        puts "Session cookie obtained: #{session_cookie}".green
        puts "Simulating session hijacking...".yellow
        puts "Hijacked session cookie: #{session_cookie}".red
      else
        puts "Session cookie not found in response headers.".yellow
      end
    else
      puts "Failed to obtain session cookie. Server returned: #{response.code} - #{response.message}".red
    end
  rescue StandardError => e
    puts "An error occurred: #{e.message}".red
  end
end

# Main program
puts "Enter your target website URL: "
target_url = gets.chomp

puts "Testing for session hijacking vulnerability in #{target_url}...\n".blue

test_session_hijacking(target_url)
