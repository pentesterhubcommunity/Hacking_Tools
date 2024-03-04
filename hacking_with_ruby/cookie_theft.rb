require 'httparty'
require 'colorize'

def test_cookie_theft_vulnerability(url)
  begin
    response = HTTParty.get(url)
    if response.success?
      cookie = response.headers['set-cookie']
      if cookie.nil?
        puts "No cookies found in the response headers.".red
      else
        puts "Cookie Theft vulnerability test result for #{url}:".green
        puts "-----------------------------------------------".green
        puts "Cookie: #{cookie}".red
        puts "\n"
        puts "How to test this vulnerability:".blue
        puts "1. Copy the cookie value.".blue
        puts "2. Open another browser or incognito window.".blue
        puts "3. Paste the copied cookie value and access the website.".blue
        puts "4. If you can access the website without logging in, it indicates a Cookie Theft vulnerability.".blue
      end
    else
      puts "Failed to retrieve the page. HTTP Status Code: #{response.code}".red
    end
  rescue StandardError => e
    puts "An error occurred: #{e.message}".red
  end
end

puts "Enter the target website URL:".yellow
target_url = gets.chomp

test_cookie_theft_vulnerability(target_url)
