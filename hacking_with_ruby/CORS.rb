require 'net/http'
require 'uri'
require 'colorize'

# Function to send HTTP request and check CORS headers
def check_cors(url, verbose: false, custom_origins: [])
  puts "Checking CORS headers for #{url}...".cyan

  threads = []
  origins = ['https://evil.com', 'null', 'file://', 'ftp://', 'http://example.com'] + custom_origins

  origins.each do |origin|
    threads << Thread.new do
      begin
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        request = Net::HTTP::Options.new(uri.request_uri, {
          'Origin' => origin,
          'User-Agent' => random_user_agent
        })

        response = http.request(request)
        headers = response.to_hash

        # Check for Access-Control-Allow-Origin header
        if headers.key?('access-control-allow-origin')
          origin_value = headers['access-control-allow-origin'][0]
          if origin_value == '*' || origin_value.include?('https://evil.com')
            puts "Vulnerability Detected: Misconfigured CORS".red
            puts "Origin: #{origin_value}".yellow
            puts "To exploit this vulnerability, you can make cross-origin requests from the specified origin.".yellow
            puts "Example: curl -H 'Origin: #{origin_value}' #{url}".yellow
          else
            puts "CORS is properly configured for #{origin}".green if verbose
          end
        else
          puts "CORS is not enabled or improperly configured for #{origin}".yellow if verbose
        end
      rescue StandardError => e
        puts "Error occurred while checking CORS for #{origin}: #{e.message}".red
      end
    end
  end

  threads.each(&:join)
end

# Function to generate random User-Agent header
def random_user_agent
  user_agents = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Safari/605.1.15',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/96.0.1054.57'
  ]
  user_agents.sample
end

# Function to ask for user input for target website URL
def get_target_website_url
  print "Enter your target website URL: "
  gets.chomp
end

# Main program logic
def main
  puts "Testing for Misconfigured CORS vulnerability...".cyan
  url = get_target_website_url
  check_cors(url, verbose: true)
end

# Run the program
main
