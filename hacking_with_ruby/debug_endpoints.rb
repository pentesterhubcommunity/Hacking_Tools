require 'net/http'
require 'uri'
require 'colorize'

def test_debug_endpoints(url)
  puts "Testing for Exposed Debug Endpoints on #{url}...".colorize(:yellow)
  puts "-----------------------------".colorize(:yellow)
  
  debug_endpoints = [
    'debug', 'debug.php', 'debug.aspx', 'debug.jsp', 'debug.py', 'debug.rb', 'debug.pl',
    'test', 'test.php', 'test.aspx', 'test.jsp', 'test.py', 'test.rb', 'test.pl',
    'dev', 'dev.php', 'dev.aspx', 'dev.jsp', 'dev.py', 'dev.rb', 'dev.pl',
    'logs', 'logs.php', 'logs.aspx', 'logs.jsp', 'logs.py', 'logs.rb', 'logs.pl',
    'admin', 'admin.php', 'admin.aspx', 'admin.jsp', 'admin.py', 'admin.rb', 'admin.pl',
    'info', 'info.php', 'info.aspx', 'info.jsp', 'info.py', 'info.rb', 'info.pl',
    'status', 'status.php', 'status.aspx', 'status.jsp', 'status.py', 'status.rb', 'status.pl'
  ]
  
  vulnerable_endpoints = []
  
  debug_endpoints.each do |endpoint|
    endpoint_url = "#{url}/#{endpoint}"
    puts "Checking #{endpoint_url}...".colorize(:light_blue)
    
    uri = URI.parse(endpoint_url)
    response = Net::HTTP.get_response(uri)
    
    if response.code == "200"
      vulnerable_endpoints << endpoint_url
      puts "#{endpoint_url} is vulnerable!".colorize(:red)
    else
      puts "#{endpoint_url} is not vulnerable.".colorize(:green)
    end
  end
  
  puts "-----------------------------".colorize(:yellow)
  
  if vulnerable_endpoints.empty?
    puts "No Exposed Debug Endpoints found on #{url}.".colorize(:green)
  else
    puts "Vulnerable endpoints found:".colorize(:red)
    vulnerable_endpoints.each { |endpoint| puts "  #{endpoint}" }
  end
end

def test_vulnerability(url)
  test_debug_endpoints(url)
end

def main()
  puts "Enter your target website url: ".colorize(:yellow)
  target_website = gets.chomp.strip
  
  test_vulnerability(target_website)
end

main()
