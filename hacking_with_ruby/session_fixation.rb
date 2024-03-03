require 'uri'
require 'net/http'
require 'securerandom'
require 'colorize'

def test_session_fixation_vulnerability(target_url)
  # Generate a random session ID to simulate attacker's session
  attacker_session_id = SecureRandom.hex(16)

  # Create a new session with the attacker's session ID
  uri = URI.parse(target_url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri.scheme == 'https'  # Enable SSL if the target URL uses HTTPS
  request = Net::HTTP::Get.new(uri.request_uri)
  request['Cookie'] = "sessionid=#{attacker_session_id}"

  begin
    # Send the request to the target website
    response = http.request(request)

    # Check if the session ID is fixed
    if response['Set-Cookie']&.include?('sessionid') && response['Set-Cookie'].include?(attacker_session_id)
      puts "Session Fixation vulnerability found!".colorize(:red)
      puts "Attacker's session ID: #{attacker_session_id}".colorize(:yellow)
    else
      puts "Session Fixation vulnerability not found.".colorize(:green)
    end
  rescue StandardError => e
    puts "An error occurred: #{e.message}".colorize(:red)
  end
end

def test_instructions
  puts "To test for Session Fixation vulnerability, follow these steps:".colorize(:light_blue)
  puts "1. Open a web browser and navigate to the target website."
  puts "2. Capture the session ID cookie value from a legitimate user's session."
  puts "3. Run this program and provide the target website URL when prompted."
  puts "4. This program will simulate fixing the session to an attacker's session."
  puts "5. Check the program output to see if the vulnerability is present.".colorize(:light_blue)
end

def main
  puts "Enter your target website URL: ".colorize(:cyan)
  target_url = gets.chomp.strip

  test_instructions

  test_session_fixation_vulnerability(target_url)
end

main
