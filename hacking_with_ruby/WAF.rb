require 'colorize'
require 'open-uri'

def check_vulnerability(url)
  puts "Testing for Web Application Firewall (WAF) evasion on: #{url}".yellow
  response = open(url).read
  if response.include?("WAF detected")
    puts "The target website is protected by a Web Application Firewall (WAF).".red
    puts "This indicates that the website might not be vulnerable to common WAF evasion techniques."
    puts "Consider trying different techniques or conducting further analysis.".red
  else
    puts "The target website does not seem to be protected by a Web Application Firewall (WAF).".green
    puts "This might indicate a potential vulnerability to WAF evasion techniques.".green
    puts "Consider further testing to confirm.".green
  end
end

def test_vulnerability(url)
  puts "Testing for WAF evasion vulnerability on: #{url}".yellow
  response = open(url).read
  if response.include?("WAF detected")
    puts "WAF detected! The website is protected by a Web Application Firewall.".red
    puts "Consider trying different evasion techniques or conduct further analysis.".red
  else
    puts "No WAF detected! The website might be vulnerable to WAF evasion techniques.".green
    puts "Try testing for common evasion techniques like SQL injection, XSS, or protocol smuggling.".green
  end
end

def main_menu
  puts "Welcome to the WAF Evasion Tester!".cyan
  puts "Please select an option:"
  puts "1. Test for WAF evasion vulnerability"
  puts "2. Check if target website is protected by WAF"
  puts "3. Exit"
  print "Enter your choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    print "Enter the target website URL: "
    target_url = gets.chomp
    test_vulnerability(target_url)
  when 2
    print "Enter the target website URL: "
    target_url = gets.chomp
    check_vulnerability(target_url)
  when 3
    puts "Exiting program...".cyan
    exit
  else
    puts "Invalid choice! Please select a valid option.".red
    main_menu
  end
end

main_menu
