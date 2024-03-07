require 'open-uri'
require 'colorize'

def check_information_disclosure(url)
  puts "Checking for Information Disclosure vulnerability on #{url}...".yellow

  begin
    response = URI.open(url).read
  rescue OpenURI::HTTPError => e
    puts "Error: #{e}".red
    return
  end

  if response.include?("<!--DEBUG INFO-->") || response.include?("debug=true")
    puts "Information Disclosure vulnerability found!".red
    puts "Vulnerable information:".red
    puts response.scan(/<!--DEBUG INFO-->(.*?)<!--\/DEBUG INFO-->/m).flatten.join("\n")
    puts response.scan(/debug_info=(.*?)(&|$)/).flatten.join("\n")
  else
    puts "No Information Disclosure vulnerability found.".green
  end
end

def bypass_protection(url)
  puts "Attempting to bypass protection system...".yellow

  # More bypass techniques
  techniques = [
    "/admin",
    "/admin.php",
    "/?debug=true",
    "/?admin=true",
    "/test.php",
    "/login.php",
    "/debug.log",
    "/error.log",
    "/.git/config",
    "/wp-config.php",
    "/.env",
    "/phpinfo.php",
    "/robots.txt",
    "/.git/HEAD",
    "/.gitignore",
    "/.htaccess",
    "/config.php",
    "/config/config.ini",
    "/config/config.yml",
    "/server-status",
    "/phpmyadmin",
    "/admin",
    "/login",
    "/console",
    "/backup",
    "/database",
    "/backup.sql",
    "/.svn/",
    "/.svn/entries",
    "/WEB-INF/web.xml",
    "/META-INF/MANIFEST.MF",
    "/META-INF/context.xml",
    "/WEB-INF/applicationContext.xml",
    "/WEB-INF/classes/application.properties",
    "/WEB-INF/web.xml",
    "/config/database.yml",
    "/server/config/db.php",
    "/.bash_history",
    "/.bashrc",
    "/.bash_profile",
    "/.ssh/authorized_keys",
    "/.svn/wc.db",
    "/.svn/entries",
    "/.svn/text-base/config.php.svn-base",
    "/.svn/text-base/wp-config.php.svn-base"
  ]

  success = false
  techniques.each do |technique|
    begin
      response = URI.open(url + technique).read
      puts "Bypass successful with technique: #{technique}".green
      puts "Response:".green
      puts response
      success = true
      break
    rescue OpenURI::HTTPError => e
      puts "Bypass failed with technique: #{technique}".red
    end
  end

  puts "Failed to bypass protection system.".red unless success
end

def manual_check_instructions
  puts "\nTo manually check for Information Disclosure vulnerability:".blue
  puts "1. Inspect the HTML source code of the website."
  puts "2. Look for comments, hidden fields, or any other indicators of sensitive information."
  puts "3. Check for debug information or development-related comments."
  puts "4. Verify if any sensitive data is exposed in the response."
end

# Main program
puts "Welcome to the Information Disclosure Vulnerability Tester".blue
puts "Enter your target website URL:"
target_url = gets.chomp.strip

check_information_disclosure(target_url)
bypass_protection(target_url)
manual_check_instructions
