require 'open-uri'
require 'nokogiri'
require 'colorize'

def test_vulnerability(url)
  puts "Testing CMS Information Disclosure Vulnerabilities for #{url}...".yellow
  begin
    html = URI.open(url).read
    doc = Nokogiri::HTML(html)
    meta_tags = doc.css('meta[name]').map { |meta| meta['name'] }
    if meta_tags.include?('generator')
      generator_content = doc.at('meta[name="generator"]')['content']
      puts "Vulnerability Found!".red
      puts "The website is disclosing CMS information:".red
      puts "Generator meta tag found with content: #{generator_content}".red
      puts "To exploit this vulnerability, an attacker can perform fingerprinting to determine the CMS version and potentially exploit known vulnerabilities.".red
    else
      puts "No vulnerability found.".green
    end
  rescue StandardError => e
    puts "An error occurred while testing for vulnerability: #{e.message}".red
  end
end

print "Enter your target website url: "
target_url = gets.chomp

test_vulnerability(target_url)
