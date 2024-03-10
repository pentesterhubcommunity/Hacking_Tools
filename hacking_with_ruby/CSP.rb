require 'open-uri'
require 'colorize'

def test_csp_bypass(target_url)
  puts "Testing for CSP Bypass on #{target_url}...".yellow
  begin
    response = URI.open(target_url)
    csp_header = response.meta['content-security-policy']
    if csp_header.nil? || csp_header.empty?
      puts "No Content Security Policy found. The website might be vulnerable.".red
      puts "To test the vulnerability, try injecting inline scripts or styles."
      puts "For example, try adding <script>alert('CSP Bypass!')</script> to the HTML.".green
    else
      puts "Content Security Policy found:".green
      puts csp_header
      puts "The website might not be vulnerable to CSP bypass.".red
    end
  rescue OpenURI::HTTPError => e
    puts "Error: #{e}".red
  end
end

def main
  puts "Enter your target website URL:".yellow
  target_url = gets.chomp
  test_csp_bypass(target_url)
end

main
