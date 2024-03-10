require 'open-uri'
require 'nokogiri'
require 'colorize'

def test_dom_clobbering(target_url)
  puts "Testing for DOM Clobbering vulnerability on #{target_url}...".yellow
  begin
    # Fetch the HTML content of the target website
    html_content = URI.open(target_url).read

    # Parse the HTML content using Nokogiri
    doc = Nokogiri::HTML(html_content)

    # Check if any element with a common JavaScript object name is present
    vulnerable = doc.xpath("//script").any? do |script|
      script.content.include?('document')
    end

    if vulnerable
      puts "The target website is vulnerable to DOM Clobbering!".red
      puts "To exploit this vulnerability, an attacker could inject malicious JavaScript code by overwriting the document object properties.".red
      puts "For example, an attacker could overwrite document.location.href to redirect users to a phishing website.".red
    else
      puts "The target website is not vulnerable to DOM Clobbering.".green
    end
  rescue StandardError => e
    puts "An error occurred while testing the website: #{e.message}".red
  end
end

def main
  puts "Enter your target website URL:".cyan
  target_url = gets.chomp

  test_dom_clobbering(target_url)
end

main
