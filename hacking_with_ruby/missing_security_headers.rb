require 'net/http'
require 'colorize'

def check_security_headers(url, method)
  begin
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
    end
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    security_headers = {
      'X-Frame-Options' => 'DENY',
      'X-XSS-Protection' => '1; mode=block',
      'X-Content-Type-Options' => 'nosniff',
      'Content-Security-Policy' => "default-src 'none';"
    }

    missing_headers = []

    security_headers.each do |header, value|
      unless response[header]
        missing_headers << header
      end
    end

    if missing_headers.empty?
      puts "No missing security headers found for #{url}".green
    else
      puts "Missing security headers for #{url}:".red
      missing_headers.each do |header|
        puts "#{header}: #{security_headers[header]}".yellow
        explain_header(header)
        suggest_mitigation(header)
      end
    end
  rescue StandardError => e
    puts "Error: #{e.message}".red
  end
end

def explain_header(header)
  case header
  when 'X-Frame-Options'
    puts "X-Frame-Options: This header mitigates clickjacking attacks by preventing the page from being loaded in a frame.".light_red
  when 'X-XSS-Protection'
    puts "X-XSS-Protection: This header enables the browser's Cross-site Scripting (XSS) filter.".light_red
  when 'X-Content-Type-Options'
    puts "X-Content-Type-Options: This header prevents browsers from MIME-sniffing a response away from the declared content-type.".light_red
  when 'Content-Security-Policy'
    puts "Content-Security-Policy: This header helps mitigate XSS attacks and other cross-site injections.".light_red
  end
end

def suggest_mitigation(header)
  case header
  when 'X-Frame-Options'
    puts "Suggestion: Set 'X-Frame-Options' header to 'DENY' or 'SAMEORIGIN' to prevent clickjacking.".light_red
  when 'X-XSS-Protection'
    puts "Suggestion: Enable XSS protection by setting 'X-XSS-Protection' header to '1; mode=block'.".light_red
  when 'X-Content-Type-Options'
    puts "Suggestion: Add 'X-Content-Type-Options' header with value 'nosniff' to prevent MIME-sniffing attacks.".light_red
  when 'Content-Security-Policy'
    puts "Suggestion: Implement a Content Security Policy (CSP) to define allowed sources for content.".light_red
  end
end

loop do
  puts "Enter your target website URL or 'exit' to quit: "
  target_website = gets.chomp
  break if target_website.downcase == 'exit'

  puts "Enter HTTP method (GET, POST, etc.): "
  http_method = gets.chomp.upcase

  check_security_headers(target_website, http_method)
end
