require 'shellwords'
require 'uri'

# Function to open URLs in a web browser three at a time
def open_urls_three_at_a_time(urls, index)
  # Base case: if all URLs have been opened
  if index >= urls.length
    puts "All dorking queries have been executed."
    return
  end

  # Open three URLs
  (index...[index + 3, urls.length].min).each do |i|
    system("google-chrome #{Shellwords.escape(urls[i])} &")
    puts "Opening Google Chrome with the dork query: #{urls[i]}"
  end

  # Prompt the user to continue
  print "Press [Enter] to run the next 3 commands (or type 'quit' to exit): "
  answer = gets.chomp.strip
  if answer.downcase == 'quit'
    puts "Exiting..."
    return
  end

  # Recursively open the next set of URLs
  open_urls_three_at_a_time(urls, index + 3)
end

# Main function
def main
  # List to store dork queries
  queries = [
    "site:{target_domain} inurl:login",
    "site:{target_domain} intitle:index.of",
    "site:{target_domain} intext:password",
    "site:{target_domain} filetype:pdf",
    "site:{target_domain} inurl:admin",
    "site:{target_domain} intitle:admin",
    "site:{target_domain} intitle:dashboard",
    "site:{target_domain} intitle:config OR site:{target_domain} intitle:configuration",
    "site:{target_domain} intitle:setup",
    "site:{target_domain} intitle:phpinfo",
    # Add more queries here...
  ]

  # Additional queries
  additional_queries = [
    "site:{target_domain} inurl:wp-admin",
    "site:{target_domain} inurl:wp-content",
    "site:{target_domain} inurl:wp-includes",
    "site:{target_domain} inurl:wp-login",
    "site:{target_domain} inurl:wp-config",
    "site:{target_domain} inurl:wp-config.txt",
    "site:{target_domain} inurl:wp-config.php",
    "site:{target_domain} inurl:wp-config.php.bak",
    "site:{target_domain} inurl:wp-config.php.old",
    "site:{target_domain} inurl:wp-config.php.save",
    "site:{target_domain} inurl:wp-config.php.swp",
    "site:{target_domain} inurl:wp-config.php~",
    "site:{target_domain} inurl:wp-config.bak",
    "site:{target_domain} inurl:wp-config.old",
    "site:{target_domain} inurl:wp-config.save",
    "site:{target_domain} inurl:wp-config.swp",
    "site:{target_domain} inurl:wp-config~",
    "site:{target_domain} inurl:.env",
    "site:{target_domain} inurl:credentials",
    "site:{target_domain} inurl:connectionstrings",
    "site:{target_domain} inurl:secret_key",
    "site:{target_domain} inurl:api_key",
    "site:{target_domain} inurl:client_secret",
    "site:{target_domain} inurl:auth_key",
    "site:{target_domain} inurl:access_key",
    "site:{target_domain} inurl:backup",
    "site:{target_domain} inurl:dump",
    "site:{target_domain} inurl:logs",
    "site:{target_domain} inurl:conf",
    "site:{target_domain} inurl:db",
    "site:{target_domain} inurl:sql",
    "site:{target_domain} inurl:root",
    "site:{target_domain} inurl:confidential",
    "site:{target_domain} inurl:database",
    "site:{target_domain} inurl:passed"
    # Add more queries here...
  ]

  queries += additional_queries

  # Prompt for target domain
  print "Enter your target domain (e.g., example.com): "
  target_domain = gets.chomp.strip

  # Construct URLs with target domain
  urls = queries.map { |query| "https://www.google.com/search?q=#{URI.encode_www_form_component(query.gsub('{target_domain}', target_domain))}" }

  # Start opening URLs three at a time
  open_urls_three_at_a_time(urls, 0)
end

# Run the main function
main
