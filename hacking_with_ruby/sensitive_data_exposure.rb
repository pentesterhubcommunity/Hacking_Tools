require 'net/http'
require 'concurrent'

def fetch_url(url)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == "https")
  request = Net::HTTP::Get.new(uri)
  response = http.request(request)
  { url: url, response: response }
rescue StandardError => e
  { url: url, error: e }
end

def test_sensitive_data_exposure(urls)
  sensitive_data_keywords = ['password', 'api_key', 'private_key', 'secret', 'token', 'credentials', 'auth_token', 'access_token', 
                             'username', 'email', 'ssn', 'social_security_number', 'credit_card', 'cc_number', 'credit_card_number', 
                             'bank_account', 'bank_account_number', 'routing_number', 'ssn', 'date_of_birth']

  futures = []
  responses = []

  urls.each do |url|
    futures << Concurrent::Future.execute { fetch_url(url) }
  end

  futures.each do |future|
    response = future.value
    responses << response
  end

  responses.each do |response|
    if response[:error]
      puts "Error accessing #{response[:url]}: #{response[:error].message}"
    elsif response[:response].is_a?(Net::HTTPSuccess)
      content_type = response[:response].content_type
      if content_type && content_type.include?('text/html')
        sensitive_data_keywords.each do |keyword|
          if response[:response].body.include?(keyword)
            puts "Potential sensitive data found at: #{response[:url]}"
            break
          end
        end
      end
    end
  end
end

def main
  print "Enter the target website URL (comma-separated if multiple): "
  urls = gets.chomp.split(',').map(&:strip)
  test_sensitive_data_exposure(urls)
end

main if __FILE__ == $PROGRAM_NAME
