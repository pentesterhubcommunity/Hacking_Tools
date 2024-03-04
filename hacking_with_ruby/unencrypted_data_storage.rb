require 'net/http'
require 'colorize'

def test_unencrypted_data_storage_vulnerability(url)
  uri = URI(url)
  
  begin
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
  
    request = Net::HTTP::Get.new('/')
    response = http.request(request)
  
    if response['x-content-type-options'].nil?
      puts "[!] The website does not have the 'X-Content-Type-Options' header set. This may indicate vulnerability to Unencrypted Data Storage.".colorize(:red)
      puts "[i] Recommendation: Ensure that the 'X-Content-Type-Options' header is set to 'nosniff' to mitigate this vulnerability.".colorize(:yellow)
    else
      puts "[+] The website has the 'X-Content-Type-Options' header set. Not vulnerable to Unencrypted Data Storage.".colorize(:green)
    end
  rescue StandardError => e
    puts "[-] An error occurred while testing the website: #{e.message}".colorize(:red)
  end
end

def main
  puts "Enter the target website URL (e.g., https://example.com):"
  target_url = gets.chomp
  
  puts "\nTesting Unencrypted Data Storage vulnerability for #{target_url}...\n".colorize(:yellow)
  test_unencrypted_data_storage_vulnerability(target_url)
end

main
