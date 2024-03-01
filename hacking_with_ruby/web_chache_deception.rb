require 'net/http'
require 'colorize'

def test_web_cache_deception(url)
  # Craft different HTTP methods
  http_methods = ['GET', 'POST', 'PUT', 'DELETE']
  
  # Random User-Agent strings
  user_agents = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
    'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
  ]
  
  # Create a queue of requests
  queue = Queue.new
  http_methods.each do |method|
    user_agents.each do |user_agent|
      queue << { method: method, user_agent: user_agent }
    end
  end
  
  # Create worker threads
  workers = (0...10).map do
    Thread.new do
      until queue.empty?
        request_data = queue.pop(true) rescue nil
        next if request_data.nil?
        
        method = request_data[:method]
        user_agent = request_data[:user_agent]
        
        response = send_request(url, method, user_agent)
        
        if response
          if response.code.to_i == 200
            puts "Response for #{method} request with #{user_agent}: #{response.code}".green
          else
            puts "Response for #{method} request with #{user_agent}: #{response.code}".red
          end
        else
          puts "Failed to retrieve response for #{method} request with #{user_agent}".yellow
        end
      end
    end
  end
  
  # Wait for all threads to finish
  workers.each(&:join)
end

def send_request(url, method, user_agent)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == 'https')
  
  request = Net::HTTP.const_get(method.capitalize).new(uri.request_uri)
  request['User-Agent'] = user_agent
  
  http.request(request)
end

# Prompt user for target website URL
puts "Enter your target website URL: "
target_website_url = gets.chomp

# Example usage:
test_web_cache_deception(target_website_url)
